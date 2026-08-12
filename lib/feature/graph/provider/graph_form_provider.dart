import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/graph/provider/graph_form_state.dart';

class GraphFormNotifier extends Notifier<GraphFormState> {
  @override
  GraphFormState build() {
    return const GraphFormState();
  }

  void userIdChagend(String value) {
    state = state.copyWith(userId: value);
  }

  void titleChagend(String value) {
    state = state.copyWith(title: value);
  }

  void descriptionChagend(String value) {
    state = state.copyWith(description: value);
  }

  void isArchivedChagend(bool value) {
    state = state.copyWith(isArchived: value);
  }

  void syncedChagend(bool value) {
    state = state.copyWith(synced: value);
  }
}

final graphFormProvider = NotifierProvider<GraphFormNotifier, GraphFormState>(GraphFormNotifier.new);