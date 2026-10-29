import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/config/providers/exercise_correction_mode_provider.dart';

enum ExerciseCorrectionEnqueueResult { queued, manual }

Future<ExerciseCorrectionEnqueueResult> enqueueExerciseCorrectionIfAutomatic({
  required WidgetRef ref,
  required String nodeId,
  required String responseId,
  required String taskType,
}) async {
  final mode = await ref.read(exerciseCorrectionModeProvider.future);
  if (mode == ExerciseCorrectionMode.manual) {
    return ExerciseCorrectionEnqueueResult.manual;
  }

  await AiBackgroundTaskDao(
    ref.read(appDatabaseProvider),
  ).enqueueExerciseCorrection(
    nodeId: nodeId,
    responseId: responseId,
    taskType: taskType,
  );
  ref.read(aiBackgroundTaskRunnerProvider).requestPump();
  return ExerciseCorrectionEnqueueResult.queued;
}
