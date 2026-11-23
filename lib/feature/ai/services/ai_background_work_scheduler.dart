import 'dart:io';

import 'package:workmanager/workmanager.dart';

const aiBackgroundQueueTask = 'noema.aiBackgroundQueue';
const iosAiBackgroundTaskIdentifier = 'com.example.noema.aiBackgroundQueue';

bool isAiBackgroundQueueWork(String taskName) =>
    taskName == aiBackgroundQueueTask ||
    taskName == iosAiBackgroundTaskIdentifier;

Future<void> scheduleAiBackgroundQueue({
  required String taskId,
  Duration? initialDelay,
}) async {
  if (Platform.isIOS) {
    await Workmanager().registerProcessingTask(
      iosAiBackgroundTaskIdentifier,
      aiBackgroundQueueTask,
      inputData: {'taskId': taskId},
      initialDelay: initialDelay,
      constraints: Constraints(networkType: NetworkType.connected),
    );
    return;
  }
  if (!Platform.isAndroid && !Platform.isLinux) return;
  await Workmanager().registerOneOffTask(
    'noema.aiBackground.$taskId',
    aiBackgroundQueueTask,
    inputData: {'taskId': taskId},
    initialDelay: initialDelay,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.exponential,
  );
}
