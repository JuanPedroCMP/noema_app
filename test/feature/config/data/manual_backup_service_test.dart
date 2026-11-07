import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/config/data/manual_backup_service.dart';

void main() {
  late AppDatabase database;
  late ManualBackupService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = ManualBackupService(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('persists operation strategy, size, encryption, and timing', () async {
    final startedAt = DateTime.now().subtract(const Duration(seconds: 2));
    await service.recordOperation(
      operation: ManualBackupOperation.import,
      status: 'succeeded',
      strategy: 'merge',
      startedAt: startedAt,
      archiveSizeBytes: 1200,
      snapshotSizeBytes: 2400,
      recordCount: 17,
      encrypted: true,
    );

    final history = await service.history();
    expect(history, hasLength(1));
    expect(history.single.operation, ManualBackupOperation.import);
    expect(history.single.status, 'succeeded');
    expect(history.single.strategy, 'merge');
    expect(history.single.archiveSizeBytes, 1200);
    expect(history.single.snapshotSizeBytes, 2400);
    expect(history.single.recordCount, 17);
    expect(history.single.encrypted, isTrue);
    expect(history.single.durationMs, greaterThanOrEqualTo(2000));
  });

  test('retains only the 50 most recent local operation records', () async {
    for (var index = 0; index < 52; index++) {
      await service.recordOperation(
        operation: ManualBackupOperation.export,
        status: 'succeeded',
        strategy: 'export',
        startedAt: DateTime.now(),
        recordCount: index,
      );
    }

    final history = await service.history();
    expect(history, hasLength(50));
  });
}
