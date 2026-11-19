import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_sync_service.dart';

void main() {
  test('backup metadata keys fingerprint the complete stable request', () {
    final firstKey = GoogleDriveSyncService.metadataIdempotencyKey(
      operation: 'backup.update',
      backupId: 'backup-1',
      request: {
        'drive_version': '43',
        'content_hash': 'sha256:0123456789abcdef',
        'manifest': {
          'hashes': {'notes': 'one', 'graphs': 'two'},
        },
      },
    );
    final retryKey = GoogleDriveSyncService.metadataIdempotencyKey(
      operation: 'backup.update',
      backupId: 'backup-1',
      request: {
        'manifest': {
          'hashes': {'graphs': 'two', 'notes': 'one'},
        },
        'content_hash': 'sha256:0123456789abcdef',
        'drive_version': '43',
      },
    );
    final changedRequestKey =
        GoogleDriveSyncService.metadataIdempotencyKey(
          operation: 'backup.update',
          backupId: 'backup-1',
          request: {
            'drive_version': '44',
            'content_hash': 'sha256:0123456789abcdef',
            'manifest': {
              'hashes': {'notes': 'one', 'graphs': 'two'},
            },
          },
        );

    expect(retryKey, firstKey);
    expect(changedRequestKey, isNot(firstKey));
  });

  group('automatic conflict resolution', () {
    test('uses the remote snapshot when only the remote changed', () {
      expect(
        DriveSyncPreview.inferAutomaticResolution(
          lastSyncedDataHash: 'base',
          lastDeviceSyncAt: null,
          remoteUpdatedAt: null,
          localDataHash: 'base',
          remoteDataHash: 'remote',
          localInstallationId: 'device-a',
          remoteInstallationId: 'device-b',
        ),
        DriveSyncResolution.keepRemote,
      );
    });

    test('uses the local snapshot when only the local changed', () {
      expect(
        DriveSyncPreview.inferAutomaticResolution(
          lastSyncedDataHash: 'base',
          lastDeviceSyncAt: null,
          remoteUpdatedAt: null,
          localDataHash: 'local',
          remoteDataHash: 'base',
          localInstallationId: 'device-a',
          remoteInstallationId: 'device-b',
        ),
        DriveSyncResolution.keepLocal,
      );
    });

    test('keeps prompting when both sides changed', () {
      expect(
        DriveSyncPreview.inferAutomaticResolution(
          lastSyncedDataHash: 'base',
          lastDeviceSyncAt: null,
          remoteUpdatedAt: null,
          localDataHash: 'local',
          remoteDataHash: 'remote',
          localInstallationId: 'device-a',
          remoteInstallationId: 'device-b',
        ),
        isNull,
      );
    });

    test('keeps prompting without a common sync baseline', () {
      expect(
        DriveSyncPreview.inferAutomaticResolution(
          lastSyncedDataHash: null,
          lastDeviceSyncAt: null,
          remoteUpdatedAt: null,
          localDataHash: 'local',
          remoteDataHash: 'remote',
          localInstallationId: 'device-a',
          remoteInstallationId: 'device-b',
        ),
        isNull,
      );
    });

    test('uses local data when it is the source of the remote backup', () {
      expect(
        DriveSyncPreview.inferAutomaticResolution(
          lastSyncedDataHash: null,
          lastDeviceSyncAt: null,
          remoteUpdatedAt: null,
          localDataHash: 'local',
          remoteDataHash: 'remote',
          localInstallationId: 'same-device',
          remoteInstallationId: 'same-device',
        ),
        DriveSyncResolution.keepLocal,
      );
    });

    test('uses local data when Drive has not changed since device sync', () {
      expect(
        DriveSyncPreview.inferAutomaticResolution(
          lastSyncedDataHash: null,
          lastDeviceSyncAt: DateTime.utc(2026, 11, 10),
          remoteUpdatedAt: DateTime.utc(2026, 11, 9),
          localDataHash: 'local',
          remoteDataHash: 'remote',
          localInstallationId: 'device-a',
          remoteInstallationId: 'device-b',
        ),
        DriveSyncResolution.keepLocal,
      );
    });

    test(
      'keeps prompting when Drive advanced after device sync without a hash',
      () {
        expect(
          DriveSyncPreview.inferAutomaticResolution(
            lastSyncedDataHash: null,
            lastDeviceSyncAt: DateTime.utc(2026, 11, 9),
            remoteUpdatedAt: DateTime.utc(2026, 11, 10),
            localDataHash: 'local',
            remoteDataHash: 'remote',
            localInstallationId: 'device-a',
            remoteInstallationId: 'device-b',
          ),
          isNull,
        ),
      },
    );
  });

  test('does not treat an unconfirmed backup list as an empty Drive', () {
    expect(
      () => GoogleDriveSyncService.sortedBackups(null),
      throwsA(
        isA<DriveSyncException>().having(
          (error) => error.code,
          'code',
          'backup_list_unconfirmed',
        ),
      ),
    );
  });
}
