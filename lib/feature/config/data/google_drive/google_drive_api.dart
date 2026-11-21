import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

const maxGoogleDriveSnapshotBytes = 256 * 1024 * 1024;
const _googleDriveApiBase = 'https://www.googleapis.com/drive/v3';
const _googleDriveUploadBase = 'https://www.googleapis.com/upload/drive/v3';
const _uploadChunkSize = 8 * 1024 * 1024;

class GoogleDriveApiException implements Exception {
  const GoogleDriveApiException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

class GoogleDriveFile {
  const GoogleDriveFile({
    required this.id,
    required this.version,
    required this.etag,
    required this.sizeBytes,
    required this.modifiedAt,
    required this.appProperties,
  });

  final String id;
  final String version;
  final String? etag;
  final int? sizeBytes;
  final DateTime? modifiedAt;
  final Map<String, String> appProperties;

  factory GoogleDriveFile.fromJson(Map<dynamic, dynamic> json, {String? etag}) {
    final id = json['id'];
    final version = json['version'];
    if (id is! String || id.isEmpty || version == null) {
      throw const GoogleDriveApiException(
        'drive_metadata_invalid',
        'O Google Drive retornou metadados incompletos para o backup.',
      );
    }

    final rawSize = json['size'];
    final sizeBytes = switch (rawSize) {
      int size => size,
      String size => int.tryParse(size),
      _ => null,
    };
    final rawModifiedAt = json['modifiedTime'];
    final rawProperties = json['appProperties'];
    return GoogleDriveFile(
      id: id,
      version: '$version',
      etag: etag,
      sizeBytes: sizeBytes,
      modifiedAt: rawModifiedAt is String
          ? DateTime.tryParse(rawModifiedAt)
          : null,
      appProperties: rawProperties is Map
          ? rawProperties.map((key, value) => MapEntry('$key', '$value'))
          : const {},
    );
  }
}

class GoogleDriveApi {
  GoogleDriveApi({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<GoogleDriveFile>> listFiles({
    required String accessToken,
    required String localRef,
  }) async {
    final files = <GoogleDriveFile>[];
    String? pageToken;
    do {
      final response = await _request(
        () => _dio.get<Object>(
          '$_googleDriveApiBase/files',
          queryParameters: {
            'spaces': 'appDataFolder',
            'q':
                "trashed = false and appProperties has { key='noema_local_ref' "
                "and value='${_escapeDriveQueryValue(localRef)}' }",
            'pageSize': 1000,
            'fields':
                'nextPageToken,files(id,version,size,modifiedTime,appProperties)',
            'pageToken': ?pageToken,
          },
          options: _jsonOptions(accessToken),
        ),
      );
      final payload = response.data;
      if (payload is! Map || payload['files'] is! List) {
        throw const GoogleDriveApiException(
          'drive_list_invalid',
          'O Google Drive retornou uma lista de arquivos inválida.',
        );
      }
      for (final item in payload['files'] as List) {
        if (item is Map && item['appProperties'] is Map) {
          final properties = item['appProperties'] as Map;
          if (properties['noema_local_ref'] == localRef) {
            files.add(GoogleDriveFile.fromJson(item));
          }
        }
      }
      final next = payload['nextPageToken'];
      pageToken = next is String && next.isNotEmpty ? next : null;
    } while (pageToken != null);
    return files;
  }

  Future<GoogleDriveFile> getFile({
    required String accessToken,
    required String fileId,
  }) async {
    final response = await _request(
      () => _dio.get<Object>(
        '$_googleDriveApiBase/files/${Uri.encodeComponent(fileId)}',
        queryParameters: {
          'fields': 'id,version,size,modifiedTime,appProperties',
        },
        options: _jsonOptions(accessToken),
      ),
    );
    final payload = response.data;
    if (payload is! Map) {
      throw const GoogleDriveApiException(
        'drive_metadata_invalid',
        'O Google Drive retornou metadados incompletos para o backup.',
      );
    }
    return GoogleDriveFile.fromJson(
      payload,
      etag: response.headers.value('etag'),
    );
  }

  Future<File> downloadSnapshot({
    required String accessToken,
    required String fileId,
  }) async {
    final directory = await Directory.systemTemp.createTemp('noema-drive-');
    final file = File(
      '${directory.path}${Platform.pathSeparator}snapshot.json',
    );
    try {
      final response = await _request(
        () => _dio.get<ResponseBody>(
          '$_googleDriveApiBase/files/${Uri.encodeComponent(fileId)}',
          queryParameters: const {'alt': 'media'},
          options: _jsonOptions(
            accessToken,
            responseType: ResponseType.stream,
            accept: 'application/octet-stream',
          ),
        ),
      );
      final body = response.data;
      if (body == null) {
        throw const GoogleDriveApiException(
          'drive_download_empty',
          'O Google Drive retornou um backup vazio.',
        );
      }

      final declaredSize = int.tryParse(
        response.headers.value('content-length') ?? '',
      );
      if (declaredSize != null && declaredSize > maxGoogleDriveSnapshotBytes) {
        throw const GoogleDriveApiException(
          'drive_snapshot_too_large',
          'O backup excede o limite seguro de 256 MiB do app.',
        );
      }

      final sink = file.openWrite();
      var downloadedBytes = 0;
      try {
        await for (final chunk in body.stream) {
          downloadedBytes += chunk.length;
          if (downloadedBytes > maxGoogleDriveSnapshotBytes) {
            throw const GoogleDriveApiException(
              'drive_snapshot_too_large',
              'O backup excede o limite seguro de 256 MiB do app.',
            );
          }
          sink.add(chunk);
        }
        await sink.flush();
      } finally {
        await sink.close();
      }
      if (downloadedBytes == 0) {
        throw const GoogleDriveApiException(
          'drive_download_empty',
          'O Google Drive retornou um backup vazio.',
        );
      }
      if (declaredSize != null && downloadedBytes != declaredSize) {
        throw const GoogleDriveApiException(
          'drive_download_incomplete',
          'O download do backup foi interrompido. Tente novamente.',
        );
      }
      return file;
    } on Object {
      await _deleteTemporaryFile(file);
      rethrow;
    }
  }

  Future<GoogleDriveFile> uploadSnapshot({
    required String accessToken,
    required File snapshot,
    required String localRef,
    required String snapshotVersion,
    required String contentHash,
    required String operationId,
    GoogleDriveFile? existingFile,
    void Function(int sent, int total)? onProgress,
  }) async {
    final size = await snapshot.length();
    if (size <= 0 || size > maxGoogleDriveSnapshotBytes) {
      throw const GoogleDriveApiException(
        'drive_snapshot_size_invalid',
        'O tamanho do backup está fora do limite seguro de 256 MiB.',
      );
    }

    final digest = await sha256.bind(snapshot.openRead()).first;
    if ('sha256:$digest' != contentHash) {
      throw const GoogleDriveApiException(
        'snapshot_hash_mismatch',
        'O arquivo local mudou após a criação da prévia. Gere uma nova prévia.',
      );
    }
    var uploadTarget = existingFile;
    if (existingFile != null) {
      // Re-read after hashing so the version check is as close as possible to
      // the update request when Drive doesn't return an ETag.
      final latestFile = await getFile(
        accessToken: accessToken,
        fileId: existingFile.id,
      );
      if (latestFile.version != existingFile.version ||
          (existingFile.etag != null && latestFile.etag != existingFile.etag)) {
        throw const GoogleDriveApiException(
          'drive_revision_conflict',
          'O backup remoto mudou desde a prévia. Gere uma nova prévia antes de sincronizar.',
        );
      }
      uploadTarget = latestFile;
    }

    final properties = <String, String>{
      'noema_local_ref': localRef,
      'noema_snapshot_version': snapshotVersion,
      'noema_content_hash': contentHash,
      'noema_operation_id': operationId,
    };
    final metadata = <String, Object>{
      'name': 'noema-$localRef',
      'appProperties': properties,
      if (uploadTarget == null) 'parents': ['appDataFolder'],
    };
    final sessionResponse = await _request(
      () => _dio.request<Object>(
        '$_googleDriveUploadBase/files'
        '${uploadTarget == null ? '' : '/${Uri.encodeComponent(uploadTarget.id)}'}',
        queryParameters: const {
          'uploadType': 'resumable',
          'fields': 'id,version,size,modifiedTime,appProperties',
        },
        data: metadata,
        options: _jsonOptions(
          accessToken,
          method: uploadTarget == null ? 'POST' : 'PATCH',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-Upload-Content-Type': 'application/octet-stream',
            if (uploadTarget?.etag != null) 'If-Match': uploadTarget!.etag!,
          },
        ),
      ),
    );
    final uploadLocation = sessionResponse.headers.value('location');
    final uploadUri = uploadLocation == null
        ? null
        : Uri.tryParse(uploadLocation);
    if (uploadUri == null ||
        uploadUri.scheme != 'https' ||
        !{
          'www.googleapis.com',
          'upload.googleapis.com',
        }.contains(uploadUri.host)) {
      throw const GoogleDriveApiException(
        'drive_upload_session_invalid',
        'O Google Drive não retornou uma sessão de upload válida.',
      );
    }

    final source = await snapshot.open();
    var offset = 0;
    String? uploadedFileId;
    try {
      while (offset < size) {
        final chunk = await source.read(min(_uploadChunkSize, size - offset));
        if (chunk.isEmpty) {
          throw const GoogleDriveApiException(
            'drive_upload_incomplete',
            'O arquivo local terminou antes do esperado.',
          );
        }
        final end = offset + chunk.length - 1;
        final response = await _request(
          () => _dio.putUri<Object>(
            uploadUri,
            data: chunk,
            options: Options(
              headers: {
                'Content-Length': '${chunk.length}',
                'Content-Range': 'bytes $offset-$end/$size',
                'Content-Type': 'application/octet-stream',
              },
              responseType: ResponseType.json,
              validateStatus: _acceptHttpStatus,
            ),
          ),
        );
        if (response.statusCode == 308) {
          final acceptedEnd = _acceptedRangeEnd(
            response.headers.value('range'),
          );
          if (acceptedEnd != end) {
            throw const GoogleDriveApiException(
              'drive_upload_incomplete',
              'O Google Drive não confirmou todos os bytes enviados.',
            );
          }
        } else if (response.statusCode != 200 && response.statusCode != 201) {
          _throwForStatus(response.statusCode, response.data);
        } else if (end + 1 != size) {
          throw const GoogleDriveApiException(
            'drive_upload_incomplete',
            'O Google Drive concluiu o upload antes do último bloco.',
          );
        } else {
          final payload = response.data;
          final id = payload is Map ? payload['id'] : null;
          if (id is! String || id.isEmpty) {
            throw const GoogleDriveApiException(
              'drive_upload_unconfirmed',
              'O Drive recebeu os dados, mas não confirmou o arquivo.',
            );
          }
          uploadedFileId = id;
        }
        offset = end + 1;
        onProgress?.call(offset, size);
      }
    } finally {
      await source.close();
    }

    final fileId = uploadTarget?.id ?? uploadedFileId;
    if (fileId == null) {
      throw const GoogleDriveApiException(
        'drive_upload_unconfirmed',
        'O Drive recebeu os dados, mas não confirmou o arquivo.',
      );
    }
    return getFile(accessToken: accessToken, fileId: fileId);
  }

  Options _jsonOptions(
    String accessToken, {
    String method = 'GET',
    ResponseType responseType = ResponseType.json,
    String accept = 'application/json',
    Map<String, Object>? headers,
  }) => Options(
    method: method,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': accept,
      ...?headers,
    },
    responseType: responseType,
    validateStatus: _acceptHttpStatus,
  );

