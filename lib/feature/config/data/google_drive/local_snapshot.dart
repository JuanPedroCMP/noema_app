import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/device_fingerprint.dart';
import 'package:path_provider/path_provider.dart';

const localSnapshotFormat = 'noema-snapshot';
const localSnapshotSchemaVersion = 1;
const maxLocalSnapshotBytes = 256 * 1024 * 1024;
const _snapshotOwnerMarker = '__noema_snapshot_owner__';
const _snapshotFileName = 'noema-local-snapshot.json';

const snapshotCategories = <String>[
  'custom_themes',
  'graphs_and_notes',
  'learning_content',
  'study_history',
  'activity_history',
];

const excludedSnapshotCategories = <String>[
  'account_and_authentication',
  'server_synchronized_preferences',
  'device_registry',
  'google_credentials',
  'ai_background_tasks',
];

class _SnapshotTable {
  const _SnapshotTable(this.category, this.name, this.filter);

  final String category;
  final String name;
  final String filter;
}

const _snapshotTables = <_SnapshotTable>[
  _SnapshotTable(
    'custom_themes',
    'color_theme',
    'user_id = ? AND system_default = 0',
  ),
  _SnapshotTable(
    'custom_themes',
    'typography_theme',
    'user_id = ? AND system_default = 0',
  ),
  _SnapshotTable('graphs_and_notes', 'knowledge_graph', 'user_id = ?'),
  _SnapshotTable(
    'graphs_and_notes',
    'graph_version',
    'graph_id IN (SELECT id FROM knowledge_graph WHERE user_id = ?)',
  ),
  _SnapshotTable(
    'graphs_and_notes',
    'graph_node',
    'graph_id IN (SELECT id FROM knowledge_graph WHERE user_id = ?)',
  ),
  _SnapshotTable(
    'graphs_and_notes',
    'graph_edge',
    'graph_id IN (SELECT id FROM knowledge_graph WHERE user_id = ?)',
  ),
  _SnapshotTable(
    'graphs_and_notes',
    'node_skill',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'graphs_and_notes',
    'learning_resource',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable('graphs_and_notes', 'note', 'user_id = ?'),
  _SnapshotTable(
    'graphs_and_notes',
    'note_version',
    'note_id IN (SELECT id FROM note WHERE user_id = ?)',
  ),
  _SnapshotTable(
    'graphs_and_notes',
    'note_node',
    'note_id IN (SELECT id FROM note WHERE user_id = ?) AND '
        'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable('study_history', 'study_session', 'user_id = ?'),
  _SnapshotTable(
    'study_history',
    'study_session_log',
    'study_session_id IN (SELECT id FROM study_session WHERE user_id = ?)',
  ),
  _SnapshotTable(
    'study_history',
    'study_session_use_knowledge_graph',
    'study_session_id IN (SELECT id FROM study_session WHERE user_id = ?) AND '
        'graph_id IN (SELECT id FROM knowledge_graph WHERE user_id = ?)',
  ),
  _SnapshotTable(
    'study_history',
    'session_node',
    'study_session_id IN (SELECT id FROM study_session WHERE user_id = ?) AND '
        'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'learning_content',
    'flashcard',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'learning_content',
    'flashcard_group',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'learning_content',
    'flashcard_belongs_group',
    'flashcard_id IN (SELECT id FROM flashcard WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))) AND '
        'flashcard_group_id IN (SELECT id FROM flashcard_group WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?)))',
  ),
  _SnapshotTable(
    'study_history',
    'flashcard_response_log',
    'flashcard_id IN (SELECT id FROM flashcard WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?)))',
  ),
  _SnapshotTable(
    'learning_content',
    'multiple_choice',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'learning_content',
    'choice',
    'multiple_choice_id IN (SELECT id FROM multiple_choice WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?)))',
  ),
  _SnapshotTable(
    'study_history',
    'multiple_choice_response_log',
    'multiple_choice_id IN (SELECT id FROM multiple_choice WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))) AND '
        '(study_session_id IS NULL OR study_session_id IN '
        '(SELECT id FROM study_session WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'learning_content',
    'open_ended',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'study_history',
    'study_session_question',
    'study_session_id IN (SELECT id FROM study_session WHERE user_id = ?) AND '
        '((multiple_choice_id IS NOT NULL AND multiple_choice_id IN '
        '(SELECT id FROM multiple_choice WHERE node_id IN (SELECT id FROM graph_node '
        'WHERE graph_id IN (SELECT id FROM knowledge_graph WHERE user_id = ?)))) OR '
        '(open_ended_id IS NOT NULL AND open_ended_id IN '
        '(SELECT id FROM open_ended WHERE node_id IN (SELECT id FROM graph_node '
        'WHERE graph_id IN (SELECT id FROM knowledge_graph WHERE user_id = ?)))))',
  ),
  _SnapshotTable(
    'study_history',
    'open_ended_response_log',
    'open_ended_id IN (SELECT id FROM open_ended WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))) AND '
        '(study_session_id IS NULL OR study_session_id IN '
        '(SELECT id FROM study_session WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'study_history',
    'review_item_state',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'study_history',
    'review_item_log',
    'review_item_state_id IN (SELECT id FROM review_item_state WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?)))',
  ),
  _SnapshotTable(
    'study_history',
    'fsrs_state',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable(
    'study_history',
    'fsrs_review_log',
    'fsrs_state_id IN (SELECT id FROM fsrs_state WHERE node_id IN '
        '(SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?)))',
  ),
  _SnapshotTable(
    'study_history',
    'domain_log',
    'node_id IN (SELECT id FROM graph_node WHERE graph_id IN '
        '(SELECT id FROM knowledge_graph WHERE user_id = ?))',
  ),
  _SnapshotTable('activity_history', 'generic_log', 'user_id = ?'),
];

const _insertOrder = <String>[
  'color_theme',
  'typography_theme',
  'knowledge_graph',
  'graph_version',
  'graph_node',
  'graph_edge',
  'node_skill',
  'learning_resource',
  'note',
  'note_version',
  'note_node',
  'study_session',
  'study_session_log',
  'study_session_use_knowledge_graph',
  'session_node',
  'flashcard',
  'flashcard_group',
  'flashcard_belongs_group',
  'flashcard_response_log',
  'multiple_choice',
  'choice',
  'multiple_choice_response_log',
  'open_ended',
  'study_session_question',
  'open_ended_response_log',
  'review_item_state',
  'review_item_log',
  'fsrs_state',
  'fsrs_review_log',
  'domain_log',
  'generic_log',
];

const _categoryLabels = <String, String>{
  'custom_themes': 'Temas personalizados',
  'graphs_and_notes': 'Grafos e anotações',
  'learning_content': 'Flashcards e exercícios',
  'study_history': 'Sessões e histórico de estudo',
  'activity_history': 'Histórico de atividade',
};

class SnapshotChange {
  const SnapshotChange({
    required this.category,
    required this.table,
    required this.rowId,
    required this.kind,
    this.fields = const [],
    this.side,
    this.localValues = const {},
    this.remoteValues = const {},
  });

  final String category;
  final String table;
  final String rowId;
  final SnapshotChangeKind kind;
  final List<String> fields;
  final SnapshotSide? side;
  final Map<String, Object?> localValues;
  final Map<String, Object?> remoteValues;
}

enum SnapshotChangeKind { added, removed, changed }

enum SnapshotSide { local, remote }

class SnapshotCategoryDiff {
  const SnapshotCategoryDiff({
    required this.category,
    required this.localOnly,
    required this.remoteOnly,
    required this.changed,
  });

  final String category;
  final int localOnly;
  final int remoteOnly;
  final int changed;

  bool get isEmpty => localOnly == 0 && remoteOnly == 0 && changed == 0;
}

class SnapshotDiff {
  const SnapshotDiff(this.categories, this.changes);

  final List<SnapshotCategoryDiff> categories;
  final List<SnapshotChange> changes;

  bool get isEmpty => changes.isEmpty;
  int get totalChanges => changes.length;
  int get conflicts => changes
      .where((change) => change.kind == SnapshotChangeKind.changed)
      .length;
}

class LocalSnapshot {
  const LocalSnapshot({
    required this.document,
    required this.file,
    required this.contentHash,
    required this.sizeBytes,
    required this.snapshotVersion,
    required this.manifest,
  });

  final Map<String, dynamic> document;
  final File file;
  final String contentHash;
  final int sizeBytes;
  final String snapshotVersion;
  final Map<String, dynamic> manifest;

  String get dataHash => _hashJson(manifest['hashes']);

  static Future<LocalSnapshot> create({
    required AppDatabase database,
    required String localUserId,
    required String remoteUserId,
  }) async {
    final installationId = await DeviceFingerprint.get();
    return database.transaction(() async {
      final data = <String, dynamic>{
        for (final category in snapshotCategories)
          category: <String, dynamic>{},
      };
      final counts = <String, int>{
        for (final category in snapshotCategories) category: 0,
      };

      for (final spec in _snapshotTables) {
        final rows = <Map<String, dynamic>>[];
        const pageSize = 250;
        var offset = 0;
        while (true) {
          final values = <Variable<Object>>[
            for (var i = 0; i < '?'.allMatches(spec.filter).length; i++)
              Variable.withString(localUserId),
            Variable.withInt(pageSize),
            Variable.withInt(offset),
          ];
          final result = await database
              .customSelect(
                'SELECT * FROM "${spec.name}" WHERE ${spec.filter} '
                'ORDER BY id LIMIT ? OFFSET ?',
                variables: values,
              )
              .get();
          for (final queryRow in result) {
            final row = _normalizeRow(queryRow.data, localUserId);
            rows.add(row);
          }
          if (result.length < pageSize) break;
          offset += pageSize;
        }
        (data[spec.category] as Map<String, dynamic>)[spec.name] = rows;
        counts[spec.category] = counts[spec.category]! + rows.length;
      }

      final configRows = await database
          .customSelect(
            'SELECT color_theme_id, typography_theme_id FROM config WHERE user_id = ?',
            variables: [Variable.withString(localUserId)],
          )
          .get();
      if (configRows.isNotEmpty) {
        final selection = configRows.single.data;
        (data['custom_themes'] as Map<String, dynamic>)['selection'] = {
          'color_theme_id': selection['color_theme_id'],
          'typography_theme_id': selection['typography_theme_id'],
        };
      }

      final categoryHashes = <String, String>{
        for (final category in snapshotCategories)
          category: _hashJson(data[category]),
      };
      final createdAt = DateTime.now().toUtc();
      final snapshotVersion = createdAt.microsecondsSinceEpoch.toString();
      final manifest = <String, dynamic>{
        'format': localSnapshotFormat,
        'schema_version': localSnapshotSchemaVersion,
        'snapshot_version': snapshotVersion,
        'created_at': createdAt.toIso8601String(),
        'installation_id': installationId,
        'included_categories': snapshotCategories,
        'excluded_categories': excludedSnapshotCategories,
        'counts': counts,
        'hashes': categoryHashes,
      };
      final document = <String, dynamic>{
        'format': localSnapshotFormat,
        'schema_version': localSnapshotSchemaVersion,
        'local_database_schema_version': database.schemaVersion,
        'owner_remote_user_id': remoteUserId,
        'manifest': manifest,
        'data': data,
      };
      return _writeDocument(document, snapshotVersion: snapshotVersion);
    });
  }

  static Future<LocalSnapshot> fromFile({
    required File file,
    required String expectedRemoteUserId,
    String? expectedContentHash,
  }) async {
    final size = await file.length();
    if (size <= 0 || size > maxLocalSnapshotBytes) {
      throw const FormatException(
        'O arquivo de backup está vazio ou excede o limite seguro do app.',
      );
    }
    final bytes = await file.readAsBytes();
    final actualHash = 'sha256:${sha256.convert(bytes)}';
    if (expectedContentHash != null && actualHash != expectedContentHash) {
      throw const FormatException(
        'A verificação de integridade do backup falhou. Nenhum dado foi alterado.',
      );
    }

    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'O arquivo não contém um snapshot Noema válido.',
      );
    }
    _validateDocument(decoded, expectedRemoteUserId);
    final manifest = decoded['manifest'] as Map<String, dynamic>;
    final snapshotVersion = manifest['snapshot_version'] as String;
    return LocalSnapshot(
      document: decoded,
      file: file,
      contentHash: actualHash,
      sizeBytes: bytes.length,
      snapshotVersion: snapshotVersion,
      manifest: manifest,
    );
  }

  static Future<LocalSnapshot> fromDocument(
    Map<String, dynamic> document,
  ) async {
    final manifest = document['manifest'] as Map<String, dynamic>;
    final snapshotVersion = manifest['snapshot_version'] as String;
    return _writeDocument(document, snapshotVersion: snapshotVersion);
  }

  static Future<LocalSnapshot> _writeDocument(
    Map<String, dynamic> document, {
    required String snapshotVersion,
  }) async {
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(document)));
    if (bytes.length > maxLocalSnapshotBytes) {
      throw const FormatException(
        'O backup excede o limite de 256 MiB suportado pelo app.',
      );
    }
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}$_snapshotFileName-$snapshotVersion',
    );
    await file.writeAsBytes(bytes, flush: true);
    return LocalSnapshot(
      document: document,
      file: file,
      contentHash: 'sha256:${sha256.convert(bytes)}',
      sizeBytes: bytes.length,
      snapshotVersion: snapshotVersion,
      manifest: Map<String, dynamic>.from(document['manifest'] as Map),
    );
  }

  static void _validateDocument(
    Map<String, dynamic> document,
    String expectedRemoteUserId,
  ) {
    if (document['format'] != localSnapshotFormat ||
        document['schema_version'] != localSnapshotSchemaVersion) {
      throw const FormatException(
        'Este backup usa um formato ou versão que o app não reconhece.',
      );
    }
    if (document['owner_remote_user_id'] != expectedRemoteUserId) {
      throw const FormatException(
        'Este backup pertence a outra conta Noema. Nenhum dado foi alterado.',
      );
    }
    final manifest = document['manifest'];
    final data = document['data'];
    if (manifest is! Map<String, dynamic> || data is! Map<String, dynamic>) {
      throw const FormatException(
        'O manifesto ou os dados do backup estão inválidos.',
      );
    }
    if (manifest['format'] != localSnapshotFormat ||
        manifest['schema_version'] != localSnapshotSchemaVersion ||
        manifest['included_categories'] is! List ||
        manifest['counts'] is! Map ||
        manifest['hashes'] is! Map) {
      throw const FormatException(
        'O manifesto do backup está incompleto ou inválido.',
      );
    }
    final included = (manifest['included_categories'] as List).cast<String>();
    if (!listEquals(included, snapshotCategories)) {
      throw const FormatException(
        'O backup não contém exatamente as categorias de dados esperadas.',
      );
    }

    for (final category in snapshotCategories) {
      final categoryData = data[category];
      final expectedHash = (manifest['hashes'] as Map)[category];
      if (categoryData is! Map<String, dynamic> ||
          expectedHash != _hashJson(categoryData)) {
        throw FormatException(
          'Os dados da categoria "$category" estão corrompidos.',
        );
      }
      for (final spec in _snapshotTables.where(
        (item) => item.category == category,
      )) {
        final rows = categoryData[spec.name];
        if (rows is! List) {
          throw FormatException(
            'A tabela "${spec.name}" está ausente no backup.',
          );
        }
        for (final row in rows) {
          if (row is! Map<String, dynamic> || row['id'] is! String) {
            throw FormatException('Há um registro inválido em "${spec.name}".');
          }
          if (row.containsKey('user_id') &&
              row['user_id'] != null &&
              row['user_id'] != _snapshotOwnerMarker) {
            throw FormatException(
              'O backup contém um registro fora da conta autenticada em "${spec.name}".',
            );
          }
        }
      }
    }
  }
}

