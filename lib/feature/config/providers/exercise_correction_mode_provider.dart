import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
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
      _decode(config.preferences)['exerciseCorrectionMode'],
    );
  }

  Future<void> setMode(ExerciseCorrectionMode mode) async {
    final user = await ref.read(userProvider.future);
    final dao = ConfigDao(ref.read(appDatabaseProvider));
    final config = await dao.getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }

    final preferences = _decode(config.preferences);
    preferences['exerciseCorrectionMode'] = mode.preferenceValue;
    await dao.updateConfig(
      id: config.id,
      preferences: jsonEncode(preferences),
    );
    state = AsyncData(mode);
  }

  Map<String, dynamic> _decode(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    throw const FormatException(
      'As preferências locais não estão em um formato válido.',
    );
  }
}

final exerciseCorrectionModeProvider = AsyncNotifierProvider<
  ExerciseCorrectionModeNotifier,
  ExerciseCorrectionMode
>(ExerciseCorrectionModeNotifier.new);
