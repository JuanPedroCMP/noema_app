import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/device_fingerprint.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const _backupLocalRef = 'primary-snapshot';
const _driveSnapshotName = 'noema-local-snapshot.json';

void _logGoogleDrive(String message, {StackTrace? stackTrace}) {
  developer.log(message, name: 'GoogleDriveSync', stackTrace: stackTrace);
}

enum DriveSyncResolution { keepLocal, keepRemote, merge, reconcileMetadata }

class DriveSyncProgress {
  const DriveSyncProgress(this.label, this.fraction);

  final String label;
  final double? fraction;
}

class DriveSyncPreview {
  const DriveSyncPreview({
    required this.accountId,
    required this.deviceId,
    required this.localUserId,
    required this.remoteUserId,
    required this.localSnapshot,
    required this.remoteSnapshot,
    required this.driveFile,
    required this.backup,
    required this.diff,
  });

  final String accountId;
  final String deviceId;
  final String localUserId;
  final String remoteUserId;
  final LocalSnapshot localSnapshot;
  final LocalSnapshot? remoteSnapshot;
  final DriveFileInfo? driveFile;
  final BackupFileOut? backup;
  final SnapshotDiff? diff;

  bool get requiresDecision =>
      remoteSnapshot != null && diff != null && !diff!.isEmpty;

  bool get metadataNeedsRepair {
    final file = driveFile;
    final remote = remoteSnapshot;
    final metadata = backup;
    return file != null &&
        remote != null &&
        (metadata == null ||
            metadata.driveVersion != file.version ||
            metadata.contentHash != remote.contentHash);
  }
}

class DriveSyncResult {
  const DriveSyncResult({required this.message, this.warning});

  final String message;
  final String? warning;
}