class LocalSnapshotRepository {
  LocalSnapshotRepository(this.database);

  final AppDatabase database;

  Future<void> restoreRemote({
    required LocalSnapshot snapshot,
    required String localUserId,
  }) async {
    await _replaceDomainData(snapshot, localUserId);
  }

  Future<LocalSnapshot> merge({
    required LocalSnapshot local,
    required LocalSnapshot remote,
    required String localUserId,
    required String remoteUserId,
  }) async {
    final mergedData = mergeSnapshotData(
      local.document['data'] as Map<String, dynamic>,
      remote.document['data'] as Map<String, dynamic>,
    );
    final now = DateTime.now().toUtc();
    final counts = <String, int>{};
    final hashes = <String, String>{};
    for (final category in snapshotCategories) {
      final categoryData = mergedData[category] as Map<String, dynamic>;
      counts[category] = _snapshotTables
          .where((table) => table.category == category)
          .fold<int>(
            0,
            (total, table) => total + (categoryData[table.name] as List).length,
          );
      hashes[category] = _hashJson(categoryData);
    }
    final version = now.microsecondsSinceEpoch.toString();
    final manifest = <String, dynamic>{
      'format': localSnapshotFormat,
      'schema_version': localSnapshotSchemaVersion,
      'snapshot_version': version,
      'created_at': now.toIso8601String(),
      'installation_id': await DeviceFingerprint.get(),
      'included_categories': snapshotCategories,
      'excluded_categories': excludedSnapshotCategories,
      'counts': counts,
      'hashes': hashes,
    };
    final document = <String, dynamic>{
      'format': localSnapshotFormat,
      'schema_version': localSnapshotSchemaVersion,
      'local_database_schema_version': database.schemaVersion,
      'owner_remote_user_id': remoteUserId,
      'manifest': manifest,
      'data': mergedData,
    };
    final merged = await LocalSnapshot.fromDocument(document);
    await _replaceDomainData(merged, localUserId);
    return merged;
  }

