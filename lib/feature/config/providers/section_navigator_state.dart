import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:noema/feature/config/data/enums.dart';

part 'section_navigator_state.freezed.dart';

@freezed
sealed class SectionNavigatorState with _$SectionNavigatorState {
  const factory SectionNavigatorState({
    @Default(ConfigSections.profile) ConfigSections currentSection,
  }) = _SectionNavigatorState;
}
