import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for GoogleDriveSyncApi
void main() {
  final instance = Openapi().getGoogleDriveSyncApi();

  group(GoogleDriveSyncApi, () {
    // Record metadata after the app completes a direct Drive upload
    //
    //Future<BackupFileOut> createBackupApiV1GoogleDriveBackupsPost(BackupMetadataCreate backupMetadataCreate) async
    test('test createBackupApiV1GoogleDriveBackupsPost', () async {
      // TODO
    });

    // Create Backup File
    //
    //Future<BackupFileOut> createBackupFileApiV1GoogleDriveBackupFileCreatePost(BackupFileCreate backupFileCreate) async
    test('test createBackupFileApiV1GoogleDriveBackupFileCreatePost', () async {
      // TODO
    });

    // Create Sync Log Endpoint
    //
    //Future<SyncLogOut> createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(SyncLogCreate syncLogCreate) async
    test('test createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost', () async {
      // TODO
    });

    // Delete metadata only; the app must delete the Drive file separately
    //
    //Future<BuiltMap<String, bool?>> deleteBackupApiV1GoogleDriveBackupsBackupIdDelete(String backupId) async
    test('test deleteBackupApiV1GoogleDriveBackupsBackupIdDelete', () async {
      // TODO
    });

    // Delete Backup File
    //
    //Future<BuiltMap<String, bool?>> deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(String identificator) async
    test('test deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get one owned backup metadata record
    //
    //Future<BackupFileOut> getBackupApiV1GoogleDriveBackupsBackupIdGet(String backupId) async
    test('test getBackupApiV1GoogleDriveBackupsBackupIdGet', () async {
      // TODO
    });

    // Get Backup File
    //
    //Future<BackupFileOut> getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet(String identificator) async
    test('test getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet', () async {
      // TODO
    });

    // Get Sync Log
    //
    //Future<SyncLogOut> getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet(String identificator) async
    test('test getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet', () async {
      // TODO
    });

    // Link a native Google authorization without storing its tokens
    //
    //Future<GoogleAccountStatusOut> googleAccountLinkApiV1GoogleDriveAccountLinkPost(GoogleAccountLinkRequest googleAccountLinkRequest) async
    test('test googleAccountLinkApiV1GoogleDriveAccountLinkPost', () async {
      // TODO
    });

    // Get Google account and Drive app-data authorization state
    //
    //Future<GoogleAccountStatusOut> googleAccountStatusApiV1GoogleDriveAccountStatusGet() async
    test('test googleAccountStatusApiV1GoogleDriveAccountStatusGet', () async {
      // TODO
    });

    // List Backup File
    //
    //Future<BuiltList<BackupFileOut>> listBackupFileApiV1GoogleDriveBackupFileListGet(BackupFileFilters filters, { int limit, int offset }) async
    test('test listBackupFileApiV1GoogleDriveBackupFileListGet', () async {
      // TODO
    });

    // List backup metadata owned by the authenticated user
    //
    //Future<BuiltList<BackupFileOut>> listBackupsApiV1GoogleDriveBackupsGet(BackupFileFilters filters, { int limit, int offset }) async
    test('test listBackupsApiV1GoogleDriveBackupsGet', () async {
      // TODO
    });

    // List Sync Log
    //
    //Future<BuiltList<SyncLogOut>> listSyncLogApiV1GoogleDriveSyncLogListGet(SyncLogFilters filters, { int limit, int offset }) async
    test('test listSyncLogApiV1GoogleDriveSyncLogListGet', () async {
      // TODO
    });

    // Re-check the currently linked Google authorization
    //
    //Future<GoogleAccountStatusOut> refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost(GoogleAccountLinkRequest googleAccountLinkRequest) async
    test('test refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost', () async {
      // TODO
    });

    // Update metadata with optimistic Drive-version and hash preconditions
    //
    //Future<BackupFileOut> updateBackupApiV1GoogleDriveBackupsBackupIdPut(String backupId, BackupMetadataUpdate backupMetadataUpdate) async
    test('test updateBackupApiV1GoogleDriveBackupsBackupIdPut', () async {
      // TODO
    });

  });
}
