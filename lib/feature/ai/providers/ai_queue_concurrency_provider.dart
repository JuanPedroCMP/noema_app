import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

class AiQueueConcurrencyNotifier extends AsyncNotifier<int> {
  static const minimum = 1;
  static const maximum = 8;

  @override
  Future<int> build() async {
    final user = await ref.watch(userProvider.future);
    final db = ref.watch(appDatabaseProvider);
    final config = await ConfigDao(db).getConfigByUser(userId: user.id);
    return config?.aiMaxConcurrentRequests ?? minimum;
  }

  Future<void> setConcurrency(int concurrency) async {
    if (concurrency < minimum || concurrency > maximum) {
      throw ArgumentError.value(
        concurrency,
        'concurrency',
        'must be between $minimum and $maximum',
      );
    }

    final user = await ref.read(userProvider.future);
    final db = ref.read(appDatabaseProvider);
    final dao = ConfigDao(db);
    final config = await dao.getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }

    await dao.updateConfig(
      id: config.id,
      aiMaxConcurrentRequests: concurrency,
    );
    state = AsyncData(concurrency);
  }
}

final aiQueueConcurrencyProvider =
    AsyncNotifierProvider<AiQueueConcurrencyNotifier, int>(
      AiQueueConcurrencyNotifier.new,
    );
