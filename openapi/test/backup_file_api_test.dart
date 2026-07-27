import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for BackupFileApi
void main() {
  final instance = Openapi().getBackupFileApi();

  group(BackupFileApi, () {
    // Create Backup File
    //
    //Future<BackupFileOut> createBackupFileApiV1GoogleDriveBackupFileCreatePost(BackupFileCreate backupFileCreate) async
    test('test createBackupFileApiV1GoogleDriveBackupFileCreatePost', () async {
      // TODO
    });

    // Delete Backup File
    //
    //Future<JsonObject> deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(String identificator) async
    test('test deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Backup File
    //
    //Future<BackupFileOut> getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet(String identificator) async
    test('test getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet', () async {
      // TODO
    });

    // List Backup File
    //
    //Future<BuiltList<BackupFileOut>> listBackupFileApiV1GoogleDriveBackupFileListGet({ String id, String idGoogleAccount, String driveFileId, String localRef, String driveVersion, String contentHash, DateTime createdAt }) async
    test('test listBackupFileApiV1GoogleDriveBackupFileListGet', () async {
      // TODO
    });

  });
}