  Future<void> _replaceDomainData(
    LocalSnapshot snapshot,
    String localUserId,
  ) async {
    final data = snapshot.document['data'] as Map<String, dynamic>;
    final themeData = data['custom_themes'] as Map<String, dynamic>;
    final categories = <String, Map<String, dynamic>>{
      for (final category in snapshotCategories)
        category: Map<String, dynamic>.from(data[category] as Map),
    };
    final themeIdMappings = <String, Map<String, String>>{
      'color_theme': {},
      'typography_theme': {},
    };

    await database.transaction(() async {
      await database.customStatement(
        'DELETE FROM study_session WHERE user_id = ?',
        [localUserId],
      );
      await database.customStatement('DELETE FROM note WHERE user_id = ?', [
        localUserId,
      ]);
      await database.customStatement(
        'DELETE FROM knowledge_graph WHERE user_id = ?',
        [localUserId],
      );
      await database.customStatement(
        'DELETE FROM generic_log WHERE user_id = ?',
        [localUserId],
      );

      for (final table in _insertOrder) {
        final category = _snapshotTables
            .firstWhere((spec) => spec.name == table)
            .category;
        final rows = categories[category]![table] as List;
        for (final value in rows) {
          final row = Map<String, dynamic>.from(value as Map);
          if (row['user_id'] == _snapshotOwnerMarker) {
            row['user_id'] = localUserId;
          }
          final restoredId = await _insertRow(table, row, localUserId);
          if (table == 'color_theme' || table == 'typography_theme') {
            themeIdMappings[table]![row['id'] as String] = restoredId;
          }
        }
      }

      final selection = themeData['selection'];
      if (selection is Map<String, dynamic>) {
        await _restoreThemeSelection(selection, localUserId, themeIdMappings);
      }
      await _removeUnusedCustomThemes(
        'color_theme',
        localUserId,
        themeIdMappings['color_theme']!.values.toSet(),
      );
      await _removeUnusedCustomThemes(
        'typography_theme',
        localUserId,
        themeIdMappings['typography_theme']!.values.toSet(),
      );

      final invalidReferences = await database
          .customSelect('PRAGMA foreign_key_check')
          .get();
      if (invalidReferences.isNotEmpty) {
        throw StateError(
          'O backup contém relações inválidas. A restauração foi cancelada.',
        );
      }
    });
  }

