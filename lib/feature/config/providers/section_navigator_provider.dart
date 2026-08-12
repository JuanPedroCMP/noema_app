import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/providers/section_navigator_state.dart';

class SectionNavigatorNotifier extends Notifier<SectionNavigatorState> {

  @override
  SectionNavigatorState build() {
    return SectionNavigatorState();
  }

  void changeCurrentSection(ConfigSections value){
    state = state.copyWith(currentSection: value);
  }
}

final sectionNavigatorProvider = NotifierProvider<SectionNavigatorNotifier, SectionNavigatorState>(SectionNavigatorNotifier.new);