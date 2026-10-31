import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

enum ExerciseCorrectionMode {
  automaticAi('automatic_ai'),
  manual('manual');

  const ExerciseCorrectionMode(this.preferenceValue);

  final String preferenceValue;

  static ExerciseCorrectionMode fromPreference(dynamic value) =>
      ExerciseCorrectionMode.values.firstWhere(
        (mode) => mode.preferenceValue == value,
        orElse: () => ExerciseCorrectionMode.automaticAi,
      );
}

class ExerciseCorrectionModeNotifier
    extends AsyncNotifier<ExerciseCorrectionMode> {
  @override
  Future<ExerciseCorrectionMode> build() async {
    final user = await ref.watch(userProvider.future);
    final config = await ConfigDao(
      ref.watch(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    if (config == null) return ExerciseCorrectionMode.automaticAi;
    return ExerciseCorrectionMode.fromPreference(
      readConfigPreference(
        config.preferences,
        'exerciseCorrectionMode',
      ),
    );
  }

  Future<void> setMode(ExerciseCorrectionMode mode) async {
    await saveConfigPreference(
      ref,
      key: 'exerciseCorrectionMode',
      value: mode.preferenceValue,
    );
    state = AsyncData(mode);
  }
}

final exerciseCorrectionModeProvider = AsyncNotifierProvider<
  ExerciseCorrectionModeNotifier,
  ExerciseCorrectionMode
>(ExerciseCorrectionModeNotifier.new);
