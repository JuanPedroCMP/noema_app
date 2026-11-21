import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/ai/services/ai_background_work_scheduler.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/service/ai_graph_patch.dart';
import 'package:noema/feature/graph/service/compact_graph_context.dart';
import 'package:uuid/uuid.dart';

class AiGraphEditDraft {
  const AiGraphEditDraft({required this.snapshot, required this.patch});

  final CompactGraphSnapshot snapshot;
  final AiGraphPatch patch;
}

class AiGraphEditService {
  AiGraphEditService(this._ref);

  final WidgetRef _ref;

  static String buildPatchPrompt({
    required String instruction,
    required Map<String, Object?> graph,
  }) =>
      '''
Altere o grafo de conhecimento exclusivamente conforme a solicitação.
Retorne somente um objeto JSON de alterações, nunca o grafo completo, sem markdown.
Use apenas IDs numéricos existentes para alterar/excluir itens. Para cada nó novo,
use um identificador temporário exclusivo no formato "new_1", "new_2" etc.
Não invente nem retorne IDs locais do aplicativo.

Formato exato:
{"delete_nodes":[],"rename_nodes":[{"id":1,"title":"novo título"}],
"add_nodes":[{"id":"new_1","title":"título","type":"CONCEPT"}],
"delete_edges":[],"add_edges":[{"source_node":1,"target_node":"new_1",
"type":"SUBTOPIC","weight":1.0}]}

Use IDs sequenciais do contexto. Cada relação adicionada deve apontar para um ID
existente não excluído ou para um ID new_N declarado em add_nodes. Para substituir
uma relação, exclua seu ID e adicione a relação desejada. Inclua somente operações
necessárias. Não gere descrições: elas serão regeneradas pelo aplicativo.

Solicitação:
${instruction.trim()}

Grafo atual compacto (JSON):
${jsonEncode(graph)}
''';

  Future<AiGraphEditDraft> generatePatch({
    required String graphId,
    required String instruction,
  }) async {
    if (instruction.trim().isEmpty) {
      throw ArgumentError.value(
        instruction,
        'instruction',
        'must not be empty',
      );
    }
    final database = _ref.read(appDatabaseProvider);
    final nodes = await GraphNodeDao(
      database,
    ).getGraphNodesByGraph(graphId: graphId);
    final edges = await GraphEdgeDao(
      database,
    ).getGraphEdgesByGraph(graphId: graphId);
    final snapshot = compactGraphSnapshot(nodes: nodes, edges: edges);
    final ai = _ref.read(aiContentGenerationServiceProvider);
    final agentId = await ai.resolveAgentId(AiAgentTask.manipulateGraph);
    final patch = await ai.generateWithRetry<AiGraphPatch>(
      task: AiAgentTask.manipulateGraph,
      agentId: agentId,
      prompt: buildPatchPrompt(
        instruction: instruction,
        graph: snapshot.toJson(),
      ),
      parse: (json) {
        final result = AiGraphPatch.fromJson(json);
        result.validate(
          existingNodeIds: snapshot.nodesByCompactId.keys.toSet(),
          existingEdgeIds: snapshot.edgesByCompactId.keys.toSet(),
        );
        return result;
      },
    );
    return AiGraphEditDraft(snapshot: snapshot, patch: patch);
  }

  Future<void> applyPatch({
    required String graphId,
    required AiGraphEditDraft draft,
  }) async {
    final database = _ref.read(appDatabaseProvider);
    await AiGraphPatchApplier(database).apply(graphId: graphId, draft: draft);
    final hasDescriptionTasks =
        draft.patch.renamedNodes.isNotEmpty ||
        draft.patch.addedNodes.isNotEmpty;
    if (hasDescriptionTasks) {
      await _ref
          .read(aiTaskNotificationServiceProvider)
          .initialize(requestPermission: true);
      await scheduleAiBackgroundQueue(
        taskId: '$graphId-${DateTime.now().microsecondsSinceEpoch}',
      );
    }
    _ref.read(aiBackgroundTaskRunnerProvider).requestPump();
  }
}

class AiGraphPatchApplier {
  AiGraphPatchApplier(this.database);

  final AppDatabase database;

