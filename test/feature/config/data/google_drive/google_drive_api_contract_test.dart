import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart';

void main() {
  test('sends backup filters as flattened API query parameters', () async {
    final capturedQueryParameters = <Map<String, dynamic>>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          capturedQueryParameters.add(options.queryParameters);
          handler.resolve(
            Response<Object>(requestOptions: options, data: const []),
          );
        },
      ),
    );
    final api = Openapi(dio: dio).getGoogleDriveSyncApi();

    await api.listBackupsApiV1GoogleDriveBackupsGet(
      filters: BackupFileFilters(
        (builder) => builder
          ..idGoogleAccount = 'google-account'
          ..localRef = 'primary-snapshot'
          ..operationState = BackupOperationState.completed,
      ),
      limit: 100,
      offset: 0,
    );
    const expectedQueryParameters = {
      'id_google_account': 'google-account',
      'local_ref': 'primary-snapshot',
      'operation_state': 'completed',
      'limit': 100,
      'offset': 0,
    };
    expect(capturedQueryParameters.single, expectedQueryParameters);
  });
}