  Future<String> _insertRow(
    String table,
    Map<String, dynamic> row,
    String localUserId,
  ) async {
    final columnsResult = await database
        .customSelect('PRAGMA table_info("$table")')
        .get();
    final columnInfo = {
      for (final column in columnsResult)
        if (column.data['name'] is String)
          column.data['name'] as String: column.data,
    };
    final columns = columnInfo.keys.toSet();
    final missingRequiredColumns = columnInfo.entries
        .where(
          (entry) =>
              !row.containsKey(entry.key) &&
              (entry.value['notnull'] == 1 || entry.value['pk'] != 0) &&
              entry.value['dflt_value'] == null,
        )
        .map((entry) => entry.key)
        .toList()
      ..sort();
    if (missingRequiredColumns.isNotEmpty || !row.containsKey('id')) {
      throw FormatException(
        'O backup não contém as colunas obrigatórias da tabela "$table": '
        '${missingRequiredColumns.isEmpty ? "id" : missingRequiredColumns.join(", ")}.',
      );
    }

    if (table == 'color_theme' || table == 'typography_theme') {
      final existing = await database
          .customSelect(
            'SELECT user_id FROM "$table" WHERE id = ?',
            variables: [Variable.withString(row['id'] as String)],
          )
          .get();
      if (existing.isNotEmpty &&
          existing.single.data['user_id'] != localUserId) {
        throw StateError(
          'O backup contém um identificador de tema que pertence a outro perfil.',
        );
      }
      if (existing.isNotEmpty) {
        final updateColumns = columns
            .where((column) => column != 'id' && row.containsKey(column))
            .toList();
        await database.customStatement(
          'UPDATE "$table" SET ${updateColumns.map((column) => '"$column" = ?').join(', ')} '
          'WHERE id = ? AND user_id = ?',
          [
            for (final column in updateColumns) row[column],
            row['id'],
            localUserId,
          ],
        );
        return row['id'] as String;
      }

      final sameName = await database
          .customSelect(
            'SELECT id FROM "$table" WHERE user_id = ? AND name = ?',
            variables: [
              Variable.withString(localUserId),
              Variable.withString(row['name'] as String),
            ],
          )
          .get();
      if (sameName.isNotEmpty) {
        final existingId = sameName.single.data['id'] as String;
        final updateColumns = columns
            .where(
              (column) =>
                  column != 'id' &&
                  column != 'user_id' &&
                  column != 'system_default' &&
                  row.containsKey(column),
            )
            .toList();
        await database.customStatement(
          'UPDATE "$table" SET ${updateColumns.map((column) => '"$column" = ?').join(', ')} '
          'WHERE id = ? AND user_id = ?',
          [
            for (final column in updateColumns) row[column],
            existingId,
            localUserId,
          ],
        );
        return existingId;
      }
    }

    final insertColumns = columns
        .where(row.containsKey)
        .toList(growable: false);
    await database.customStatement(
      'INSERT INTO "$table" (${insertColumns.map((column) => '"$column"').join(', ')}) '
      'VALUES (${List<String>.filled(insertColumns.length, '?').join(', ')})',
      [for (final column in insertColumns) row[column]],
    );
    return row['id'] as String;
  }