  Future<Response<T>> _request<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      final response = await request();
      final status = response.statusCode;
      if (status == null || status >= 400) {
        _throwForStatus(status, response.data);
      }
      return response;
    } on GoogleDriveApiException {
      rethrow;
    } on DioException {
      throw const GoogleDriveApiException(
        'drive_network_unavailable',
        'Não foi possível conectar ao Google Drive. Verifique a conexão e tente novamente.',
      );
    }
  }

  Never _throwForStatus(int? status, [Object? responseData]) {
    if (status == 401) {
      throw const GoogleDriveApiException(
        'google_authorization_revoked',
        'A autorização Google expirou ou foi revogada. Conecte a conta novamente.',
      );
    }
    if (status == 403) {
      final reason = _googleDriveErrorReason(responseData);
      if (reason == 'accessNotConfigured' || reason == 'SERVICE_DISABLED') {
        throw const GoogleDriveApiException(
          'unknown_error',
          'A Google Drive API não está habilitada no projeto Google Cloud '
              'deste OAuth. Ative a API em APIs e serviços > Biblioteca e tente '
              'novamente.',
        );
      }
      if (reason == 'insufficientPermissions' ||
          reason == 'insufficientAuthenticationScopes') {
        throw const GoogleDriveApiException(
          'drive_appdata_scope_missing',
          'O Google recusou o escopo drive.appdata. Toque em Renovar '
              'autorização e conceda o acesso privado solicitado.',
        );
      }
      throw const GoogleDriveApiException(
        'unknown_error',
        'O Google Drive recusou o acesso (HTTP 403). Confirme se a Google '
            'Drive API está habilitada e renove a autorização do app.',
      );
    }
    if (status == 404) {
      throw const GoogleDriveApiException(
        'drive_file_missing',
        'O arquivo de backup não foi encontrado no Google Drive.',
      );
    }
    if (status == 412) {
      throw const GoogleDriveApiException(
        'drive_revision_conflict',
        'O backup mudou desde a prévia. Gere uma nova prévia antes de sincronizar.',
      );
    }
    throw GoogleDriveApiException(
      'drive_request_failed',
      'O Google Drive recusou a operação (HTTP ${status ?? "desconhecido"}).',
    );
  }

  String? _googleDriveErrorReason(Object? responseData) {
    if (responseData is! Map) return null;
    final error = responseData['error'];
    if (error is! Map) return null;
    final errors = error['errors'];
    if (errors is List) {
      for (final item in errors) {
        if (item is Map && item['reason'] is String) {
          return item['reason'] as String;
        }
      }
    }
    final reason = error['reason'] ?? error['status'];
    return reason is String ? reason : null;
  }

  int? _acceptedRangeEnd(String? range) {
    if (range == null) return null;
    final match = RegExp(r'^bytes=0-(\d+)$').firstMatch(range);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  String _escapeDriveQueryValue(String value) =>
      value.replaceAll(r'\\', r'\\\\').replaceAll("'", r"\'");

  static bool _acceptHttpStatus(int? status) =>
      status != null && status >= 100 && status < 600;

  Future<void> _deleteTemporaryFile(File file) async {
    if (!await file.exists()) return;
    final directory = file.parent;
    await file.delete();
    if (await directory.exists()) {
      await directory.delete();
    }
  }
}
