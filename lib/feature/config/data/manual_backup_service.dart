import 'dart:io';
import 'dart:typed_data';

import 'package:noema/core/database/database.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';
import 'package:noema/feature/config/data/manual_backup_archive.dart';
import 'package:uuid/uuid.dart';

enum ManualBackupOperation { export, import }

enum ManualBackupStrategy { keepLocal, keepRemote, merge }

class ManualBackupHistoryException implements Exception {
  const ManualBackupHistoryException(this.cause);

  final Object cause;

  @override
  String toString() =>
      'A operação foi concluída, mas o histórico local não pôde ser salvo: $cause';
}

class ManualBackupHistoryEntry {
  const ManualBackupHistoryEntry({
    required this.operation,
    required this.status,
    required this.strategy,
    required this.createdAt,
    required this.archiveSizeBytes,
    required this.snapshotSizeBytes,
    required this.recordCount,
    required this.encrypted,
    required this.durationMs,
    this.details,
  });

  final ManualBackupOperation operation;
  final String status;
  final String strategy;
  final DateTime createdAt;
  final int archiveSizeBytes;
  final int snapshotSizeBytes;
  final int recordCount;
  final bool encrypted;
  final int durationMs;
  final String? details;
}

class ExportedManualBackup {
  const ExportedManualBackup({
    required this.bytes,
    required this.snapshotSizeBytes,
    required this.recordCount,
    required this.encrypted,
    required this.startedAt,
  });

  final Uint8List bytes;
  final int snapshotSizeBytes;
  final int recordCount;
  final bool encrypted;
  final DateTime startedAt;
}

class ManualBackupImportPreview {
  const ManualBackupImportPreview({
    required this.incoming,
    required this.local,
    required this.diff,
    required this.archiveSizeBytes,
    required this.encrypted,
    required this.recordCount,
    required this.startedAt,
  });

  final LocalSnapshot incoming;
  final LocalSnapshot local;
  final SnapshotDiff diff;
  final int archiveSizeBytes;
  final bool encrypted;
  final int recordCount;
  final DateTime startedAt;
}

class ManualBackupService {
  ManualBackupService(this.database);

  final AppDatabase database;

  Future<ExportedManualBackup> createArchive({
    required String localUserId,
    required String remoteUserId,
    required bool encrypt,
    ManualBackupKeyMode keyMode = ManualBackupKeyMode.accountId,
    String? customKey,
  }) async {
    final startedAt = DateTime.now();
    LocalSnapshot? snapshot;
    try {
      snapshot = await LocalSnapshot.create(
        database: database,
        localUserId: localUserId,
        remoteUserId: remoteUserId,
      );
      final snapshotBytes = await snapshot.file.readAsBytes();
      final bytes = await ManualBackupArchive.encode(
        snapshotBytes: snapshotBytes,
        accountId: remoteUserId,
        encrypt: encrypt,
        keyMode: keyMode,
        customKey: customKey,
      );
      return ExportedManualBackup(
        bytes: bytes,
        snapshotSizeBytes: snapshotBytes.length,
        recordCount: _recordCount(snapshot.manifest),
        encrypted: encrypt,
        startedAt: startedAt,
      );
    } on Object {
      await recordOperation(
        operation: ManualBackupOperation.export,
        status: 'failed',
        strategy: 'export',
        startedAt: startedAt,
        encrypted: encrypt,
        details: 'A exportação não foi concluída.',
      );
      rethrow;
    } finally {
      await _deleteSnapshotFile(snapshot?.file);
    }
  }

  Future<ManualBackupImportPreview> inspectArchive({
    required Uint8List bytes,
    required String localUserId,
    required String remoteUserId,
    String? customKey,
  }) async {
    final startedAt = DateTime.now();
    LocalSnapshot? incoming;
    LocalSnapshot? local;
    try {
      final decoded = await ManualBackupArchive.decode(
        bytes: bytes,
        accountId: remoteUserId,
        customKey: customKey,
      );
      final importFile = await _writeImportTemp(decoded.snapshotBytes);
      incoming = await LocalSnapshot.fromFile(
        file: importFile,
        expectedRemoteUserId: remoteUserId,
      );
      local = await LocalSnapshot.create(
        database: database,
        localUserId: localUserId,
        remoteUserId: remoteUserId,
      );
      return ManualBackupImportPreview(
        incoming: incoming,
        local: local,
        diff: compareSnapshots(
          local.document['data'] as Map<String, dynamic>,
          incoming.document['data'] as Map<String, dynamic>,
        ),
        archiveSizeBytes: bytes.length,
        encrypted: decoded.encrypted,
        recordCount: _recordCount(incoming.manifest),
        startedAt: startedAt,
      );
    } on Object {
      await recordOperation(
        operation: ManualBackupOperation.import,
        status: 'failed',
        strategy: 'validate',
        startedAt: startedAt,
        archiveSizeBytes: bytes.length,
        details: 'O arquivo não pôde ser validado.',
      );
      await _deleteSnapshotFile(incoming?.file);
      await _deleteSnapshotFile(local?.file);
      rethrow;
    }
  }

