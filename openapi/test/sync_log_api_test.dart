import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SyncLogApi
void main() {
  final instance = Openapi().getSyncLogApi();

  group(SyncLogApi, () {
    // Create Sync Log Endpoint
    //
    //Future<SyncLogOut> createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(SyncLogCreate syncLogCreate) async
    test('test createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost', () async {
      // TODO
    });

    // Get Sync Log
    //
    //Future<SyncLogOut> getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet(String identificator) async
    test('test getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet', () async {
      // TODO
    });

    // List Sync Log
    //
    //Future<BuiltList<SyncLogOut>> listSyncLogApiV1GoogleDriveSyncLogListGet(SyncLogFilters filters, { int limit, int offset }) async
    test('test listSyncLogApiV1GoogleDriveSyncLogListGet', () async {
      // TODO
    });

  });
}