  Future<void> _restoreThemeSelection(
    Map<String, dynamic> selection,
    String userId,
    Map<String, Map<String, String>> themeIdMappings,
  ) async {
    final colorId =
        themeIdMappings['color_theme']![selection['color_theme_id']] ??
        selection['color_theme_id'];
    final typographyId =
        themeIdMappings['typography_theme']![selection['typography_theme_id']] ??
        selection['typography_theme_id'];
    final configRows = await database
        .customSelect(
          'SELECT id FROM config WHERE user_id = ?',
          variables: [Variable.withString(userId)],
        )
        .get();
    if (configRows.isEmpty) return;

    if (colorId is String) {
      final owned = await database
          .customSelect(
            'SELECT id FROM color_theme WHERE id = ? AND user_id = ?',
            variables: [
              Variable.withString(colorId),
              Variable.withString(userId),
            ],
          )
          .get();
      if (owned.isNotEmpty) {
        await database.customStatement(
          'UPDATE config SET color_theme_id = ? WHERE user_id = ?',
          [colorId, userId],
        );
      }
    }
    if (typographyId is String) {
      final owned = await database
          .customSelect(
            'SELECT id FROM typography_theme WHERE id = ? AND user_id = ?',
            variables: [
              Variable.withString(typographyId),
              Variable.withString(userId),
            ],
          )
          .get();
      if (owned.isNotEmpty) {
        await database.customStatement(
          'UPDATE config SET typography_theme_id = ? WHERE user_id = ?',
          [typographyId, userId],
        );
      }
    }
  }

