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
import 'package:noema/feature/config/data/google_drive/google_drive_api.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_oauth.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_oauth_factory.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';
import 'package:uuid/uuid.dart';

const _backupLocalRef = 'primary-snapshot';

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
    this.automaticResolution,
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
  final DriveSyncResolution? automaticResolution;

  bool get requiresDecision =>
      remoteSnapshot != null &&
      diff != null &&
      !diff!.isEmpty &&
      automaticResolution == null;

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

  @visibleForTesting
  static DriveSyncResolution? inferAutomaticResolution({
    required String? lastSyncedDataHash,
    required DateTime? lastDeviceSyncAt,
    required DateTime? remoteUpdatedAt,
    required String localDataHash,
    required String remoteDataHash,
    required String? localInstallationId,
    required String? remoteInstallationId,
    required int conflictCount,
  }) {
    if (conflictCount == 0) return DriveSyncResolution.merge;

    if (lastSyncedDataHash == null || lastSyncedDataHash.isEmpty) {
      // This install created the remote snapshot, so only its local state has
      // diverged since that snapshot.
      if (localInstallationId != null &&
          localInstallationId.isNotEmpty &&
          localInstallationId == remoteInstallationId) {
        return DriveSyncResolution.keepLocal;
      }
      if (lastDeviceSyncAt != null &&
          remoteUpdatedAt != null &&
          remoteUpdatedAt.isBefore(lastDeviceSyncAt)) {
        return DriveSyncResolution.keepLocal;
      }
      return null;
    }

    final localChanged = localDataHash != lastSyncedDataHash;
    final remoteChanged = remoteDataHash != lastSyncedDataHash;
    if (localChanged == remoteChanged) return null;
    return localChanged
        ? DriveSyncResolution.keepLocal
        : DriveSyncResolution.keepRemote;
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
  GoogleDriveSyncService(
    this._ref, {
    GoogleDriveOAuthClient? oauthClient,
    GoogleDriveApi? driveApi,
  }) : _oauthClient = oauthClient ?? createGoogleDriveOAuthClient(),
       _driveApi = driveApi ?? GoogleDriveApi();

  final Ref _ref;
  final GoogleDriveOAuthClient _oauthClient;
  final GoogleDriveApi _driveApi;

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

  Future<GoogleAccountStatusOut> _connectGoogleAccount({
    required bool forceInteractive,
  }) async {
    final session = await _oauthClient.authorize(
      interactive: true,
      forceInteractive: forceInteractive,
    );
    final idToken = session.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const DriveSyncException(
        'O Google não confirmou a identidade da conta. Autorize novamente.',
        code: 'google_identity_missing',
      );
    }

    final api = _ref.read(apiClientProvider);
    final response = await api.dio.post<Object>(
      '/api/v1/google_drive/account/link',
      data: {
        'google_id_token': idToken,
        'google_access_token': session.accessToken,
      },
      options: _authenticatedApiOptions,
    );
    final raw = response.data;
    if (raw == null) {
      throw const DriveSyncException(
        'O servidor não confirmou a conta Google.',
        code: 'google_account_link_unconfirmed',
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
    return sortedBackups(backups);
  }

  @visibleForTesting
  static List<BackupFileOut> sortedBackups(Iterable<BackupFileOut>? backups) {
    if (backups == null) {
      throw const DriveSyncException(
        'O servidor não confirmou a lista de backups. Nenhum backup novo foi criado.',
        code: 'backup_list_unconfirmed',
      );
    }
    return backups.toList()
      ..sort((a, b) => _backupDate(b).compareTo(_backupDate(a)));
  }

  Future<List<SyncLogOut>> listSyncHistory(
    String accountId, {
    String? deviceId,
  }) async {
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveSyncApi()
        .listSyncLogApiV1GoogleDriveSyncLogListGet(
          filters: SyncLogFilters((builder) {
            builder.idGoogleAccount = accountId;
            if (deviceId != null) builder.idDevice = deviceId;
          }),
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

  Future<SyncLogOut?> _lastSuccessfulDeviceSync({
    required String accountId,
    required String deviceId,
  }) async {
    final history = await listSyncHistory(accountId, deviceId: deviceId);
    final latestSync = history.where(
      (entry) =>
          entry.idDevice == deviceId &&
          entry.result == SyncResult.success &&
          const {
            'backup_created',
            'backup_updated',
            'sync_completed',
          }.contains(entry.event),
    );
    return latestSync.firstOrNull;
  }

  Future<GoogleAccountStatusOut> connectGoogleAccount() async {
    _logGoogleDrive('Starting Google desktop authorization.');
    return _connectGoogleAccount(forceInteractive: true);
  }

  Future<GoogleAccountStatusOut> repairGoogleAuthorization() async {
    _logGoogleDrive('Reauthorizing the Google desktop account.');
    return _connectGoogleAccount(forceInteractive: true);
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
    final serverGrantRevoked = body['google_grant_revoked'] == true;
    try {
      final desktopGrantRevoked = await _oauthClient.revokeAndClear();
      return desktopGrantRevoked || serverGrantRevoked;
    } on GoogleDriveOAuthException {
      return serverGrantRevoked;
    }
  }

  Future<DriveSyncPreview> prepareSync({
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    onProgress?.call(const DriveSyncProgress('Autorizando o Google…', null));
    final status = await getAccountStatus();
    if (!status.syncAvailable || status.accountId == null) {
      throw _statusException(status);
    }
    final accessToken = await _driveAccessToken(
      expectedGoogleEmail: status.googleEmail,
    );

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
      final backups = sortedBackups(listed.data);
      if (backups.length > 1) {
        throw const DriveSyncException(
          'Há mais de um registro de backup principal no servidor. '
          'Nenhum foi escolhido automaticamente.',
          code: 'drive_duplicate_snapshots',
        );
      }
      final backup = backups.firstOrNull;
      final remoteCandidates = await _driveApi.listFiles(
        accessToken: accessToken,
        localRef: _backupLocalRef,
      );
      if (remoteCandidates.length > 1) {
        throw const DriveSyncException(
          'Há mais de um backup Noema no Google Drive. '
          'Nenhum arquivo foi escolhido automaticamente.',
          code: 'drive_duplicate_snapshots',
        );
      }

      GoogleDriveFile? remoteFile;
      if (backup != null) {
        final matchingFiles = remoteCandidates
            .where((file) => file.id == backup.driveFileId)
            .toList();
        if (matchingFiles.length != 1) {
          throw const DriveSyncException(
            'O backup registrado não foi encontrado no espaço privado do Google Drive.',
            code: 'drive_file_missing',
          );
        }
        remoteFile = matchingFiles.single;
      } else {
        remoteFile = remoteCandidates.firstOrNull;
      }

      DriveFileInfo? driveFile;
      LocalSnapshot? remote;
      if (remoteFile != null) {
        final metadata = await _driveApi.getFile(
          accessToken: accessToken,
          fileId: remoteFile.id,
        );
        _validateRemoteFile(metadata);
        driveFile = _toDriveFileInfo(metadata);
        onProgress?.call(
          const DriveSyncProgress('Baixando e verificando o backup…', null),
        );
        final remoteSnapshotFile = await _downloadDriveBackup(
          accessToken: accessToken,
          driveFile: driveFile,
          onProgress: onProgress,
        );
        try {
          final expectedHash = driveFile.contentHash ?? backup?.contentHash;
          if (expectedHash == null || expectedHash.isEmpty) {
            throw const DriveSyncException(
              'O backup remoto não tem um hash verificável. Nenhum dado foi restaurado.',
              code: 'snapshot_hash_missing',
            );
          }
          remote = await LocalSnapshot.fromFile(
            file: remoteSnapshotFile,
            expectedRemoteUserId: user.remoteId,
            expectedContentHash: expectedHash,
          );
        } finally {
          await _deleteTemporaryFile(remoteSnapshotFile);
        }
      } else if (backup != null) {
        throw const DriveSyncException(
          'O backup registrado não foi encontrado no espaço privado do Google Drive.',
          code: 'drive_file_missing',
        );
      }

      final diff = remote == null
          ? null
          : compareSnapshots(
              local.document['data'] as Map<String, dynamic>,
              remote.document['data'] as Map<String, dynamic>,
            );
      final lastDeviceSync = diff != null && !diff.isEmpty
          ? await _lastSuccessfulDeviceSync(
              accountId: status.accountId!,
              deviceId: deviceId,
            )
          : null;
      final rawDataHash = lastDeviceSync?.metadata['data_hash']?.value;
      final lastSyncedDataHash = rawDataHash is String ? rawDataHash : null;
      final automaticResolution = remote == null || diff == null || diff.isEmpty
          ? null
          : DriveSyncPreview.inferAutomaticResolution(
              lastSyncedDataHash: lastSyncedDataHash,
              lastDeviceSyncAt: lastDeviceSync?.createdAt,
              remoteUpdatedAt: _latestDate([
                driveFile?.modifiedAt,
                backup?.updatedAt,
              ]),
              localDataHash: local.dataHash,
              remoteDataHash: remote.dataHash,
              localInstallationId: local.manifest['installation_id'] as String?,
              remoteInstallationId:
                  remote.manifest['installation_id'] as String?,
              conflictCount: diff.conflicts,
            );

      final preview = DriveSyncPreview(
        accountId: status.accountId!,
        deviceId: deviceId,
        localUserId: user.id,
        remoteUserId: user.remoteId,
        localSnapshot: local,
        remoteSnapshot: remote,
        driveFile: driveFile,
        backup: backup,
        diff: diff,
        automaticResolution: automaticResolution,
      );
      previewReady = true;
      return preview;
    } on GoogleDriveApiException catch (error, stackTrace) {
      _logGoogleDrive(
        'Google Drive sync preview failed (code=${error.code}).',
        stackTrace: stackTrace,
      );
      throw DriveSyncException(error.message, code: error.code);
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
    final accessToken = await _driveAccessToken(
      expectedGoogleEmail: status.googleEmail,
    );

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
        const DriveSyncProgress(
          'Enviando backup diretamente ao Google Drive…',
          null,
        ),
      );
      final backup = await _uploadDriveSnapshot(
        accessToken: accessToken,
        accountId: preview.accountId,
        deviceId: preview.deviceId,
        backup: preview.backup,
        expectedDriveFile: preview.driveFile,
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
            : 'Backup local enviado diretamente ao Google Drive e confirmado.',
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
      if (error is GoogleDriveApiException) {
        throw DriveSyncException(error.message, code: error.code);
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

  Future<String> _driveAccessToken({
    required String? expectedGoogleEmail,
  }) async {
    try {
      final session = await _oauthClient.authorize(interactive: false);
      if (session.email == null ||
          (expectedGoogleEmail != null &&
              session.email!.toLowerCase() !=
                  expectedGoogleEmail.toLowerCase())) {
        throw const DriveSyncException(
          'A conta Google autorizada neste dispositivo não corresponde à conta vinculada ao Noema. Conecte a conta novamente.',
          code: 'google_identity_mismatch',
        );
      }
      return session.accessToken;
    } on GoogleDriveOAuthException catch (error) {
      throw DriveSyncException(error.message, code: error.code);
    }
  }

  void _validateRemoteFile(GoogleDriveFile file) {
    if (file.appProperties['noema_local_ref'] != _backupLocalRef) {
      throw const DriveSyncException(
        'O arquivo remoto não tem a identificação esperada para o backup do Noema.',
        code: 'drive_revision_conflict',
      );
    }
  }

  DriveFileInfo _toDriveFileInfo(GoogleDriveFile file) => DriveFileInfo(
    id: file.id,
    version: file.version,
    etag: file.etag,
    sizeBytes: file.sizeBytes,
    modifiedAt: file.modifiedAt,
    contentHash: file.appProperties['noema_content_hash'],
  );

  Future<File> _downloadDriveBackup({
    required String accessToken,
    required DriveFileInfo driveFile,
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    onProgress?.call(
      const DriveSyncProgress(
        'Baixando backup diretamente do Google Drive…',
        null,
      ),
    );
    return _driveApi.downloadSnapshot(
      accessToken: accessToken,
      fileId: driveFile.id,
    );
  }

  Future<BackupFileOut> _uploadDriveSnapshot({
    required String accessToken,
    required String accountId,
    required String deviceId,
    required BackupFileOut? backup,
    required DriveFileInfo? expectedDriveFile,
    required LocalSnapshot snapshot,
    void Function(DriveSyncProgress progress)? onProgress,
  }) async {
    if (backup != null &&
        (backup.driveVersion == null ||
            backup.driveVersion!.isEmpty ||
            backup.contentHash == null ||
            backup.contentHash!.isEmpty ||
            expectedDriveFile == null)) {
      throw const DriveSyncException(
        'O backup remoto não tem uma revisão segura para atualização. Gere uma nova prévia.',
        code: 'drive_revision_conflict',
      );
    }
    GoogleDriveFile? currentFile;
    if (expectedDriveFile != null) {
      currentFile = await _driveApi.getFile(
        accessToken: accessToken,
        fileId: expectedDriveFile.id,
      );
      _validateRemoteFile(currentFile);
      if (currentFile.version != expectedDriveFile.version ||
          (expectedDriveFile.etag != null &&
              currentFile.etag != expectedDriveFile.etag)) {
        throw const DriveSyncException(
          'O backup remoto mudou desde a prévia. Gere uma nova prévia antes de sincronizar.',
          code: 'drive_revision_conflict',
        );
      }
    } else {
      final remoteCandidates = await _driveApi.listFiles(
        accessToken: accessToken,
        localRef: _backupLocalRef,
      );
      if (remoteCandidates.isNotEmpty) {
        throw const DriveSyncException(
          'Um backup foi criado no Google Drive depois da prévia. '
          'Atualize a comparação antes de sincronizar.',
          code: 'drive_revision_conflict',
        );
      }
    }

    final operationId = _idempotencyKey(
      '$accountId:$_backupLocalRef:${expectedDriveFile?.id ?? "new"}:'
      '${snapshot.snapshotVersion}:${snapshot.contentHash}',
    );
    final uploadedFile = await _driveApi.uploadSnapshot(
      accessToken: accessToken,
      snapshot: snapshot.file,
      localRef: _backupLocalRef,
      snapshotVersion: snapshot.snapshotVersion,
      contentHash: snapshot.contentHash,
      operationId: operationId,
      existingFile: currentFile,
      onProgress: (sent, total) {
        onProgress?.call(
          DriveSyncProgress(
            'Enviando backup diretamente ao Google Drive…',
            total > 0 ? sent / total : null,
          ),
        );
      },
    );
    _validateRemoteFile(uploadedFile);
    if (uploadedFile.appProperties['noema_content_hash'] !=
            snapshot.contentHash ||
        uploadedFile.appProperties['noema_snapshot_version'] !=
            snapshot.snapshotVersion) {
      throw const DriveSyncException(
        'O Google Drive não confirmou o conteúdo enviado.',
        code: 'drive_upload_unconfirmed',
      );
    }
    final driveFile = _toDriveFileInfo(uploadedFile);
    if (backup == null) {
      return _createBackupMetadata(
        snapshot: snapshot,
        accountId: accountId,
        deviceId: deviceId,
        driveFile: driveFile,
      );
    }
    return _updateBackupMetadata(
      snapshot: snapshot,
      backup: backup,
      driveFile: driveFile,
    );
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
    final idempotencyKey = metadataIdempotencyKey(
      operation: 'backup.create',
      backupId: null,
      request: {
        'id_google_account': accountId,
        'id_device': deviceId,
        'drive_file_id': driveFile.id,
        'local_ref': _backupLocalRef,
        'drive_version': driveFile.version,
        'drive_etag': null,
        'snapshot_version': snapshot.snapshotVersion,
        'content_hash': snapshot.contentHash,
        'size_bytes': snapshot.sizeBytes,
        'operation_state': 'completed',
        'manifest': snapshot.manifest,
      },
    );
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
              ..idempotencyKey = idempotencyKey;
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
    final idempotencyKey = metadataIdempotencyKey(
      operation: 'backup.update',
      backupId: backup.id,
      request: {
        'expected_drive_version': expectedDriveVersion,
        'expected_content_hash': expectedContentHash,
        'drive_version': driveFile.version,
        'drive_etag': null,
        'snapshot_version': snapshot.snapshotVersion,
        'content_hash': snapshot.contentHash,
        'size_bytes': snapshot.sizeBytes,
        'operation_state': 'completed',
        'manifest': snapshot.manifest,
      },
    );
    final response = await _ref
        .read(apiClientProvider)
        .getGoogleDriveSyncApi()
        .updateBackupApiV1GoogleDriveBackupsBackupIdPut(
          backupId: backup.id,
          backupMetadataUpdate: BackupMetadataUpdate((builder) {
            builder
              ..expectedDriveVersion = expectedDriveVersion
              ..expectedContentHash = expectedContentHash
              ..idempotencyKey = idempotencyKey
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
                'data_hash': JsonObject(snapshot.dataHash),
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

  static DateTime _backupDate(BackupFileOut backup) =>
      backup.updatedAt ??
      backup.createdAt ??
      DateTime.fromMillisecondsSinceEpoch(0);

  static DateTime? _latestDate(Iterable<DateTime?> dates) {
    DateTime? latest;
    for (final date in dates) {
      if (date != null && (latest == null || date.isAfter(latest))) {
        latest = date;
      }
    }
    return latest;
  }

  @visibleForTesting
  static String metadataIdempotencyKey({
    required String operation,
    required String? backupId,
    required Map<String, Object?> request,
  }) {
    final identity = _canonicalizeMetadataValue({
      'operation': operation,
      'backup_id': backupId,
      'request': request,
    });
    return const Uuid().v5(Namespace.url.value, jsonEncode(identity));
  }

  String _idempotencyKey(String value) =>
      const Uuid().v5(Namespace.url.value, value);
}

Object? _canonicalizeMetadataValue(Object? value) {
  if (value is Map) {
    final entries = value.entries.toList()
      ..sort((a, b) => '${a.key}'.compareTo('${b.key}'));
    return <String, Object?>{
      for (final entry in entries)
        '${entry.key}': _canonicalizeMetadataValue(entry.value),
    };
  }
  if (value is Iterable) {
    return value.map(_canonicalizeMetadataValue).toList();
  }
  return value;
}

class DriveFileInfo {
  const DriveFileInfo({
    required this.id,
    required this.version,
    required this.etag,
    required this.sizeBytes,
    required this.modifiedAt,
    this.contentHash,
  });

  final String id;
  final String version;
  final String? etag;
  final int? sizeBytes;
  final DateTime? modifiedAt;
  final String? contentHash;
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
