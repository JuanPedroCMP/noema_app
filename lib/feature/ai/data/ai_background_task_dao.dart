import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'ai_background_task_dao.g.dart';

const aiNodeDescriptionTaskType = 'NODE_DESCRIPTION';
const aiOpenEndedCorrectionTaskType = 'OPEN_ENDED_CORRECTION';
const aiMultipleChoiceCorrectionTaskType = 'MULTIPLE_CHOICE_CORRECTION';
const aiStudyPackTaskType = 'STUDY_PACK';
const aiTaskPending = 'PENDING';
const aiTaskRunning = 'RUNNING';
const aiTaskRetryWait = 'RETRY_WAIT';
const aiTaskFailed = 'FAILED';
const aiTaskCompleted = 'COMPLETED';
const aiTaskCanceled = 'CANCELED';
const aiTaskMaximumAttempts = 3;
const aiTaskExecutionLease = Duration(minutes: 2);

class AiQueueItem {
  const AiQueueItem({
    required this.task,
    required this.node,
    required this.graph,
  });

  final AiBackgroundTaskData task;
  final GraphNodeData node;
  final KnowledgeGraphData graph;
}

@DriftAccessor(tables: [AiBackgroundTask, GraphNode, KnowledgeGraph])
class AiBackgroundTaskDao extends DatabaseAccessor<AppDatabase>
    with _$AiBackgroundTaskDaoMixin {
  AiBackgroundTaskDao(super.db);

  AiBackgroundTask get _tasks => attachedDatabase.aiBackgroundTask;
  GraphNode get _nodes => attachedDatabase.graphNode;
  KnowledgeGraph get _graphs => attachedDatabase.knowledgeGraph;

  Future<String> enqueueExerciseCorrection({
    required String nodeId,
    required String responseId,
    required String taskType,
  }) async {
    if (!{
      aiOpenEndedCorrectionTaskType,
      aiMultipleChoiceCorrectionTaskType,
    }.contains(taskType)) {
      throw ArgumentError.value(taskType, 'taskType');
    }
    if (nodeId.trim().isEmpty || responseId.trim().isEmpty) {
      throw ArgumentError('O nó e a resposta são obrigatórios para a fila.');
    }

    final existing =
        await (select(_tasks)..where(
              (task) =>
                  task.subjectId.equals(responseId) &
                  task.taskType.equals(taskType),
            ))
            .getSingleOrNull();
    if (existing != null) return existing.id;

    final id = const Uuid().v4();
    await into(_tasks).insert(
      AiBackgroundTaskCompanion.insert(
        id: id,
        nodeId: nodeId,
        taskType: taskType,
        subjectId: Value(responseId),
      ),
    );
    return id;
  }

  Future<String> enqueueStudyPack({
    required String nodeId,
    required Map<String, Object?> payload,
  }) async {
    if (nodeId.trim().isEmpty) {
      throw ArgumentError.value(nodeId, 'nodeId', 'must not be empty');
    }
    final payloadJson = jsonEncode(payload);
    return attachedDatabase.transaction(() async {
      final existing =
          await (select(_tasks)..where(
                (task) =>
                    task.nodeId.equals(nodeId) &
                    task.taskType.equals(aiStudyPackTaskType) &
                    task.status.isIn([
                      aiTaskPending,
                      aiTaskRunning,
                      aiTaskRetryWait,
                    ]),
              ))
              .getSingleOrNull();
      if (existing != null) return existing.id;

      final id = const Uuid().v4();
      await into(_tasks).insert(
        AiBackgroundTaskCompanion.insert(
          id: id,
          nodeId: nodeId,
          taskType: aiStudyPackTaskType,
          payloadJson: Value(payloadJson),
        ),
      );
      return id;
    });
  }

  Stream<List<AiQueueItem>> watchQueueItems({required String userId}) {
    final query =
        select(_tasks).join([
            innerJoin(_nodes, _nodes.id.equalsExp(_tasks.nodeId)),
            innerJoin(_graphs, _graphs.id.equalsExp(_nodes.graphId)),
          ])
          ..where(_graphs.userId.equals(userId))
          ..orderBy([OrderingTerm.desc(_tasks.createdAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => AiQueueItem(
              task: row.readTable(_tasks),
              node: row.readTable(_nodes),
              graph: row.readTable(_graphs),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<List<AiBackgroundTaskData>> getReadyTasks({
    required String userId,
    required int now,
    required int limit,
  }) async {
    final query =
        select(_tasks).join([
            innerJoin(_nodes, _nodes.id.equalsExp(_tasks.nodeId)),
            innerJoin(_graphs, _graphs.id.equalsExp(_nodes.graphId)),
          ])
          ..where(
            _graphs.userId.equals(userId) &
                (_tasks.status.equals(aiTaskPending) |
                    (_tasks.status.equals(aiTaskRetryWait) &
                        _tasks.nextAttemptAt.isSmallerOrEqualValue(now))),
          )
          ..orderBy([OrderingTerm.asc(_tasks.createdAt)])
          ..limit(limit);
    final rows = await query.get();
    return rows.map((row) => row.readTable(_tasks)).toList(growable: false);
  }

  Future<int?> getNextRetryAt({required String userId}) async {
    final row =
        await (select(_tasks).join([
                innerJoin(_nodes, _nodes.id.equalsExp(_tasks.nodeId)),
                innerJoin(_graphs, _graphs.id.equalsExp(_nodes.graphId)),
              ])
              ..where(
                _graphs.userId.equals(userId) &
                    _tasks.status.equals(aiTaskRetryWait),
              )
              ..orderBy([OrderingTerm.asc(_tasks.nextAttemptAt)])
              ..limit(1))
            .getSingleOrNull();
    return row?.readTable(_tasks).nextAttemptAt;
  }

  Future<AiBackgroundTaskData?> markRunning({
    required String id,
    required String userId,
  }) async {
    final ownership =
        await (select(_tasks).join([
              innerJoin(_nodes, _nodes.id.equalsExp(_tasks.nodeId)),
              innerJoin(_graphs, _graphs.id.equalsExp(_nodes.graphId)),
            ])..where(_tasks.id.equals(id) & _graphs.userId.equals(userId)))
            .getSingleOrNull();
    final task = ownership?.readTable(_tasks);
    if (task == null) return null;
    if (task.status != aiTaskPending && task.status != aiTaskRetryWait) {
      return null;
    }
    if (task.status == aiTaskRetryWait &&
        (task.nextAttemptAt == null ||
            task.nextAttemptAt! > DateTime.now().millisecondsSinceEpoch)) {
      return null;
    }
    final changed =
        await (update(_tasks)
              ..where((row) => row.id.equals(id))
              ..where((row) => row.status.equals(task.status)))
            .write(
              AiBackgroundTaskCompanion(
                status: const Value(aiTaskRunning),
                attemptCount: Value(task.attemptCount + 1),
                nextAttemptAt: const Value(null),
                lastError: const Value(null),
                updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
              ),
            );
    if (changed == 0) return null;
    return (select(
      _tasks,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> recoverInterruptedTasks({
    required String userId,
    required int updatedBefore,
  }) async {
    final rows =
        await (select(_tasks).join([
              innerJoin(_nodes, _nodes.id.equalsExp(_tasks.nodeId)),
              innerJoin(_graphs, _graphs.id.equalsExp(_nodes.graphId)),
            ])..where(
              _graphs.userId.equals(userId) &
                  _tasks.status.equals(aiTaskRunning) &
                  _tasks.updatedAt.isSmallerThanValue(updatedBefore),
            ))
            .get();
    for (final row in rows) {
      final task = row.readTable(_tasks);
      final exhausted = task.attemptCount >= aiTaskMaximumAttempts;
      await (update(_tasks)..where(
            (current) =>
                current.id.equals(task.id) &
                current.status.equals(aiTaskRunning) &
                current.updatedAt.isSmallerThanValue(updatedBefore),
          ))
          .write(
            AiBackgroundTaskCompanion(
              status: Value(exhausted ? aiTaskFailed : aiTaskPending),
              nextAttemptAt: const Value(null),
              lastError: Value(
                exhausted
                    ? 'A tarefa foi interrompida durante a última tentativa.'
                    : task.lastError,
              ),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );
    }
  }

  Future<int> touchRunningTask(String taskId) {
    return (update(_tasks)
          ..where((task) => task.id.equals(taskId))
          ..where((task) => task.status.equals(aiTaskRunning)))
        .write(
          AiBackgroundTaskCompanion(
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<GraphNodeData?> getNode(String id) {
    return (select(
      _nodes,
    )..where((node) => node.id.equals(id))).getSingleOrNull();
  }

  Future<AiBackgroundTaskData?> getTask(String id) {
    return (select(
      _tasks,
    )..where((task) => task.id.equals(id))).getSingleOrNull();
  }

  Future<KnowledgeGraphData?> getGraph(String id) {
    return (select(
      _graphs,
    )..where((graph) => graph.id.equals(id))).getSingleOrNull();
  }

  Future<void> complete(
    String taskId, {
    String? description,
    String? expectedNodeTitle,
    bool replaceExistingDescription = false,
    String? expectedNodeDescription,
  }) async {
    await transaction(() async {
      if (description != null) {
        final task = await (select(
          _tasks,
        )..where((row) => row.id.equals(taskId))).getSingleOrNull();
        if (task != null) {
          final nodeUpdate = update(_nodes)
            ..where((node) => node.id.equals(task.nodeId));
          if (replaceExistingDescription) {
            if (expectedNodeDescription == null) {
              nodeUpdate.where((node) => node.description.isNull());
            } else {
              nodeUpdate.where(
                (node) => node.description.equals(expectedNodeDescription),
              );
            }
          } else {
            nodeUpdate.where(
              (node) => node.description.isNull() | node.description.equals(''),
            );
          }
          if (expectedNodeTitle != null) {
            nodeUpdate.where((node) => node.title.equals(expectedNodeTitle));
          }
          await nodeUpdate.write(
            GraphNodeCompanion(
              description: Value(description),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );
        }
      }
      await (update(_tasks)..where((row) => row.id.equals(taskId))).write(
        AiBackgroundTaskCompanion(
          status: const Value(aiTaskCompleted),
          lastError: const Value(null),
          nextAttemptAt: const Value(null),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    });
  }

  Future<void> scheduleRetry({
    required String taskId,
    required String error,
    required int retryAt,
  }) {
    return (update(_tasks)..where((row) => row.id.equals(taskId))).write(
      AiBackgroundTaskCompanion(
        status: const Value(aiTaskRetryWait),
        nextAttemptAt: Value(retryAt),
        lastError: Value(error),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> markFailed({required String taskId, required String error}) {
    return (update(_tasks)..where((row) => row.id.equals(taskId))).write(
      AiBackgroundTaskCompanion(
        status: const Value(aiTaskFailed),
        nextAttemptAt: const Value(null),
        lastError: Value(error),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<int> retryNow(String taskId) {
    return (update(_tasks)
          ..where((row) => row.id.equals(taskId))
          ..where(
            (row) =>
                row.status.equals(aiTaskRetryWait) |
                row.status.equals(aiTaskFailed),
          ))
        .write(
          AiBackgroundTaskCompanion(
            status: const Value(aiTaskPending),
            attemptCount: const Value(0),
            nextAttemptAt: const Value(null),
            lastError: const Value(null),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<int> cancel(String taskId) {
    return (update(_tasks)
          ..where((row) => row.id.equals(taskId))
          ..where(
            (row) =>
                row.status.equals(aiTaskPending) |
                row.status.equals(aiTaskRetryWait) |
                row.status.equals(aiTaskFailed),
          ))
        .write(
          AiBackgroundTaskCompanion(
            status: const Value(aiTaskCanceled),
            nextAttemptAt: const Value(null),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<int> clearFinished() {
    return (delete(_tasks)..where(
          (row) =>
              row.status.equals(aiTaskCompleted) |
              row.status.equals(aiTaskCanceled),
        ))
        .go();
  }
}