  Future<void> _removeUnusedCustomThemes(
    String table,
    String userId,
    Set<String> importedIds,
  ) async {
    final selectionColumn = table == 'color_theme'
        ? 'color_theme_id'
        : 'typography_theme_id';
    final selected = await database
        .customSelect(
          'SELECT $selectionColumn FROM config WHERE user_id = ?',
          variables: [Variable.withString(userId)],
        )
        .get();
    final retainedIds = <String>{
      ...importedIds,
      for (final row in selected)
        if (row.data[selectionColumn] is String)
          row.data[selectionColumn] as String,
    };
    final themes = await database
        .customSelect(
          'SELECT id FROM "$table" WHERE user_id = ? AND system_default = 0',
          variables: [Variable.withString(userId)],
        )
        .get();
    for (final theme in themes) {
      final id = theme.data['id'] as String;
      if (retainedIds.contains(id)) continue;
      await database.customStatement(
        'DELETE FROM "$table" WHERE id = ? AND user_id = ? AND system_default = 0',
        [id, userId],
      );
    }
  }
}

SnapshotDiff compareSnapshots(
  Map<String, dynamic> localData,
  Map<String, dynamic> remoteData,
) {
  final changes = <SnapshotChange>[];
  final summaries = <String, List<int>>{
    for (final category in snapshotCategories) category: [0, 0, 0],
  };
  for (final spec in _snapshotTables) {
    final localRows = _rows(localData, spec.category, spec.name);
    final remoteRows = _rows(remoteData, spec.category, spec.name);
    final localById = {for (final row in localRows) row['id'] as String: row};
    final remoteById = {for (final row in remoteRows) row['id'] as String: row};
    for (final entry in localById.entries) {
      final remote = remoteById[entry.key];
      if (remote == null) {
        summaries[spec.category]![0]++;
        final fields = _previewFields(entry.value);
        changes.add(
          SnapshotChange(
            category: spec.category,
            table: spec.name,
            rowId: entry.key,
            kind: SnapshotChangeKind.added,
            side: SnapshotSide.local,
            fields: fields,
            localValues: {
              for (final field in fields) field: entry.value[field],
            },
          ),
        );
      } else {
        final fields = _changedFields(entry.value, remote);
        if (fields.isNotEmpty) {
          summaries[spec.category]![2]++;
          changes.add(
            SnapshotChange(
              category: spec.category,
              table: spec.name,
              rowId: entry.key,
              kind: SnapshotChangeKind.changed,
              fields: fields,
              localValues: {
                for (final field in fields) field: entry.value[field],
              },
              remoteValues: {for (final field in fields) field: remote[field]},
            ),
          );
        }
      }
    }
    for (final entry in remoteById.entries) {
      if (!localById.containsKey(entry.key)) {
        summaries[spec.category]![1]++;
        final fields = _previewFields(entry.value);
        changes.add(
          SnapshotChange(
            category: spec.category,
            table: spec.name,
            rowId: entry.key,
            kind: SnapshotChangeKind.added,
            side: SnapshotSide.remote,
            fields: fields,
            remoteValues: {
              for (final field in fields) field: entry.value[field],
            },
          ),
        );
      }
    }
  }

  final localSelection = (localData['custom_themes'] as Map?)?['selection'];
  final remoteSelection = (remoteData['custom_themes'] as Map?)?['selection'];
  if (!_sameJson(localSelection, remoteSelection)) {
    summaries['custom_themes']![2]++;
    changes.add(
      const SnapshotChange(
        category: 'custom_themes',
        table: 'theme_selection',
        rowId: 'active-themes',
        kind: SnapshotChangeKind.changed,
        fields: ['tema de cores ativo', 'tipografia ativa'],
      ),
    );
  }
  return SnapshotDiff([
    for (final entry in summaries.entries)
      if (entry.value.any((count) => count > 0))
        SnapshotCategoryDiff(
          category: entry.key,
          localOnly: entry.value[0],
          remoteOnly: entry.value[1],
          changed: entry.value[2],
        ),
  ], changes);
}

