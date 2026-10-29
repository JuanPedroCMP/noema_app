import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'ai_background_task_dao.g.dart';

const aiNodeDescriptionTaskType = 'NODE_DESCRIPTION';
const aiOpenEndedCorrectionTaskType = 'OPEN_ENDED_CORRECTION';
const aiMultipleChoiceCorrectionTaskType = 'MULTIPLE_CHOICE_CORRECTION';
const aiTaskPending = 'PENDING';
const aiTaskRunning = 'RUNNING';
const aiTaskRetryWait = 'RETRY_WAIT';
const aiTaskFailed = 'FAILED';
const aiTaskCompleted = 'COMPLETED';
const aiTaskCanceled = 'CANCELED';
const aiTaskMaximumAttempts = 3;

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

    final existing = await (select(_tasks)
          ..where(
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

  Stream<List<AiQueueItem>> watchQueueItems() {
    final query = select(_tasks).join([
      innerJoin(
        _nodes,
        _nodes.id.equalsExp(_tasks.nodeId),
      ),
      innerJoin(
        _graphs,
        _graphs.id.equalsExp(_nodes.graphId),
      ),
    ])..orderBy([OrderingTerm.desc(_tasks.createdAt)]);

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
    required int now,
    required int limit,
  }) {
    return (select(_tasks)
          ..where(
            (task) =>
                task.status.equals(aiTaskPending) |
                (task.status.equals(aiTaskRetryWait) &
                    task.nextAttemptAt.isSmallerOrEqualValue(now)),
          )
          ..orderBy([
            (task) => OrderingTerm.asc(task.createdAt),
          ])
          ..limit(limit))
        .get();
  }

  Future<AiBackgroundTaskData?> markRunning(String id) async {
    final task = await (select(_tasks)
          ..where((row) => row.id.equals(id))
          ..where(
            (row) =>
                row.status.equals(aiTaskPending) |
                (row.status.equals(aiTaskRetryWait) &
                    row.nextAttemptAt.isSmallerOrEqualValue(
                      DateTime.now().millisecondsSinceEpoch,
                    )),
          ))
        .getSingleOrNull();
    if (task == null) return null;
    final changed = await (update(_tasks)
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
    return (select(_tasks)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> recoverInterruptedTasks() async {
    await (update(_tasks)
          ..where((task) => task.status.equals(aiTaskRunning))
          ..where(
            (task) => task.attemptCount.isBiggerOrEqualValue(
              aiTaskMaximumAttempts,
            ),
          ))
        .write(
          AiBackgroundTaskCompanion(
            status: const Value(aiTaskFailed),
            nextAttemptAt: const Value(null),
            lastError: const Value(
              'A tarefa foi interrompida durante a última tentativa.',
            ),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    await (update(_tasks)
          ..where((task) => task.status.equals(aiTaskRunning)))
        .write(
          AiBackgroundTaskCompanion(
            status: const Value(aiTaskPending),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<GraphNodeData?> getNode(String id) {
    return (select(_nodes)..where((node) => node.id.equals(id)))
        .getSingleOrNull();
  }

  Future<KnowledgeGraphData?> getGraph(String id) {
    return (select(_graphs)..where((graph) => graph.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> complete(
    String taskId, {
    String? description,
    String? expectedNodeTitle,
  }) async {
    await transaction(() async {
      if (description != null) {
        final task = await (select(_tasks)
              ..where((row) => row.id.equals(taskId)))
            .getSingleOrNull();
        if (task != null) {
          final nodeUpdate = update(_nodes)
            ..where((node) => node.id.equals(task.nodeId))
            ..where(
              (node) =>
                  node.description.isNull() | node.description.equals(''),
            );
          if (expectedNodeTitle != null) {
            nodeUpdate.where((node) => node.title.equals(expectedNodeTitle));
          }
          await nodeUpdate
              .write(
                GraphNodeCompanion(
                  description: Value(description),
                  updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
                ),
              );
        }
      }
      await (update(_tasks)
            ..where((row) => row.id.equals(taskId)))
          .write(
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
    return (update(_tasks)..where((row) => row.id.equals(taskId)))
        .write(
          AiBackgroundTaskCompanion(
            status: const Value(aiTaskRetryWait),
            nextAttemptAt: Value(retryAt),
            lastError: Value(error),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<void> markFailed({required String taskId, required String error}) {
    return (update(_tasks)..where((row) => row.id.equals(taskId)))
        .write(
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
    return (delete(_tasks)
          ..where(
            (row) =>
                row.status.equals(aiTaskCompleted) |
                row.status.equals(aiTaskCanceled),
          ))
        .go();
  }
}
