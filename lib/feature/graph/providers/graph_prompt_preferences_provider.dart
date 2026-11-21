import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

enum GraphPromptEnhancementMode {
  automatic,
  direct;

  static GraphPromptEnhancementMode fromPreference(Object? value) =>
      switch (value) {
        'automatic' => GraphPromptEnhancementMode.automatic,
        _ => GraphPromptEnhancementMode.direct,
      };

  String get preferenceName => switch (this) {
    GraphPromptEnhancementMode.automatic => 'automatic',
    GraphPromptEnhancementMode.direct => 'direct',
  };

  String get label => switch (this) {
    GraphPromptEnhancementMode.automatic => 'Melhorar automaticamente',
    GraphPromptEnhancementMode.direct => 'Melhorar só quando eu pedir',
  };

  String get description => switch (this) {
    GraphPromptEnhancementMode.automatic =>
      'A IA refina o tema antes da geração, exceto se você já o aprimorou manualmente.',
    GraphPromptEnhancementMode.direct =>
      'Gera com o texto escrito. Você ainda pode aprimorá-lo manualmente.',
  };
}

class GraphPromptPreferencesNotifier
    extends AsyncNotifier<GraphPromptEnhancementMode> {
  @override
  Future<GraphPromptEnhancementMode> build() async {
    final user = await ref.watch(userProvider.future);
    final config = await ConfigDao(
      ref.watch(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    if (config == null) return GraphPromptEnhancementMode.direct;
    return GraphPromptEnhancementMode.fromPreference(
      readConfigPreference(config.preferences, 'graphPromptEnhancementMode'),
    );
  }

  Future<void> setMode(GraphPromptEnhancementMode mode) async {
    await saveConfigPreference(
      ref,
      key: 'graphPromptEnhancementMode',
      value: mode.preferenceName,
    );
    state = AsyncData(mode);
  }
}

final graphPromptEnhancementModeProvider =
    AsyncNotifierProvider<
      GraphPromptPreferencesNotifier,
      GraphPromptEnhancementMode
    >(GraphPromptPreferencesNotifier.new);
