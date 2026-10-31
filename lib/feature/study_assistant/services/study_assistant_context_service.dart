import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';

class StudyAssistantContextService {
  StudyAssistantContextService(this._ref);

  final Ref _ref;

  Future<Map<String, dynamic>> build({
    required String currentPath,
  }) async {
    final user = await _ref.read(userProvider.future);
    final settings = await _ref.read(studyAssistantSettingsProvider.future);
    final db = _ref.read(appDatabaseProvider);
    final graphCountQuery = db.selectOnly(db.knowledgeGraph)
      ..addColumns([db.knowledgeGraph.id.count()])
      ..where(
        db.knowledgeGraph.userId.equals(user.id) &
            db.knowledgeGraph.softDeleted.equals(false),
      );
    final graphCount = await graphCountQuery
        .map((row) => row.read(db.knowledgeGraph.id.count()) ?? 0)
        .getSingle();
    final graphs =
        await (db.select(db.knowledgeGraph)
              ..where((graph) => graph.userId.equals(user.id))
              ..where((graph) => graph.softDeleted.equals(false))
              ..orderBy([(graph) => OrderingTerm.asc(graph.title)])
              ..limit(5))
            .get();

    final topicsByGraph = <String, List<Map<String, String>>>{};
    if (graphs.isNotEmpty) {
      final nodes =
          await (db.select(db.graphNode)
                ..where((node) => node.graphId.isIn(graphs.map((g) => g.id)))
                ..where((node) => node.softDeleted.equals(false))
                ..orderBy([(node) => OrderingTerm.asc(node.title)])
                ..limit(10))
              .get();
      for (final node in nodes) {
        final topics = topicsByGraph.putIfAbsent(node.graphId, () => []);
        if (topics.length < 2) {
          topics.add({
            'id': node.id,
            'title': _shorten(node.title, 48),
          });
        }
      }
    }

    return {
      'learningGoal': _shorten(settings.learningGoal, 160),
      'currentPage': _shorten(currentPath, 80),
      'graphCount': graphCount,
      'graphs': [
        for (final graph in graphs)
          {
            'id': graph.id,
            'title': _shorten(graph.title, 60),
            if (graph.description?.trim().isNotEmpty == true)
              'summary': _shorten(graph.description!.trim(), 90),
            'topics': topicsByGraph[graph.id] ?? const <String>[],
          },
      ],
      'language': 'pt-BR',
    };
  }

  String _shorten(String value, int maxLength) {
    final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized.length <= maxLength
        ? normalized
        : '${normalized.substring(0, maxLength - 1)}…';
  }
}

final studyAssistantContextServiceProvider =
    Provider<StudyAssistantContextService>(
      StudyAssistantContextService.new,
    );
