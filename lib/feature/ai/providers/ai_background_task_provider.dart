import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

final aiBackgroundTaskItemsProvider = StreamProvider<List<AiQueueItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ref
      .watch(userProvider)
      .when(
        data: (user) =>
            AiBackgroundTaskDao(db).watchQueueItems(userId: user.id),
        error: (error, stackTrace) =>
            Stream<List<AiQueueItem>>.error(error, stackTrace),
        loading: () => const Stream<List<AiQueueItem>>.empty(),
      );
});
