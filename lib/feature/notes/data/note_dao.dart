import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

class NoteWithNodes {
  const NoteWithNodes({required this.note, required this.nodes});

  final NoteData note;
  final List<GraphNodeData> nodes;
}

class NoteDao {
  NoteDao(this._database);

  final AppDatabase _database;

  Stream<List<NoteData>> watchNotes({required String userId}) {
    return (_database.select(_database.note)
          ..where((note) => note.userId.equals(userId))
          ..orderBy([
            (note) => OrderingTerm.desc(note.updatedAt),
            (note) => OrderingTerm.asc(note.title),
          ]))
        .watch();
  }

  Future<NoteWithNodes?> getNote({
    required String noteId,
    required String userId,
  }) async {
    final note =
        await (_database.select(_database.note)..where(
              (row) =>
                  row.id.equals(noteId) &
                  row.userId.equals(userId) &
                  row.softDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (note == null) return null;

    final nodeQuery =
        _database.select(_database.graphNode).join([
            innerJoin(
              _database.noteNode,
              _database.noteNode.nodeId.equalsExp(_database.graphNode.id),
            ),
          ])
          ..where(_database.noteNode.noteId.equals(noteId))
          ..orderBy([OrderingTerm.asc(_database.graphNode.title)]);
    final nodeRows = await nodeQuery.get();
    return NoteWithNodes(
      note: note,
      nodes: nodeRows.map((row) => row.readTable(_database.graphNode)).toList(),
    );
  }

  Future<List<GraphNodeData>> getNodesForUser({required String userId}) async {
    final query =
        _database.select(_database.graphNode).join([
            innerJoin(
              _database.knowledgeGraph,
              _database.knowledgeGraph.id.equalsExp(
                _database.graphNode.graphId,
              ),
            ),
          ])
          ..where(
            _database.knowledgeGraph.userId.equals(userId) &
                _database.knowledgeGraph.softDeleted.equals(false) &
                _database.graphNode.softDeleted.equals(false),
          )
          ..orderBy([
            OrderingTerm.asc(_database.knowledgeGraph.title),
            OrderingTerm.asc(_database.graphNode.title),
          ]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(_database.graphNode)).toList();
  }

  Future<NoteData> create({
    required String userId,
    required String title,
    required String contentQuillJson,
    List<String> nodeIds = const [],
  }) async {
    _validateContent(contentQuillJson);
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final noteId = const Uuid().v4();
    await _database.transaction(() async {
      await _database
          .into(_database.note)
          .insert(
            NoteCompanion.insert(
              id: noteId,
              userId: userId,
              title: _validateTitle(title),
              contentQuillJson: contentQuillJson,
              currentVersion: 0,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await _replaceNodeLinks(noteId: noteId, userId: userId, nodeIds: nodeIds);
    });
    return (await getNote(noteId: noteId, userId: userId))!.note;
  }

  Future<NoteData> save({
    required String noteId,
    required String userId,
    required String title,
    required String contentQuillJson,
    required List<String> nodeIds,
    String author = 'USER',
    String? changeDescription,
    bool createVersion = false,
  }) async {
    final normalizedTitle = _validateTitle(title);
    _validateContent(contentQuillJson);
    if (!{'USER', 'AI'}.contains(author)) {
      throw ArgumentError.value(author, 'author');
    }

    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    await _database.transaction(() async {
      final current =
          await (_database.select(_database.note)..where(
                (note) =>
                    note.id.equals(noteId) &
                    note.userId.equals(userId) &
                    note.softDeleted.equals(false),
              ))
              .getSingleOrNull();
      if (current == null) {
        throw StateError('A nota não existe ou não pertence a este usuário.');
      }

      final currentLinks = await (_database.select(
        _database.noteNode,
      )..where((link) => link.noteId.equals(noteId))).get();
      final oldNodeIds = currentLinks.map((link) => link.nodeId).toSet();
      final newNodeIds = nodeIds.toSet();
      final contentChanged = current.contentQuillJson != contentQuillJson;
      final titleChanged = current.title != normalizedTitle;
      final linksChanged = !setEquals(oldNodeIds, newNodeIds);
      if (!contentChanged && !titleChanged && !linksChanged && !createVersion) {
        return;
      }

      final nextVersion = current.currentVersion + (createVersion ? 1 : 0);
      await (_database.update(_database.note)..where(
            (note) => note.id.equals(noteId) & note.userId.equals(userId),
          ))
          .write(
            NoteCompanion(
              title: Value(normalizedTitle),
              contentQuillJson: Value(contentQuillJson),
              currentVersion: Value(nextVersion),
              updatedAt: Value(now),
            ),
          );
      if (createVersion) {
        await _database
            .into(_database.noteVersion)
            .insert(
              NoteVersionCompanion.insert(
                id: const Uuid().v4(),
                noteId: noteId,
                versionNumber: nextVersion,
                contentQuillJson: contentQuillJson,
                changeDescription: Value(
                  changeDescription?.trim().isNotEmpty == true
                      ? changeDescription!.trim()
                      : 'Versão criada',
                ),
                author: author,
                createdAt: Value(now),
              ),
            );
      }
      if (linksChanged) {
        await _replaceNodeLinks(
          noteId: noteId,
          userId: userId,
          nodeIds: nodeIds,
        );
      }
    });
    final updated = await getNote(noteId: noteId, userId: userId);
    if (updated == null) {
      throw StateError('A nota não pôde ser carregada após salvar.');
    }
    return updated.note;
  }

  Future<List<NoteVersionData>> getVersions({
    required String noteId,
    required String userId,
  }) async {
    final exists =
        await (_database.select(_database.note)..where(
              (note) =>
                  note.id.equals(noteId) &
                  note.userId.equals(userId) &
                  note.softDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (exists == null) {
      throw StateError('A nota não existe ou não pertence a este usuário.');
    }
    return (_database.select(_database.noteVersion)
          ..where((version) => version.noteId.equals(noteId))
          ..orderBy([(version) => OrderingTerm.desc(version.versionNumber)]))
        .get();
  }

  Future<NoteData> restoreVersion({
    required String noteId,
    required String userId,
    required int versionNumber,
  }) async {
    final version =
        await (_database.select(_database.noteVersion).join([
              innerJoin(
                _database.note,
                _database.note.id.equalsExp(_database.noteVersion.noteId),
              ),
            ])..where(
              _database.note.id.equals(noteId) &
                  _database.note.userId.equals(userId) &
                  _database.note.softDeleted.equals(false) &
                  _database.noteVersion.versionNumber.equals(versionNumber),
            ))
            .getSingleOrNull();
    if (version == null) {
      throw StateError('A versão solicitada não está disponível.');
    }
    final versionData = version.readTable(_database.noteVersion);
    final note = version.readTable(_database.note);
    return save(
      noteId: noteId,
      userId: userId,
      title: note.title,
      contentQuillJson: versionData.contentQuillJson,
      nodeIds:
          (await (_database.select(
                _database.noteNode,
              )..where((link) => link.noteId.equals(noteId))).get())
              .map((link) => link.nodeId)
              .toList(),
      changeDescription: 'Restaurada versão $versionNumber',
      createVersion: true,
    );
  }

  Future<bool> delete({required String noteId, required String userId}) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final updated =
        await (_database.update(_database.note)..where(
              (note) =>
                  note.id.equals(noteId) &
                  note.userId.equals(userId) &
                  note.softDeleted.equals(false),
            ))
            .write(
              NoteCompanion(
                softDeleted: const Value(true),
                softDeletedAt: Value(now),
                updatedAt: Value(now),
              ),
            );
    return updated == 1;
  }

  Future<bool> restore({required String noteId, required String userId}) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final updated =
        await (_database.update(_database.note)..where(
              (note) =>
                  note.id.equals(noteId) &
                  note.userId.equals(userId) &
                  note.softDeleted.equals(true),
            ))
            .write(
              NoteCompanion(
                softDeleted: const Value(false),
                softDeletedAt: const Value(null),
                updatedAt: Value(now),
              ),
            );
    return updated == 1;
  }

  Future<bool> deletePermanently({
    required String noteId,
    required String userId,
  }) async {
    final deleted =
        await (_database.delete(_database.note)..where(
              (note) =>
                  note.id.equals(noteId) &
                  note.userId.equals(userId) &
                  note.softDeleted.equals(true),
            ))
            .go();
    return deleted == 1;
  }

  Future<void> _replaceNodeLinks({
    required String noteId,
    required String userId,
    required List<String> nodeIds,
  }) async {
    final uniqueNodeIds = nodeIds.toSet();
    if (uniqueNodeIds.isNotEmpty) {
      final placeholders = List.filled(uniqueNodeIds.length, '?').join(', ');
      final rows = await _database
          .customSelect(
            '''
        SELECT n.id
        FROM graph_node n
        JOIN knowledge_graph g ON g.id = n.graph_id
        WHERE n.id IN ($placeholders)
          AND n.soft_deleted = 0
          AND g.soft_deleted = 0
          AND g.user_id = ?
        ''',
            variables: [
              for (final nodeId in uniqueNodeIds) Variable.withString(nodeId),
              Variable.withString(userId),
            ],
          )
          .get();
      if (rows.length != uniqueNodeIds.length) {
        throw StateError(
          'Uma ou mais relações apontam para nós indisponíveis.',
        );
      }
    }

    await (_database.delete(
      _database.noteNode,
    )..where((link) => link.noteId.equals(noteId))).go();
    for (final nodeId in uniqueNodeIds) {
      await _database
          .into(_database.noteNode)
          .insert(
            NoteNodeCompanion.insert(
              id: const Uuid().v4(),
              noteId: noteId,
              nodeId: nodeId,
            ),
          );
    }
  }

  String _validateTitle(String title) {
    final normalized = title.trim();
    if (normalized.isEmpty) throw ArgumentError.value(title, 'title');
    if (normalized.length > 160) {
      throw ArgumentError.value(title, 'title', 'máximo de 160 caracteres');
    }
    return normalized;
  }

  void _validateContent(String content) {
    final decoded = jsonDecode(content);
    if (decoded is! List || decoded.isEmpty) {
      throw const FormatException('O documento da nota não é um Delta válido.');
    }
  }
}

bool setEquals<T>(Set<T> first, Set<T> second) =>
    first.length == second.length && first.containsAll(second);