  Future<void> applyImport(
    ManualBackupImportPreview preview,
    ManualBackupStrategy strategy, {
    required String localUserId,
    required String remoteUserId,
  }) async {
    try {
      final repository = LocalSnapshotRepository(database);
      switch (strategy) {
        case ManualBackupStrategy.keepLocal:
          break;
        case ManualBackupStrategy.keepRemote:
          await repository.restoreRemote(
            snapshot: preview.incoming,
            localUserId: localUserId,
          );
        case ManualBackupStrategy.merge:
          await repository.merge(
            local: preview.local,
            remote: preview.incoming,
            localUserId: localUserId,
            remoteUserId: remoteUserId,
          );
      }
    } on Object catch (error, stackTrace) {
      await recordOperation(
        operation: ManualBackupOperation.import,
        status: 'failed',
        strategy: _strategyName(strategy),
        startedAt: preview.startedAt,
        archiveSizeBytes: preview.archiveSizeBytes,
        snapshotSizeBytes: preview.incoming.sizeBytes,
        recordCount: preview.recordCount,
        encrypted: preview.encrypted,
        details: 'A restauração não foi concluída; os dados locais foram mantidos.',
      );
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await disposePreview(preview);
    }
    try {
      await recordOperation(
        operation: ManualBackupOperation.import,
        status: 'succeeded',
        strategy: _strategyName(strategy),
        startedAt: preview.startedAt,
        archiveSizeBytes: preview.archiveSizeBytes,
        snapshotSizeBytes: preview.incoming.sizeBytes,
        recordCount: preview.recordCount,
        encrypted: preview.encrypted,
        details: preview.diff.isEmpty
            ? 'Os dados já eram iguais; nenhuma alteração foi necessária.'
            : null,
      );
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(ManualBackupHistoryException(error), stackTrace);
    }
  }

  Future<void> disposePreview(ManualBackupImportPreview preview) async {
    await _deleteSnapshotFile(preview.incoming.file);
    if (preview.local.file.path != preview.incoming.file.path) {
      await _deleteSnapshotFile(preview.local.file);
    }
  }

  Future<void> recordExportSuccess(ExportedManualBackup export) async {
    try {
      await recordOperation(
        operation: ManualBackupOperation.export,
        status: 'succeeded',
        strategy: 'export',
        startedAt: export.startedAt,
        archiveSizeBytes: export.bytes.length,
        snapshotSizeBytes: export.snapshotSizeBytes,
        recordCount: export.recordCount,
        encrypted: export.encrypted,
      );
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(ManualBackupHistoryException(error), stackTrace);
    }
  }

  Future<void> recordOperation({
    required ManualBackupOperation operation,
    required String status,
    required String strategy,
    required DateTime startedAt,
    int archiveSizeBytes = 0,
    int snapshotSizeBytes = 0,
    int recordCount = 0,
    bool encrypted = false,
    String? details,
  }) async {
    await database.customStatement(
      'INSERT INTO manual_backup_history '
      '(id, operation, status, strategy, created_at, archive_size_bytes, '
      'snapshot_size_bytes, record_count, encrypted, duration_ms, details) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        const Uuid().v4(),
        operation.name,
        status,
        strategy,
        DateTime.now().millisecondsSinceEpoch,
        archiveSizeBytes,
        snapshotSizeBytes,
        recordCount,
        encrypted ? 1 : 0,
        DateTime.now().difference(startedAt).inMilliseconds,
        details,
      ],
    );
    await database.customStatement('''
      DELETE FROM manual_backup_history
      WHERE id NOT IN (
        SELECT id FROM manual_backup_history
        ORDER BY created_at DESC
        LIMIT 50
      )
    ''');
  }

  Future<List<ManualBackupHistoryEntry>> history() async {
    final rows = await database
        .customSelect(
          'SELECT operation, status, strategy, created_at, '
          'archive_size_bytes, snapshot_size_bytes, record_count, encrypted, '
          'duration_ms, details FROM manual_backup_history '
          'ORDER BY created_at DESC LIMIT 50',
        )
        .get();
    return [
      for (final row in rows)
        ManualBackupHistoryEntry(
          operation: ManualBackupOperation.values.byName(
            row.data['operation'] as String,
          ),
          status: row.data['status'] as String,
          strategy: row.data['strategy'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            row.data['created_at'] as int,
          ),
          archiveSizeBytes: row.data['archive_size_bytes'] as int,
          snapshotSizeBytes: row.data['snapshot_size_bytes'] as int,
          recordCount: row.data['record_count'] as int,
          encrypted: row.data['encrypted'] == 1,
          durationMs: row.data['duration_ms'] as int,
          details: row.data['details'] as String?,
        ),
    ];
  }

  Future<File> _writeImportTemp(Uint8List bytes) async {
    final directory = Directory.systemTemp;
    final file = File(
      '${directory.path}${Platform.pathSeparator}noema-import-${const Uuid().v4()}.json',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _deleteSnapshotFile(File? file) async {
    if (file != null && await file.exists()) await file.delete();
  }

  int _recordCount(Map<String, dynamic> manifest) {
    final counts = manifest['counts'];
    if (counts is! Map) return 0;
    return counts.values.whereType<int>().fold(0, (total, count) => total + count);
  }

  String _strategyName(ManualBackupStrategy strategy) => switch (strategy) {
    ManualBackupStrategy.keepLocal => 'keep_local',
    ManualBackupStrategy.keepRemote => 'keep_file',
    ManualBackupStrategy.merge => 'merge',
  };
}

String manualBackupStrategyLabel(String value) => switch (value) {
  'export' => 'Exportação',
  'validate' => 'Validação',
  'keep_local' => 'Manter neste dispositivo',
  'keep_file' => 'Usar arquivo',
  'merge' => 'Mesclar',
  _ => value,
};
