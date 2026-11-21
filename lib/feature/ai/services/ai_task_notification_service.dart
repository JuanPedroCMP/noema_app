import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';

({String title, String body})? aiTaskNotificationContent({
  required String taskType,
  required String nodeTitle,
}) => switch (taskType) {
  aiNodeDescriptionTaskType => (
    title: 'Descrição pronta',
    body: 'A descrição de "$nodeTitle" foi gerada.',
  ),
  aiOpenEndedCorrectionTaskType || aiMultipleChoiceCorrectionTaskType => (
    title: 'Correção pronta',
    body: 'A correção de "$nodeTitle" foi concluída.',
  ),
  aiStudyPackTaskType => (
    title: 'Pacote de estudo pronto',
    body: 'O material de "$nodeTitle" está disponível.',
  ),
  _ => null,
};

class AiTaskNotificationService {
  AiTaskNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool _permissionRequested = false;

  Future<void> initialize({bool requestPermission = false}) async {
    if (!Platform.isAndroid && !Platform.isLinux) return;
    try {
      if (!_initialized) {
        await _plugin.initialize(
          settings: const InitializationSettings(
            android: AndroidInitializationSettings('noema_icon_monochrome'),
            linux: LinuxInitializationSettings(
              defaultActionName: 'Abrir Noema',
            ),
          ),
        );
        _initialized = true;
      }
      if (requestPermission && Platform.isAndroid && !_permissionRequested) {
        _permissionRequested = true;
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
    } on Object catch (error, stackTrace) {
      debugPrint('Não foi possível inicializar notificações de IA: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> show({
    required String taskId,
    required String taskType,
    required String nodeTitle,
  }) async {
    if (!Platform.isAndroid && !Platform.isLinux) return;
    final content = aiTaskNotificationContent(
      taskType: taskType,
      nodeTitle: nodeTitle,
    );
    if (content == null) return;
    try {
      await initialize();
      await _plugin.show(
        id: taskId.hashCode & 0x7fffffff,
        title: content.title,
        body: content.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'noema_ai_tasks',
            'Atividades de IA',
            channelDescription:
                'Conclusões importantes de conteúdo e correções.',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          linux: LinuxNotificationDetails(defaultActionName: 'Abrir Noema'),
        ),
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Não foi possível mostrar notificação de IA: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

final aiTaskNotificationServiceProvider = Provider<AiTaskNotificationService>(
  (ref) => AiTaskNotificationService(),
);