@visibleForTesting
Map<String, dynamic> mergeSnapshotData(
  Map<String, dynamic> localData,
  Map<String, dynamic> remoteData,
) {
  const dependentParents = <String, (String, String)>{
    'note_version': ('note', 'note_id'),
    'note_node': ('note', 'note_id'),
    'review_item_log': ('review_item_state', 'review_item_state_id'),
    'fsrs_review_log': ('fsrs_state', 'fsrs_state_id'),
  };
  final suppressedRemoteIds = <String, Set<String>>{};
  for (final parent in const [
    'note',
    'review_item_state',
    'fsrs_state',
  ]) {
    final spec = _snapshotTables.firstWhere((item) => item.name == parent);
    final localRows = _rows(localData, spec.category, parent);
    final localIds = {for (final row in localRows) row['id']};
    final localIdentities = {
      for (final row in localRows)
        ..._logicalIdentities(parent, row),
    };
    final remoteRows = _rows(remoteData, spec.category, parent);
    suppressedRemoteIds[parent] = {
      for (final row in remoteRows)
        if (!localIds.contains(row['id']) &&
            _logicalIdentities(
              parent,
              row,
            ).any(localIdentities.contains))
          row['id'] as String,
    };
  }

  final merged = <String, dynamic>{};
  for (final category in snapshotCategories) {
    final localCategory = Map<String, dynamic>.from(localData[category] as Map);
    final remoteCategory = Map<String, dynamic>.from(
      remoteData[category] as Map,
    );
    final mergedCategory = <String, dynamic>{};
    for (final spec in _snapshotTables.where(
      (item) => item.category == category,
    )) {
      final localRows = _rows(localData, category, spec.name);
      final parent = dependentParents[spec.name];
      final remoteRows = _rows(remoteData, category, spec.name)
          .where(
            (row) =>
                parent == null ||
                !suppressedRemoteIds[parent.$1]!.contains(row[parent.$2]),
          )
          .toList();
      final localIds = {for (final row in localRows) row['id'] as String};
      final identities = <String>{};
      for (final row in localRows) {
        for (final identity in _logicalIdentities(spec.name, row)) {
          identities.add(identity);
        }
      }
      final rows = <Map<String, dynamic>>[
        ...localRows,
        for (final row in remoteRows)
          if (!localIds.contains(row['id']) &&
              _logicalIdentities(
                spec.name,
                row,
              ).every((identity) => !identities.contains(identity)))
            row,
      ]..sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
      mergedCategory[spec.name] = rows;
    }
    if (category == 'custom_themes') {
      mergedCategory['selection'] =
          localCategory['selection'] ?? remoteCategory['selection'];
    }
    merged[category] = mergedCategory;
  }
  return merged;
}

