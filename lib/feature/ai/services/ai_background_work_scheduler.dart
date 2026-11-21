import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

const aiBackgroundQueueTask = 'noema.aiBackgroundQueue';

Future<void> scheduleAiBackgroundQueue({
  required String taskId,
  Duration? initialDelay,
}) async {
  if (!Platform.isAndroid && !Platform.isLinux) return;
  try {
    await Workmanager().registerOneOffTask(
      'noema.aiBackground.$taskId',
      aiBackgroundQueueTask,
      initialDelay: initialDelay,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
    );
  } on Object catch (error, stackTrace) {
    debugPrint('Não foi possível agendar tarefa de IA: $error');
    developer.log(
      'Falha ao agendar trabalho de IA.',
      name: 'noema.ai.worker',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
