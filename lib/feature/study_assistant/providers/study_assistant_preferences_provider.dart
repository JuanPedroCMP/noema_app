import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';

class StudyAssistantPreferencesNotifier
    extends AsyncNotifier<StudyAssistantSettings> {
  @override
  Future<StudyAssistantSettings> build() async {
    final user = await ref.watch(userProvider.future);
    final config = await ConfigDao(
      ref.watch(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    if (config == null) return const StudyAssistantSettings();
    final autoGenerate = readConfigPreference(
      config.preferences,
      'studyAssistantAutoGenerateActions',
    );
    final learningGoal = readConfigPreference(
      config.preferences,
      'studyAssistantLearningGoal',
    );
    final pinPanel = readConfigPreference(
      config.preferences,
      'studyAssistantPinPanel',
    );
    final sendOnEnter = readConfigPreference(
      config.preferences,
      'studyAssistantSendOnEnter',
    );
    return StudyAssistantSettings(
      autoGenerateActions: autoGenerate is bool ? autoGenerate : false,
      learningGoal: learningGoal is String ? learningGoal : '',
      pinPanel: pinPanel is bool ? pinPanel : false,
      responseStyle: StudyAssistantResponseStyle.fromPreference(
        readConfigPreference(
          config.preferences,
          'studyAssistantResponseStyle',
        ),
      ),
      sendOnEnter: sendOnEnter is bool ? sendOnEnter : false,
    );
  }

  Future<void> setAutoGenerateActions(bool enabled) async {
    final current = await future;
    await saveConfigPreference(
      ref,
      key: 'studyAssistantAutoGenerateActions',
      value: enabled,
    );
    state = AsyncData(current.copyWith(autoGenerateActions: enabled));
  }

  Future<void> setPinPanel(bool enabled) async {
    final current = await future;
    await saveConfigPreference(
      ref,
      key: 'studyAssistantPinPanel',
      value: enabled,
    );
    state = AsyncData(current.copyWith(pinPanel: enabled));
  }

  Future<void> setSendOnEnter(bool enabled) async {
    final current = await future;
    await saveConfigPreference(
      ref,
      key: 'studyAssistantSendOnEnter',
      value: enabled,
    );
    state = AsyncData(current.copyWith(sendOnEnter: enabled));
  }

  Future<void> setResponseStyle(StudyAssistantResponseStyle style) async {
    final current = await future;
    await saveConfigPreference(
      ref,
      key: 'studyAssistantResponseStyle',
      value: style.name,
    );
    state = AsyncData(current.copyWith(responseStyle: style));
  }

  Future<void> setLearningGoal(String goal) async {
    final normalized = goal.trim();
    if (normalized.length > 160) {
      throw ArgumentError.value(
        goal,
        'goal',
        'O objetivo deve ter no máximo 160 caracteres.',
      );
    }
    final current = await future;
    await saveConfigPreference(
      ref,
      key: 'studyAssistantLearningGoal',
      value: normalized,
    );
    state = AsyncData(current.copyWith(learningGoal: normalized));
  }
}

final studyAssistantSettingsProvider = AsyncNotifierProvider<
  StudyAssistantPreferencesNotifier,
  StudyAssistantSettings
>(StudyAssistantPreferencesNotifier.new);
