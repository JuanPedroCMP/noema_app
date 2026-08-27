import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/graph/provider/edge_form_state.dart';

class EdgeFormProvider extends Notifier<EdgeformState> {
  @override
  EdgeformState build() {
    return const EdgeformState();
  }

  void grapIdChanged(String value) {
    state = state.copyWith(graphId: value);
  }

  void sourceNodeIdChanged(String value) {
    state = state.copyWith(sourceNodeId: value);
  }

  void targetNodeIdChanged(String value) {
    state = state.copyWith(targetNodeId: value);
  }

  void typeChanged(String value) {
    state = state.copyWith(type: value);
  }

  void weightChanged(double value) {
    state = state.copyWith(weight: value);
  }
}

final edgeFormProvider = NotifierProvider<EdgeFormProvider, EdgeformState>(EdgeFormProvider.new);
