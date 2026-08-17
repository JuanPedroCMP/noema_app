import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/graph/provider/node_form_state.dart';

class NodeFormProvider extends Notifier<NodeformState> {
  @override
  NodeformState build() {
    return const NodeformState();
  }

  void grapIdChanged(String value) {
    state = state.copyWith(graphId: value);
  }

  void typeChanged(String value) {
    state = state.copyWith(type: value);
  }

  void titleChanged(String value) {
    state = state.copyWith(title: value);
  }

  void descriptionChanged(String value) {
    state = state.copyWith(description: value);
  }

  void maesteryScoreChanged(double value) {
    state = state.copyWith(maesteryScore: value);
  }

  void isSkippedChanged(bool value) {
    state = state.copyWith(isSkipped: value);
  }

  void positionXChanged(double value) {
    state = state.copyWith(positionX: value);
  }

  void positionYChanged(double value) {
    state = state.copyWith(positionY: value);
  }

  void aiSynthesisChanged(String value) {
    state = state.copyWith(aiSynthesis: value);
  }
}

final nodeFormProvider = NotifierProvider<NodeFormProvider, NodeformState>(
  NodeFormProvider.new,
);
