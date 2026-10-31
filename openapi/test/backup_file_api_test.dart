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
    //Future<BuiltMap<String, bool?>> deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(String identificator) async
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
    //Future<BuiltList<BackupFileOut>> listBackupFileApiV1GoogleDriveBackupFileListGet(BackupFileFilters filters, { int limit, int offset }) async
    test('test listBackupFileApiV1GoogleDriveBackupFileListGet', () async {
      // TODO
    });

  });
}
