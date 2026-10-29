import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';

final aiBackgroundTaskItemsProvider = StreamProvider<List<AiQueueItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AiBackgroundTaskDao(db).watchQueueItems();
});
