import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';

void main() {
  test('creates useful notices only for important completed task types', () {
    expect(
      aiTaskNotificationContent(
        taskType: aiStudyPackTaskType,
        nodeTitle: 'Fotossíntese',
      ),
      (
        title: 'Pacote de estudo pronto',
        body: 'O material de "Fotossíntese" está disponível.',
      ),
    );
    expect(
      aiTaskNotificationContent(taskType: 'UNKNOWN', nodeTitle: 'Nó'),
      isNull,
    );
  });
}
