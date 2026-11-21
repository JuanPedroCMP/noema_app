import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/router/route_paths.dart';

enum GlobalSearchKind { graph, node, task, flashcard, note, session }

extension GlobalSearchKindPresentation on GlobalSearchKind {
  String get label => switch (this) {
    GlobalSearchKind.graph => 'Grafo',
    GlobalSearchKind.node => 'Tópico',
    GlobalSearchKind.task => 'Tarefa',
    GlobalSearchKind.flashcard => 'Flashcard',
    GlobalSearchKind.note => 'Nota',
    GlobalSearchKind.session => 'Sessão',
  };

  IconData get icon => switch (this) {
    GlobalSearchKind.graph => Icons.account_tree_outlined,
    GlobalSearchKind.node => Icons.hub_outlined,
    GlobalSearchKind.task => Icons.task_alt_outlined,
    GlobalSearchKind.flashcard => Icons.style_outlined,
    GlobalSearchKind.note => Icons.notes_outlined,
    GlobalSearchKind.session => Icons.playlist_add_check_circle_outlined,
  };
}

class GlobalSearchResult {
  const GlobalSearchResult({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.rank,
  });

  final GlobalSearchKind kind;
  final String title;
  final String subtitle;
  final String path;
  final int rank;
}

class GlobalSearchService {
  const GlobalSearchService(this._database);

  final AppDatabase _database;

  Future<List<GlobalSearchResult>> search({
    required String userId,
    required String query,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.length < 2) return const [];
    final pattern = '%$normalizedQuery%';

    final batches = await Future.wait<List<GlobalSearchResult>>([
      _searchGraphs(userId, normalizedQuery, pattern),
      _searchNodes(userId, normalizedQuery, pattern),
      _searchOpenEndedTasks(userId, normalizedQuery, pattern),
      _searchMultipleChoiceTasks(userId, normalizedQuery, pattern),
      _searchFlashcards(userId, normalizedQuery, pattern),
      _searchNotes(userId, normalizedQuery, pattern),
      _searchSessions(userId, normalizedQuery, pattern),
    ]);

    final results = batches.expand((batch) => batch).toList()
      ..sort((left, right) {
        final rank = left.rank.compareTo(right.rank);
        if (rank != 0) return rank;
        final kind = left.kind.index.compareTo(right.kind.index);
        if (kind != 0) return kind;
        return left.title.toLowerCase().compareTo(right.title.toLowerCase());
      });
    return List.unmodifiable(results.take(12));
  }

  Future<List<GlobalSearchResult>> _searchGraphs(
    String userId,
    String query,
    String pattern,
  ) async {
    final rows =
        await (_database.select(_database.knowledgeGraph)
              ..where(
                (graph) =>
                    graph.userId.equals(userId) &
                    graph.softDeleted.equals(false) &
                    (graph.title.like(pattern) |
                        graph.description.like(pattern)),
              )
              ..orderBy([(graph) => OrderingTerm.asc(graph.title)])
              ..limit(4))
            .get();
    return [
      for (final graph in rows)
        GlobalSearchResult(
          kind: GlobalSearchKind.graph,
          title: graph.title,
          subtitle: graph.isArchived ? 'Grafo · Arquivado' : 'Grafo',
          path: RoutePaths.graph(graph.id),
          rank: _rank(graph.title, query),
        ),
    ];
  }

  Future<List<GlobalSearchResult>> _searchNodes(
    String userId,
    String query,
    String pattern,
  ) async {
    final graph = _database.knowledgeGraph;
    final node = _database.graphNode;
    final rows =
        await (_database.select(node).join([
                innerJoin(graph, graph.id.equalsExp(node.graphId)),
              ])
              ..where(
                graph.userId.equals(userId) &
                    graph.softDeleted.equals(false) &
                    node.softDeleted.equals(false) &
                    (node.title.like(pattern) | node.description.like(pattern)),
              )
              ..orderBy([OrderingTerm.asc(node.title)])
              ..limit(4))
            .get();
    return [
      for (final row in rows)
        () {
          final nodeData = row.readTable(node);
          final graphData = row.readTable(graph);
          return GlobalSearchResult(
            kind: GlobalSearchKind.node,
            title: nodeData.title,
            subtitle: '${_nodeTypeLabel(nodeData.type)} · ${graphData.title}',
            path: RoutePaths.graph(graphData.id),
            rank: _rank(nodeData.title, query),
          );
        }(),
    ];
  }

  Future<List<GlobalSearchResult>> _searchOpenEndedTasks(
    String userId,
    String query,
    String pattern,
  ) async {
    final graph = _database.knowledgeGraph;
    final node = _database.graphNode;
    final task = _database.openEnded;
    final rows =
        await (_database.select(task).join([
                innerJoin(node, node.id.equalsExp(task.nodeId)),
                innerJoin(graph, graph.id.equalsExp(node.graphId)),
              ])
              ..where(
                graph.userId.equals(userId) &
                    graph.softDeleted.equals(false) &
                    node.softDeleted.equals(false) &
                    task.softDeleted.equals(false) &
                    (task.title.like(pattern) | task.statement.like(pattern)),
              )
              ..orderBy([OrderingTerm.asc(task.title)])
              ..limit(4))
            .get();
    return [
      for (final row in rows)
        () {
          final taskData = row.readTable(task);
          final nodeData = row.readTable(node);
          final graphData = row.readTable(graph);
          return GlobalSearchResult(
            kind: GlobalSearchKind.task,
            title: taskData.title,
            subtitle: 'Questão aberta · ${nodeData.title} · ${graphData.title}',
            path: RoutePaths.openEndedAnswer(
              graphData.id,
              nodeData.id,
              taskData.id,
            ),
            rank: _rank(taskData.title, query),
          );
        }(),
    ];
  }