List<String> _logicalIdentities(String table, Map<String, dynamic> row) {
  String key(Iterable<String> fields) =>
      fields.map((field) => '${row[field]}').join('\u0000');
  switch (table) {
    case 'color_theme':
    case 'typography_theme':
      return [
        key(['user_id', 'name']),
      ];
    case 'graph_edge':
      return [
        key(['graph_id', 'source_node_id', 'target_node_id']),
      ];
    case 'note':
      return row['soft_deleted'] == 0 || row['soft_deleted'] == false
          ? [
              key(['user_id', 'title']),
            ]
          : const [];
    case 'study_session_use_knowledge_graph':
      return [
        key(['graph_id', 'study_session_id']),
      ];
    case 'session_node':
      return [
        key(['node_id', 'study_session_id']),
      ];
    case 'flashcard_belongs_group':
      return [
        key(['flashcard_id', 'flashcard_group_id']),
      ];
    case 'review_item_state':
      return [
        key(['item_type', 'item_id']),
      ];
    case 'fsrs_state':
      return [
        key(['node_id']),
      ];
    case 'study_session_question':
      return [
        if (row['multiple_choice_id'] != null)
          key(['study_session_id', 'multiple_choice_id']),
        if (row['open_ended_id'] != null)
          key(['study_session_id', 'open_ended_id']),
        key(['study_session_id', 'display_order']),
      ];
    default:
      return const [];
  }
}

List<Map<String, dynamic>> _rows(
  Map<String, dynamic> data,
  String category,
  String table,
) {
  final categoryData = data[category];
  if (categoryData is! Map) return const [];
  final rows = categoryData[table];
  if (rows is! List) return const [];
  return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
}

List<String> _changedFields(
  Map<String, dynamic> local,
  Map<String, dynamic> remote,
) {
  final keys = {...local.keys, ...remote.keys}.toList()..sort();
  return [
    for (final key in keys)
      if (!_sameJson(local[key], remote[key])) key,
  ];
}

List<String> _previewFields(Map<String, dynamic> row) {
  const preferred = [
    'title',
    'name',
    'question',
    'front',
    'prompt',
    'text',
    'content',
  ];
  return preferred.where((field) => row[field] != null).take(2).toList();
}

bool _sameJson(Object? left, Object? right) =>
    jsonEncode(_canonicalize(left)) == jsonEncode(_canonicalize(right));

Object? _canonicalize(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((key) => '$key').toList()..sort();
    return {for (final key in keys) key: _canonicalize(value[key])};
  }
  if (value is List) {
    return value.map(_canonicalize).toList(growable: false);
  }
  return value;
}

Map<String, dynamic> _normalizeRow(
  Map<String, dynamic> source,
  String localUserId,
) {
  final row = <String, dynamic>{};
  for (final entry in source.entries) {
    final value = entry.value;
    if (value is Uint8List || value is List<int>) {
      throw FormatException(
        'O backup não suporta conteúdo binário na coluna "${entry.key}".',
      );
    }
    if (entry.key == 'user_id' && value == localUserId) {
      row[entry.key] = _snapshotOwnerMarker;
    } else {
      row[entry.key] = value;
    }
  }
  return row;
}

String _hashJson(Object? value) =>
    'sha256:${sha256.convert(utf8.encode(jsonEncode(value)))}';

String snapshotCategoryLabel(String category) =>
    _categoryLabels[category] ?? category;