class DriveSyncException implements Exception {
  const DriveSyncException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class GoogleDriveSyncService {
  GoogleDriveSyncService(this._ref);

  final Ref _ref;

  Future<GoogleAccountStatusOut> getAccountStatus() async {
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveOAuthApi()
        .googleAccountStatusApiV1GoogleDriveAccountStatusGet();
    final status = response.data;
    if (status == null) {
      throw const DriveSyncException(
        'O servidor não retornou o status da conta Google.',
      );
    }
    return status;
  }

  Options get _authenticatedApiOptions => Options(
    extra: {
      'secure': [
        {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
      ],
    },
  );

  Future<GoogleAccountStatusOut> _runServerOAuth() async {
    final api = _ref.read(apiClientProvider);
    final callbackUri = Uri.parse(
      api.dio.options.baseUrl,
    ).resolve('/api/v1/google_drive/oauth/callback');
    final start = await api.dio.post<Object>(
      '/api/v1/google_drive/oauth/start',
      data: {'redirect_uri': callbackUri.toString()},
      options: _authenticatedApiOptions,
    );
    final body = start.data;
    if (body is! Map ||
        body['authorization_url'] is! String ||
        body['state'] is! String) {
      throw const DriveSyncException(
        'O servidor não retornou os dados necessários para iniciar o OAuth.',
        code: 'google_oauth_start_invalid',
      );
    }

    final authorizationUri = Uri.tryParse(body['authorization_url'] as String);
    if (authorizationUri == null ||
        authorizationUri.scheme != 'https' ||
        authorizationUri.host != 'accounts.google.com') {
      throw const DriveSyncException(
        'O servidor retornou uma URL OAuth inválida.',
        code: 'google_oauth_url_invalid',
      );
    }
    if (!await launchUrl(
      authorizationUri,
      mode: LaunchMode.externalApplication,
    )) {
      throw const DriveSyncException(
        'Não foi possível abrir a página de autorização do Google.',
        code: 'google_oauth_browser_unavailable',
      );
    }

    final state = body['state'] as String;
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < const Duration(minutes: 4)) {
      await Future<void>.delayed(const Duration(seconds: 2));
      try {
        final response = await api.dio.post<Object>(
          '/api/v1/google_drive/account/complete',
          data: {'state': state},
          options: _authenticatedApiOptions,
        );
        final raw = response.data;
        if (raw == null) {
          throw const DriveSyncException(
            'O servidor não retornou o resultado da autorização Google.',
            code: 'google_oauth_completion_empty',
          );
        }
        final status =
            api.serializers.deserialize(
                  raw,
                  specifiedType: const FullType(GoogleAccountStatusOut),
                )
                as GoogleAccountStatusOut;
        if (!status.syncAvailable || status.accountId == null) {
          throw _statusException(status);
        }
        return status;
      } on DioException catch (error) {
        final code = _apiErrorCode(error.response?.data);
        if (code == 'oauth_completion_pending') continue;
        if (code == 'oauth_authorization_cancelled') {
          throw const DriveSyncException(
            'A autorização Google foi cancelada. Nenhuma alteração foi feita.',
            code: 'google_sign_in_canceled',
          );
        }
        if (code != null) {
          throw DriveSyncException(
            'O Google não concluiu a autorização ($code).',
            code: code,
          );
        }
        rethrow;
      }
    }
    throw const DriveSyncException(
      'A autorização ainda não foi concluída. Volte à janela do Google e tente novamente.',
      code: 'google_oauth_timeout',
    );
  }

  String? _apiErrorCode(Object? data) {
    if (data is Map && data['detail'] is Map) {
      final code = (data['detail'] as Map)['code'];
      return code is String ? code : null;
    }
    return null;
  }

  Future<List<BackupFileOut>> listBackups(String accountId) async {
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveSyncApi()
        .listBackupsApiV1GoogleDriveBackupsGet(
          filters: BackupFileFilters(
            (builder) => builder..idGoogleAccount = accountId,
          ),
          limit: 100,
          offset: 0,
        );
    final backups = response.data;
    if (backups == null) {
      throw const DriveSyncException(
        'O servidor não retornou a lista de arquivos de backup.',
      );
    }
    return backups.toList()
      ..sort((a, b) => _backupDate(b).compareTo(_backupDate(a)));
  }

  Future<List<SyncLogOut>> listSyncHistory(String accountId) async {
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveSyncApi()
        .listSyncLogApiV1GoogleDriveSyncLogListGet(
          filters: SyncLogFilters(
            (builder) => builder..idGoogleAccount = accountId,
          ),
          limit: 100,
          offset: 0,
        );
    final history = response.data;
    if (history == null) {
      throw const DriveSyncException(
        'O servidor não retornou o histórico de sincronização.',
      );
    }
    return history.toList()..sort(
      (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
    );
  }

  Future<GoogleAccountStatusOut> connectGoogleAccount() async {
    _logGoogleDrive('Starting backend-owned Google OAuth.');
    return _runServerOAuth();
  }

  Future<GoogleAccountStatusOut> repairGoogleAuthorization() async {
    _logGoogleDrive('Starting backend-owned Google OAuth reauthorization.');
    return _runServerOAuth();
  }

  Future<bool> unlinkGoogleAccount(String accountId) async {
    if (accountId.isEmpty) {
      throw const DriveSyncException(
        'Não foi possível identificar a conta Google vinculada.',
      );
    }
    final response = await _ref
        .read(apiClientProvider)
        .dio
        .delete<Object>(
          '/api/v1/google_drive/account/unlink',
          options: _authenticatedApiOptions,
        );
    final body = response.data;
    if (body is! Map || body['unlinked'] != true) {
      throw const DriveSyncException(
        'O servidor não confirmou o desvínculo da conta Google.',
        code: 'google_unlink_unconfirmed',
      );
    }
    return body['google_grant_revoked'] == true;
  }

  Future<DriveSyncPreview> prepareSync({
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    onProgress?.call(const DriveSyncProgress('Autorizando o Google…', null));
    final status = await getAccountStatus();
    if (!status.syncAvailable || status.accountId == null) {
      throw _statusException(status);
    }

    final user = await _ref.read(userProvider.future);
    final database = _ref.read(appDatabaseProvider);
    final deviceId = await _getOrCreateServerDevice(user.remoteId);
    final local = await LocalSnapshot.create(
      database: database,
      localUserId: user.id,
      remoteUserId: user.remoteId,
    );
    var previewReady = false;
    try {
      onProgress?.call(
        const DriveSyncProgress('Verificando o backup no Google Drive…', null),
      );
      final syncApi = _ref.read(apiClientProvider).getGoogleDriveSyncApi();
      final listed = await syncApi.listBackupsApiV1GoogleDriveBackupsGet(
        filters: BackupFileFilters(
          (builder) => builder
            ..idGoogleAccount = status.accountId
            ..localRef = _backupLocalRef
            ..operationState = BackupOperationState.completed,
        ),
        limit: 100,
        offset: 0,
      );
      final backups = listed.data?.toList() ?? const <BackupFileOut>[];
      backups.sort((a, b) => _backupDate(b).compareTo(_backupDate(a)));
      final backup = backups.firstOrNull;

      DriveFileInfo? driveFile;
      if (backup != null) {
        final version = backup.driveVersion;
        if (version == null || version.isEmpty) {
          throw const DriveSyncException(
            'O servidor não tem uma versão segura para este backup.',
            code: 'drive_revision_conflict',
          );
        }
        driveFile = DriveFileInfo(
          id: backup.driveFileId,
          version: version,
          etag: null,
          sizeBytes: backup.sizeBytes,
          modifiedAt: _backupDate(backup),
        );
      }

      LocalSnapshot? remote;
      if (backup != null && driveFile != null) {
        onProgress?.call(
          const DriveSyncProgress('Baixando e verificando o backup…', null),
        );
        final remoteFile = await _downloadServerBackup(
          accountId: status.accountId!,
          backup: backup,
          onProgress: onProgress,
        );
        try {
          remote = await LocalSnapshot.fromFile(
            file: remoteFile,
            expectedRemoteUserId: user.remoteId,
            expectedContentHash: backup.contentHash,
          );
        } finally {
          await _deleteTemporaryFile(remoteFile);
        }
      }

      final preview = DriveSyncPreview(
        accountId: status.accountId!,
        deviceId: deviceId,
        localUserId: user.id,
        remoteUserId: user.remoteId,
        localSnapshot: local,
        remoteSnapshot: remote,
        driveFile: driveFile,
        backup: backup,
        diff: remote == null
            ? null
            : compareSnapshots(
                local.document['data'] as Map<String, dynamic>,
                remote.document['data'] as Map<String, dynamic>,
              ),
      );
      previewReady = true;
      return preview;
    } on DioException catch (error) {
      _logGoogleDrive(
        'Google Drive sync preview failed '
        '(httpStatus=${error.response?.statusCode ?? "none"}, '
        'type=${error.type.name}, message=${error.message ?? "none"}, '
        'path=${error.requestOptions.uri.path}).',
        stackTrace: error.stackTrace,
      );
      rethrow;
    } on Object catch (error, stackTrace) {
      _logGoogleDrive(
        'Google Drive sync preview failed (${error.runtimeType}).',
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      if (!previewReady && await local.file.exists()) {
        await local.file.delete();
      }
    }
  }

  Future<DriveSyncResult> resolve(
    DriveSyncPreview preview,
    DriveSyncResolution resolution, {
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    final status = await getAccountStatus();
    if (status.accountId != preview.accountId || !status.syncAvailable) {
      throw _statusException(status);
    }

    final currentLocal = await LocalSnapshot.create(
      database: _ref.read(appDatabaseProvider),
      localUserId: preview.localUserId,
      remoteUserId: preview.remoteUserId,
    );
    if (currentLocal.dataHash != preview.localSnapshot.dataHash) {
      await currentLocal.file.delete();
      throw const DriveSyncException(
        'Os dados locais mudaram enquanto a prévia estava aberta. Gere uma nova prévia para evitar sobrescrever alterações.',
        code: 'local_snapshot_changed',
      );
    }
    await currentLocal.file.delete();

    LocalSnapshot? uploadSnapshot;
    String? warning;
    try {
      final remoteSnapshot = preview.remoteSnapshot;
      if (resolution == DriveSyncResolution.reconcileMetadata) {
        if (remoteSnapshot == null || preview.driveFile == null) {
          throw const DriveSyncException(
            'Não existe um backup remoto válido para reconciliar.',
          );
        }
        var backupId = preview.backup?.id;
        var event = 'backup_updated';
        if (preview.backup == null) {
          final created = await _createBackupMetadata(
            snapshot: remoteSnapshot,
            accountId: preview.accountId,
            deviceId: preview.deviceId,
            driveFile: preview.driveFile!,
          );
          backupId = created.id;
          event = 'backup_created';
        } else if (_metadataIsStale(preview)) {
          final updated = await _updateBackupMetadata(
            snapshot: remoteSnapshot,
            backup: preview.backup!,
            driveFile: preview.driveFile!,
          );
          backupId = updated.id;
        }
        warning = await _recordSyncLog(
          preview: preview,
          backupId: backupId,
          direction: SyncDirection.download,
          strategy: ConflictStrategy.keepRemote,
          snapshot: remoteSnapshot,
          event: event,
        );
        return DriveSyncResult(
          message:
              'Os dados já estavam sincronizados; os metadados do backup foram reconciliados.',
          warning: warning,
        );
      }

      if (resolution == DriveSyncResolution.keepRemote) {
        if (remoteSnapshot == null) {
          throw const DriveSyncException(
            'Não existe um backup remoto para restaurar.',
          );
        }
        onProgress?.call(
          const DriveSyncProgress('Restaurando os dados do Drive…', null),
        );
        await LocalSnapshotRepository(
          _ref.read(appDatabaseProvider),
        ).restoreRemote(
          snapshot: remoteSnapshot,
          localUserId: preview.localUserId,
        );
        var backupId = preview.backup?.id;
        if (preview.backup == null) {
          final updated = await _createBackupMetadata(
            snapshot: remoteSnapshot,
            accountId: preview.accountId,
            deviceId: preview.deviceId,
            driveFile: preview.driveFile!,
          );
          backupId = updated.id;
        } else if (_metadataIsStale(preview)) {
          final updated = await _updateBackupMetadata(
            snapshot: remoteSnapshot,
            backup: preview.backup!,
            driveFile: preview.driveFile!,
          );
          backupId = updated.id;
        }
        warning = await _recordSyncLog(
          preview: preview,
          backupId: backupId,
          direction: SyncDirection.download,
          strategy: ConflictStrategy.keepRemote,
          snapshot: remoteSnapshot,
        );
        return DriveSyncResult(
          message: 'Backup do Google Drive restaurado neste dispositivo.',
          warning: warning,
        );
      }

      if (resolution == DriveSyncResolution.merge) {
        if (remoteSnapshot == null) {
          throw const DriveSyncException(
            'Não existe um backup remoto para mesclar.',
          );
        }
        onProgress?.call(
          const DriveSyncProgress(
            'Mesclando registros locais e remotos…',
            null,
          ),
        );
        uploadSnapshot =
            await LocalSnapshotRepository(_ref.read(appDatabaseProvider)).merge(
              local: preview.localSnapshot,
              remote: remoteSnapshot,
              localUserId: preview.localUserId,
              remoteUserId: preview.remoteUserId,
            );
      } else {
        uploadSnapshot = preview.localSnapshot;
      }

      onProgress?.call(
        const DriveSyncProgress('Enviando backup pelo servidor seguro…', null),
      );
      final backup = await _uploadServerSnapshot(
        accountId: preview.accountId,
        backup: preview.backup,
        snapshot: uploadSnapshot,
        onProgress: onProgress,
      );
      warning = await _recordSyncLog(
        preview: preview,
        backupId: backup.id,
        direction: SyncDirection.upload,
        strategy: resolution == DriveSyncResolution.merge
            ? ConflictStrategy.merge
            : ConflictStrategy.keepLocal,
        snapshot: uploadSnapshot,
        event: preview.backup == null ? 'backup_created' : 'backup_updated',
      );
      return DriveSyncResult(
        message: resolution == DriveSyncResolution.merge
            ? 'Os dados foram mesclados e o backup atualizado.'
            : 'Backup local enviado e confirmado pelo servidor.',
        warning: warning,
      );
    } catch (error, stackTrace) {
      if (error is DioException) {
        _logGoogleDrive(
          'Google Drive sync resolution failed '
          '(httpStatus=${error.response?.statusCode ?? "none"}, '
          'type=${error.type.name}, message=${error.message ?? "none"}, '
          'path=${error.requestOptions.uri.path}).',
          stackTrace: error.stackTrace,
        );
      } else {
        _logGoogleDrive(
          'Google Drive sync resolution failed (${error.runtimeType}).',
          stackTrace: stackTrace,
        );
      }
      if (uploadSnapshot != null &&
          uploadSnapshot.file.path != preview.localSnapshot.file.path &&
          await uploadSnapshot.file.exists()) {
        await uploadSnapshot.file.delete();
      }
      rethrow;
    } finally {
      if (uploadSnapshot != null &&
          uploadSnapshot.file.path != preview.localSnapshot.file.path &&
          await uploadSnapshot.file.exists()) {
        await uploadSnapshot.file.delete();
      }
    }
  }

  Future<void> disposePreview(DriveSyncPreview preview) async {
    if (await preview.localSnapshot.file.exists()) {
      await preview.localSnapshot.file.delete();
    }
    final remoteFile = preview.remoteSnapshot?.file;
    if (remoteFile != null && await remoteFile.exists()) {
      await remoteFile.delete();
    }
  }

  Future<File> _downloadServerBackup({
    required String accountId,
    required BackupFileOut backup,
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    final api = _ref.read(apiClientProvider);
    final directory = await Directory.systemTemp.createTemp('noema-backup-');
    final file = File(
      '${directory.path}${Platform.pathSeparator}$_driveSnapshotName',
    );
    try {
      final response = await api.dio.get<ResponseBody>(
        '/api/v1/google_drive/sync/download/${Uri.encodeComponent(backup.id)}',
        queryParameters: {'id_google_account': accountId},
        options: Options(
          responseType: ResponseType.stream,
          extra: _authenticatedApiOptions.extra,
        ),
        onReceiveProgress: (received, total) {
          onProgress?.call(
            DriveSyncProgress(
              'Baixando backup do servidor…',
              total > 0 ? received / total : null,
            ),
          );
        },
      );
      final body = response.data;
      if (body == null) {
        throw const DriveSyncException(
          'O servidor retornou um backup vazio.',
          code: 'drive_download_failed',
        );
      }
      final sink = file.openWrite();
      var downloadedBytes = 0;
      try {
        await for (final chunk in body.stream) {
          downloadedBytes += chunk.length;
          if (downloadedBytes > maxLocalSnapshotBytes) {
            throw const DriveSyncException(
              'O backup excede o limite seguro de 256 MiB do app.',
              code: 'drive_snapshot_too_large',
            );
          }
          sink.add(chunk);
        }
        await sink.flush();
      } finally {
        await sink.close();
      }
      if (downloadedBytes == 0) {
        throw const DriveSyncException(
          'O servidor retornou um backup vazio.',
          code: 'drive_download_failed',
        );
      }
      return file;
    } catch (_) {
      await _deleteTemporaryFile(file);
      rethrow;
    }
  }

  Future<BackupFileOut> _uploadServerSnapshot({
    required String accountId,
    required BackupFileOut? backup,
    required LocalSnapshot snapshot,
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    if (backup != null &&
        (backup.driveVersion == null ||
            backup.driveVersion!.isEmpty ||
            backup.contentHash == null ||
            backup.contentHash!.isEmpty)) {
      throw const DriveSyncException(
        'O backup remoto não tem uma revisão segura para atualização. Gere uma nova prévia.',
        code: 'drive_revision_conflict',
      );
    }
    final api = _ref.read(apiClientProvider);
    final form = FormData.fromMap({
      'id_google_account': accountId,
      'local_ref': _backupLocalRef,
      'snapshot_version': snapshot.snapshotVersion,
      'content_hash': snapshot.contentHash,
      'manifest': jsonEncode(snapshot.manifest),
      'idempotency_key': _idempotencyKey(
        '$accountId:$_backupLocalRef:${backup?.id ?? "new"}:'
        '${backup?.driveVersion ?? "new"}:${backup?.contentHash ?? "new"}:'
        '${snapshot.snapshotVersion}:${snapshot.contentHash}',
      ),
      if (backup != null) 'backup_id': backup.id,
      if (backup?.driveVersion != null)
        'expected_drive_version': backup!.driveVersion,
      if (backup?.contentHash != null)
        'expected_content_hash': backup!.contentHash,
      'upload': await MultipartFile.fromFile(
        snapshot.file.path,
        filename: _driveSnapshotName,
      ),
    });
    try {
      final response = await api.dio.post<Object>(
        '/api/v1/google_drive/sync/upload',
        data: form,
        options: Options(extra: _authenticatedApiOptions.extra),
        onSendProgress: (sent, total) {
          onProgress?.call(
            DriveSyncProgress(
              'Enviando backup ao servidor…',
              total > 0 ? sent / total : null,
            ),
          );
        },
      );
      final raw = response.data;
      if (raw == null) {
        throw const DriveSyncException(
          'O servidor não confirmou o backup enviado.',
          code: 'drive_upload_unconfirmed',
        );
      }
      return api.serializers.deserialize(
            raw,
            specifiedType: const FullType(BackupFileOut),
          )
          as BackupFileOut;
    } on DioException catch (error) {
      final code = _apiErrorCode(error.response?.data);
      if (code == 'drive_revision_conflict' ||
          code == 'drive_revision_unavailable' ||
          code == 'drive_file_missing' ||
          code == 'backup_revision_required' ||
          code == 'backup_revision_fields_required') {
        throw const DriveSyncException(
          'O backup remoto mudou desde a prévia. Gere uma nova prévia antes de sincronizar.',
          code: 'drive_revision_conflict',
        );
      }
      if (code == 'snapshot_hash_mismatch' ||
          code == 'snapshot_validation_failed') {
        throw const DriveSyncException(
          'A validação do snapshot falhou no servidor; nenhum backup foi confirmado.',
          code: 'snapshot_validation_failed',
        );
      }
      rethrow;
    }
  }

  DriveSyncException _statusException(GoogleAccountStatusOut status) {
    return switch (status.error?.name) {
      'drive_appdata_scope_missing' => const DriveSyncException(
        'O acesso ao espaço privado de arquivos do Noema não foi concedido. '
        'Vincule novamente a conta e aprove somente o acesso solicitado.',
        code: 'drive_appdata_scope_missing',
      ),
      'google_authorization_revoked' => const DriveSyncException(
        'A autorização do Google foi revogada. Conecte a conta novamente.',
        code: 'google_authorization_revoked',
      ),
      'google_authorization_unverified' => const DriveSyncException(
        'Não foi possível verificar a autorização Google. Tente novamente.',
        code: 'google_authorization_unverified',
      ),
      _ => const DriveSyncException(
        'O servidor não confirmou acesso válido ao Google Drive.',
      ),
    };
  }

  Future<String> _getOrCreateServerDevice(String remoteUserId) async {
    final api = _ref.read(apiClientProvider).getDeviceApi();
    final fingerprint = await DeviceFingerprint.get();
    final list = await api.listDeviceApiV1DeviceListGet(
      idUser: remoteUserId,
      deviceFingerprint: fingerprint,
    );
    final devices = list.data;
    if (devices == null) {
      throw const DriveSyncException(
        'O servidor não retornou a lista de dispositivos; nenhum dispositivo '
        'duplicado foi criado.',
      );
    }
    final existing = devices
        .where(
          (device) =>
              device.idUser == remoteUserId &&
              device.deviceFingerprint == fingerprint,
        )
        .firstOrNull;
    if (existing != null) return existing.id;

    final created = await api.createDeviceApiV1DeviceCreatePost(
      deviceCreate: DeviceCreate((builder) {
        builder
          ..idUser = remoteUserId
          ..deviceName = 'Noema (${defaultTargetPlatform.name})'
          ..deviceFingerprint = fingerprint
          ..platform = defaultTargetPlatform.name;
      }),
    );
    final id = created.data?.id;
    if (id == null || id.isEmpty) {
      throw const DriveSyncException(
        'O servidor não retornou o identificador deste dispositivo.',
      );
    }
    return id;
  }

  Future<BackupFileOut> _createBackupMetadata({
    required LocalSnapshot snapshot,
    required String accountId,
    required String deviceId,
    required DriveFileInfo driveFile,
  }) async {
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveSyncApi()
        .createBackupApiV1GoogleDriveBackupsPost(
          backupMetadataCreate: BackupMetadataCreate((builder) {
            builder
              ..idGoogleAccount = accountId
              ..idDevice = deviceId
              ..driveFileId = driveFile.id
              ..localRef = _backupLocalRef
              ..driveVersion = driveFile.version
              ..snapshotVersion = snapshot.snapshotVersion
              ..contentHash = snapshot.contentHash
              ..sizeBytes = snapshot.sizeBytes
              ..operationState = BackupOperationState.completed
              ..idempotencyKey = _idempotencyKey(
                '$accountId:${driveFile.id}:${snapshot.contentHash}',
              );
            builder.manifest.replace(_toApiManifest(snapshot.manifest));
          }),
        );
    final backup = response.data;
    if (backup == null) {
      throw const DriveSyncException(
        'O Drive recebeu o arquivo, mas o servidor não confirmou os metadados.',
      );
    }
    return backup;
  }

  Future<BackupFileOut> _updateBackupMetadata({
    required LocalSnapshot snapshot,
    required BackupFileOut backup,
    required DriveFileInfo driveFile,
  }) async {
    final expectedDriveVersion = backup.driveVersion;
    final expectedContentHash = backup.contentHash;
    if (expectedDriveVersion == null || expectedContentHash == null) {
      throw const DriveSyncException(
        'Os metadados remotos não têm uma versão-base segura. Não foi feita nenhuma sobrescrita.',
        code: 'drive_revision_conflict',
      );
    }
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveSyncApi()
        .updateBackupApiV1GoogleDriveBackupsBackupIdPut(
          backupId: backup.id,
          backupMetadataUpdate: BackupMetadataUpdate((builder) {
            builder
              ..expectedDriveVersion = expectedDriveVersion
              ..expectedContentHash = expectedContentHash
              ..idempotencyKey = _idempotencyKey(
                '${backup.id}:${snapshot.contentHash}',
              )
              ..driveVersion = driveFile.version
              ..snapshotVersion = snapshot.snapshotVersion
              ..contentHash = snapshot.contentHash
              ..sizeBytes = snapshot.sizeBytes
              ..operationState = BackupOperationState.completed;
            builder.manifest.replace(_toApiManifest(snapshot.manifest));
          }),
        );
    final updated = response.data;
    if (updated == null) {
      throw const DriveSyncException(
        'O servidor não confirmou a atualização dos metadados do backup.',
      );
    }
    return updated;
  }

  SnapshotManifest _toApiManifest(Map<String, dynamic> manifest) {
    final counts = (manifest['counts'] as Map).map(
      (key, value) => MapEntry('$key', value as int),
    );
    final hashes = (manifest['hashes'] as Map).map(
      (key, value) => MapEntry('$key', value as String),
    );
    return SnapshotManifest((builder) {
      builder
        ..format = manifest['format'] as String
        ..schemaVersion = manifest['schema_version'] as int
        ..snapshotVersion = manifest['snapshot_version'] as String
        ..createdAt = DateTime.parse(manifest['created_at'] as String)
        ..installationId = manifest['installation_id'] as String
        ..includedCategories.replace(
          (manifest['included_categories'] as List).cast<String>(),
        )
        ..excludedCategories.replace(
          (manifest['excluded_categories'] as List).cast<String>(),
        )
        ..counts.replace(counts)
        ..hashes.replace(hashes);
    });
  }

  Future<String?> _recordSyncLog({
    required DriveSyncPreview preview,
    required String? backupId,
    required SyncDirection direction,
    required ConflictStrategy strategy,
    required LocalSnapshot snapshot,
    String event = 'sync_completed',
  }) async {
    try {
      final response = await _ref
          .read(apiClientProvider)
          .getGoogleDriveSyncApi()
          .createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(
            syncLogCreate: SyncLogCreate((builder) {
              builder
                ..idDevice = preview.deviceId
                ..idBackupFile = backupId
                ..idGoogleAccount = preview.accountId
                ..idempotencyKey = const Uuid().v4()
                ..event = SyncLogCreateEventEnum.valueOf(event)
                ..derection = direction
                ..result = SyncResult.success
                ..conflictStrategy = strategy;
              builder.metadata.replace({
                'snapshot_version': JsonObject(snapshot.snapshotVersion),
                'content_hash': JsonObject(snapshot.contentHash),
                'file_size_bytes': JsonObject(snapshot.sizeBytes),
                'installation_id': JsonObject(
                  snapshot.manifest['installation_id'] as String,
                ),
              });
            }),
          );
      if (response.data == null) {
        return 'A sincronização foi concluída, mas o servidor não confirmou o registro do histórico.';
      }
      return null;
    } on Object {
      return 'A sincronização foi concluída, mas não foi possível salvar o evento no histórico do servidor.';
    }
  }

  bool _metadataIsStale(DriveSyncPreview preview) {
    final backup = preview.backup;
    final file = preview.driveFile;
    final remote = preview.remoteSnapshot;
    if (backup == null || file == null || remote == null) return true;
    return backup.driveVersion != file.version ||
        backup.contentHash != remote.contentHash;
  }

  DateTime _backupDate(BackupFileOut backup) =>
      backup.updatedAt ??
      backup.createdAt ??
      DateTime.fromMillisecondsSinceEpoch(0);

  String _idempotencyKey(String value) =>
      const Uuid().v5(Namespace.url.value, value);
}

class DriveFileInfo {
  const DriveFileInfo({
    required this.id,
    required this.version,
    required this.etag,
    required this.sizeBytes,
    required this.modifiedAt,
  });

  final String id;
  final String version;
  final String? etag;
  final int? sizeBytes;
  final DateTime? modifiedAt;
}

Future<void> _deleteTemporaryFile(File file) async {
  if (!await file.exists()) return;
  final directory = file.parent;
  await file.delete();
  if (await directory.exists()) {
    try {
      await directory.delete();
    } on FileSystemException {
      // Another operation may still be using this temporary directory.
    }
  }
}

final googleDriveSyncServiceProvider = Provider<GoogleDriveSyncService>(
  GoogleDriveSyncService.new,
);