  Future<List<GlobalSearchResult>> _searchMultipleChoiceTasks(
    String userId,
    String query,
    String pattern,
  ) async {
    final graph = _database.knowledgeGraph;
    final node = _database.graphNode;
    final task = _database.multipleChoice;
    final rows =
        await (_database.select(task).join([
                innerJoin(node, node.id.equalsExp(task.nodeId)),
                innerJoin(graph, graph.id.equalsExp(node.graphId)),
              ])
              ..where(
                graph.userId.equals(userId) &
                    graph.softDeleted.equals(false) &
                    node.softDeleted.equals(false) &
                    task.softDeleted.equals(false) &
                    (task.title.like(pattern) | task.statement.like(pattern)),
              )
              ..orderBy([OrderingTerm.asc(task.title)])
              ..limit(4))
            .get();
    return [
      for (final row in rows)
        () {
          final taskData = row.readTable(task);
          final nodeData = row.readTable(node);
          final graphData = row.readTable(graph);
          return GlobalSearchResult(
            kind: GlobalSearchKind.task,
            title: taskData.title,
            subtitle:
                'Múltipla escolha · ${nodeData.title} · ${graphData.title}',
            path: RoutePaths.multipleChoiceAnswer(
              graphData.id,
              nodeData.id,
              taskData.id,
            ),
            rank: _rank(taskData.title, query),
          );
        }(),
    ];
  }

  Future<List<GlobalSearchResult>> _searchFlashcards(
    String userId,
    String query,
    String pattern,
  ) async {
    final graph = _database.knowledgeGraph;
    final node = _database.graphNode;
    final flashcard = _database.flashcard;
    final rows =
        await (_database.select(flashcard).join([
                innerJoin(node, node.id.equalsExp(flashcard.nodeId)),
                innerJoin(graph, graph.id.equalsExp(node.graphId)),
              ])
              ..where(
                graph.userId.equals(userId) &
                    graph.softDeleted.equals(false) &
                    node.softDeleted.equals(false) &
                    flashcard.softDeleted.equals(false) &
                    (flashcard.title.like(pattern) |
                        flashcard.statement.like(pattern)),
              )
              ..orderBy([OrderingTerm.asc(flashcard.title)])
              ..limit(4))
            .get();
    return [
      for (final row in rows)
        () {
          final card = row.readTable(flashcard);
          final nodeData = row.readTable(node);
          final graphData = row.readTable(graph);
          return GlobalSearchResult(
            kind: GlobalSearchKind.flashcard,
            title: card.title,
            subtitle: 'Flashcard · ${nodeData.title} · ${graphData.title}',
            path: RoutePaths.flashcardsForNode(graphData.id, nodeData.id),
            rank: _rank(card.title, query),
          );
        }(),
    ];
  }

  Future<List<GlobalSearchResult>> _searchNotes(
    String userId,
    String query,
    String pattern,
  ) async {
    final rows =
        await (_database.select(_database.note)
              ..where(
                (note) =>
                    note.userId.equals(userId) &
                    note.softDeleted.equals(false) &
                    note.title.like(pattern),
              )
              ..orderBy([(note) => OrderingTerm.asc(note.title)])
              ..limit(4))
            .get();
    return [
      for (final note in rows)
        GlobalSearchResult(
          kind: GlobalSearchKind.note,
          title: note.title,
          subtitle: 'Nota',
          path: RoutePaths.notes,
          rank: _rank(note.title, query),
        ),
    ];
  }

  Future<List<GlobalSearchResult>> _searchSessions(
    String userId,
    String query,
    String pattern,
  ) async {
    final rows =
        await (_database.select(_database.studySession)
              ..where(
                (session) =>
                    session.userId.equals(userId) &
                    session.softDeleted.equals(false) &
                    (session.title.like(pattern) |
                        session.description.like(pattern)),
              )
              ..orderBy([(session) => OrderingTerm.desc(session.updatedAt)])
              ..limit(4))
            .get();
    return [
      for (final session in rows)
        GlobalSearchResult(
          kind: GlobalSearchKind.session,
          title: session.title,
          subtitle: 'Sessão de estudo',
          path: RoutePaths.studySession(session.id),
          rank: _rank(session.title, query),
        ),
    ];
  }

  int _rank(String title, String query) {
    final normalizedTitle = title.toLowerCase();
    if (normalizedTitle == query) return 0;
    if (normalizedTitle.startsWith(query)) return 1;
    return 2;
  }

  String _nodeTypeLabel(String type) => switch (type) {
    'AREA' => 'Área',
    'TOPIC' => 'Tópico',
    'CONCEPT' => 'Conceito',
    'SUBCONCEPT' => 'Subconceito',
    _ => 'Tópico',
  };
}
