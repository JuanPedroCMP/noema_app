import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';

const recommendedStudyContentPreferenceKey = 'recommendedStudyContent';

class RecommendedStudyContentSettings {
  const RecommendedStudyContentSettings({
    this.enabled = false,
    this.counts = const StudyPackCounts(
      multipleChoice: 2,
      essay: 1,
      feynman: 1,
      flashcards: 3,
    ),
  });

  final bool enabled;
  final StudyPackCounts counts;

  factory RecommendedStudyContentSettings.fromPreference(Object? value) {
    if (value is! Map) return const RecommendedStudyContentSettings();
    try {
      return RecommendedStudyContentSettings(
        enabled: value['enabled'] == true,
        counts: StudyPackCounts.fromJson({
          'multiple_choice': value['multiple_choice'] ?? 2,
          'essay': value['essay'] ?? 1,
          'feynman': value['feynman'] ?? 1,
          'flashcards': value['flashcards'] ?? 3,
        }),
      );
    } on Object {
      return const RecommendedStudyContentSettings();
    }
  }

  Map<String, Object?> toJson() => {'enabled': enabled, ...counts.toJson()};

  RecommendedStudyContentSettings copyWith({
    bool? enabled,
    StudyPackCounts? counts,
  }) => RecommendedStudyContentSettings(
    enabled: enabled ?? this.enabled,
    counts: counts ?? this.counts,
  );
}

class RecommendedStudyContentNotifier
    extends AsyncNotifier<RecommendedStudyContentSettings> {
  @override
  Future<RecommendedStudyContentSettings> build() async {
    final user = await ref.watch(userProvider.future);
    final config = await ConfigDao(
      ref.watch(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    return RecommendedStudyContentSettings.fromPreference(
      config == null
          ? null
          : readConfigPreference(
              config.preferences,
              recommendedStudyContentPreferenceKey,
            ),
    );
  }

  Future<void> setEnabled(bool enabled) async {
    await _save(state.requireValue.copyWith(enabled: enabled));
  }

  Future<void> setCounts(StudyPackCounts counts) async {
    counts.validate();
    await _save(state.requireValue.copyWith(counts: counts));
  }

  Future<void> _save(RecommendedStudyContentSettings settings) async {
    await saveConfigPreference(
      ref,
      key: recommendedStudyContentPreferenceKey,
      value: settings.toJson(),
    );
    state = AsyncData(settings);
  }
}

final recommendedStudyContentSettingsProvider =
    AsyncNotifierProvider<
      RecommendedStudyContentNotifier,
      RecommendedStudyContentSettings
    >(RecommendedStudyContentNotifier.new);