  Future<void> apply({
    required String graphId,
    required AiGraphEditDraft draft,
  }) async {
    final nodeDao = GraphNodeDao(database);
    final edgeDao = GraphEdgeDao(database);
    final patch = draft.patch;
    final snapshot = draft.snapshot;

    await database.transaction(() async {
      final currentNodes = await nodeDao.getGraphNodesByGraph(graphId: graphId);
      final currentEdges = await edgeDao.getGraphEdgesByGraph(graphId: graphId);
      final currentSnapshot = compactGraphSnapshot(
        nodes: currentNodes,
        edges: currentEdges,
      );
      if (jsonEncode(currentSnapshot.toJson()) !=
          jsonEncode(snapshot.toJson())) {
        throw StateError(
          'O grafo mudou enquanto a IA preparava as alterações. Gere o patch novamente.',
        );
      }
      patch.validate(
        existingNodeIds: snapshot.nodesByCompactId.keys.toSet(),
        existingEdgeIds: snapshot.edgesByCompactId.keys.toSet(),
      );

      for (final compactId in patch.deletedEdgeIds) {
        await edgeDao.deleteGraphEdge(
          id: snapshot.edgesByCompactId[compactId]!.id,
        );
      }
      for (final compactId in patch.deletedNodeIds) {
        final nodeId = snapshot.nodesByCompactId[compactId]!.id;
        await edgeDao.deleteEdgesByNode(nodeId: nodeId);
        await nodeDao.deleteGraphNode(id: nodeId);
      }

      final descriptionNodeIds = <String>{};
      for (final rename in patch.renamedNodes) {
        final nodeId = snapshot.nodesByCompactId[rename.id]!.id;
        await nodeDao.updateGraphNode(
          id: nodeId,
          title: rename.title,
          description: const Value(null),
        );
        descriptionNodeIds.add(nodeId);
      }

      final maxX = currentNodes
          .map((node) => node.positionX)
          .fold<double>(0, math.max);
      final maxY = currentNodes
          .map((node) => node.positionY)
          .fold<double>(0, math.max);
      final newNodeIds = <String, String>{};
      for (var index = 0; index < patch.addedNodes.length; index++) {
        final node = patch.addedNodes[index];
        final localId = const Uuid().v4();
        newNodeIds[node.id] = localId;
        await nodeDao.insertGraphNode(
          id: localId,
          graphId: graphId,
          type: node.type,
          title: node.title,
          positionX: maxX + 220,
          positionY: maxY + index * 120,
        );
        descriptionNodeIds.add(localId);
      }

      String resolveNodeId(Object compactOrNewId) {
        if (compactOrNewId is int) {
          return snapshot.nodesByCompactId[compactOrNewId]!.id;
        }
        return newNodeIds[compactOrNewId]!;
      }

      for (final edge in patch.addedEdges) {
        await edgeDao.insertGraphEdge(
          graphId: graphId,
          sourceNodeId: resolveNodeId(edge.sourceNode),
          targetNodeId: resolveNodeId(edge.targetNode),
          type: edge.type,
          weight: edge.weight,
        );
      }

      for (final nodeId in descriptionNodeIds) {
        await _enqueueDescription(database, nodeId);
      }
    });
  }

  Future<void> _enqueueDescription(AppDatabase database, String nodeId) async {
    final tasks = database.aiBackgroundTask;
    final existing =
        await (database.select(tasks)..where(
              (task) =>
                  task.nodeId.equals(nodeId) &
                  task.taskType.equals(aiNodeDescriptionTaskType),
            ))
            .getSingleOrNull();
    final now = DateTime.now().millisecondsSinceEpoch;
    if (existing == null) {
      await database
          .into(tasks)
          .insert(
            AiBackgroundTaskCompanion.insert(
              id: const Uuid().v4(),
              nodeId: nodeId,
              taskType: aiNodeDescriptionTaskType,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      return;
    }
    await (database.update(
      tasks,
    )..where((task) => task.id.equals(existing.id))).write(
      AiBackgroundTaskCompanion(
        taskType: const Value(aiNodeDescriptionTaskType),
        status: const Value(aiTaskPending),
        attemptCount: const Value(0),
        nextAttemptAt: const Value(null),
        lastError: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }
}
