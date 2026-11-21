import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_api.dart';

void main() {
  test(
    'updates an existing file without an ETag when its version is current',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'noema-drive-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final bytes = [1, 2, 3];
      final snapshot = File('${directory.path}/snapshot.json');
      await snapshot.writeAsBytes(bytes);

      var metadataReads = 0;
      var uploadSessionCreated = false;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'GET' &&
                options.uri.path.endsWith('/files/file-1')) {
              metadataReads++;
              handler.resolve(
                Response<Object>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'id': 'file-1',
                    'version': metadataReads == 1 ? '4' : '5',
                    'appProperties': {
                      'noema_local_ref': 'primary-snapshot',
                      'noema_snapshot_version': 'snapshot-2',
                      'noema_content_hash': 'sha256:${sha256.convert(bytes)}',
                    },
                  },
                ),
              );
              return;
            }
            if (options.method == 'PATCH' &&
                options.uri.path.endsWith('/files/file-1')) {
              uploadSessionCreated = true;
              expect(options.headers['If-Match'], isNull);
              handler.resolve(
                Response<Object>(
                  requestOptions: options,
                  statusCode: 200,
                  headers: Headers.fromMap({
                    'location': [
                      'https://www.googleapis.com/upload/drive/v3/files/session',
                    ],
                  }),
                ),
              );
              return;
            }
            if (options.method == 'PUT' &&
                options.uri.host == 'www.googleapis.com') {
              handler.resolve(
                Response<Object>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'id': 'file-1'},
                ),
              );
              return;
            }
            fail('Unexpected Drive request: ${options.method} ${options.uri}');
          },
        ),
      );

      final updatedFile = await GoogleDriveApi(dio: dio).uploadSnapshot(
        accessToken: 'access-token',
        snapshot: snapshot,
        localRef: 'primary-snapshot',
        snapshotVersion: 'snapshot-2',
        contentHash: 'sha256:${sha256.convert(bytes)}',
        operationId: 'operation-1234567890',
        existingFile: const GoogleDriveFile(
          id: 'file-1',
          version: '4',
          etag: null,
          sizeBytes: 3,
          modifiedAt: null,
          appProperties: {'noema_local_ref': 'primary-snapshot'},
        ),
      );

      expect(uploadSessionCreated, isTrue);
      expect(metadataReads, 2);
      expect(updatedFile.version, '5');
    },
  );

  test(
    'rejects an update if the Drive version changed before upload',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'noema-drive-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final bytes = [1, 2, 3];
      final snapshot = File('${directory.path}/snapshot.json');
      await snapshot.writeAsBytes(bytes);

      var uploadSessionCreated = false;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'GET') {
              handler.resolve(
                Response<Object>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'id': 'file-1',
                    'version': '5',
                    'appProperties': {'noema_local_ref': 'primary-snapshot'},
                  },
                ),
              );
              return;
            }
            if (options.method == 'PATCH') {
              uploadSessionCreated = true;
            }
            fail('Unexpected Drive request: ${options.method} ${options.uri}');
          },
        ),
      );

      await expectLater(
        GoogleDriveApi(dio: dio).uploadSnapshot(
          accessToken: 'access-token',
          snapshot: snapshot,
          localRef: 'primary-snapshot',
          snapshotVersion: 'snapshot-2',
          contentHash: 'sha256:${sha256.convert(bytes)}',
          operationId: 'operation-1234567890',
          existingFile: const GoogleDriveFile(
            id: 'file-1',
            version: '4',
            etag: null,
            sizeBytes: 3,
            modifiedAt: null,
            appProperties: {'noema_local_ref': 'primary-snapshot'},
          ),
        ),
        throwsA(
          isA<GoogleDriveApiException>().having(
            (error) => error.code,
            'code',
            'drive_revision_conflict',
          ),
        ),
      );
      expect(uploadSessionCreated, isFalse);
    },
  );

  test('distinguishes a disabled Drive API from a missing scope', () async {
    await _expectListFilesError(
      {
        'error': {
          'errors': [
            {'reason': 'accessNotConfigured'},
          ],
        },
      },
      code: 'unknown_error',
      message: 'A Google Drive API não está habilitada',
    );
    await _expectListFilesError(
      {
        'error': {
          'errors': [
            {'reason': 'insufficientPermissions'},
          ],
        },
      },
      code: 'drive_appdata_scope_missing',
      message: 'Toque em Renovar autorização',
    );
  });

  test('lists only non-trashed files with the requested app property', () async {
    late Map<String, dynamic> queryParameters;
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          queryParameters = options.queryParameters;
          handler.resolve(
            Response<Object>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'files': [
                  {
                    'id': 'snapshot-1',
                    'version': '2',
                    'appProperties': {'noema_local_ref': "primary'snapshot"},
                  },
                ],
              },
            ),
          );
        },
      ),
    );

    final files = await GoogleDriveApi(
      dio: dio,
    ).listFiles(accessToken: 'access-token', localRef: "primary'snapshot");

    expect(files.map((file) => file.id), ['snapshot-1']);
    expect(queryParameters['spaces'], 'appDataFolder');
    expect(
      queryParameters['q'],
      r"trashed = false and appProperties has { key='noema_local_ref' and value='primary\'snapshot' }",
    );
  });
}

Future<void> _expectListFilesError(
  Map<String, Object> responseData, {
  required String code,
  required String message,
}) async {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<Object>(
            requestOptions: options,
            statusCode: 403,
            data: responseData,
          ),
        );
      },
    ),
  );

  await expectLater(
    GoogleDriveApi(
      dio: dio,
    ).listFiles(accessToken: 'access-token', localRef: 'primary-snapshot'),
    throwsA(
      isA<GoogleDriveApiException>()
          .having((error) => error.code, 'code', code)
          .having((error) => error.message, 'message', contains(message)),
    ),
  );
}
