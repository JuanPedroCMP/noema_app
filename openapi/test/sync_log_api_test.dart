import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SyncLogApi
void main() {
  final instance = Openapi().getSyncLogApi();

  group(SyncLogApi, () {
    // Create Sync Log
    //
    //Future<SyncLogOut> createSyncLogApiV1GoogleDriveSyncLogCreatePost(SyncLogCreate syncLogCreate) async
    test('test createSyncLogApiV1GoogleDriveSyncLogCreatePost', () async {
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
    //Future<BuiltList<SyncLogOut>> listSyncLogApiV1GoogleDriveSyncLogListGet({ String id, String idDevice, String idBackupFile, String event, SyncDirection derection, SyncResult result, ConflictStrategy conflictStrategy, String errorDetails, String metadata, DateTime createdAt }) async
    test('test listSyncLogApiV1GoogleDriveSyncLogListGet', () async {
      // TODO
    });

  });
}
