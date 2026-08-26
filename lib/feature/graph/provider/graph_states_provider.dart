import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/graph/provider/graph_states_state.dart';

class GraphStatesNotifier extends Notifier<GraphStatesSate> {
  @override
  GraphStatesSate build() {
    return GraphStatesSate();
  }

  void isCreatingEdgeChanged(bool value) {
    state = state.copyWith(isCreatingEdge: value,  isCreatingNode: false, isEditing:false);
  }

  void isCreatingNodeChanged(bool value) {
    state = state.copyWith(isCreatingNode: value, isCreatingEdge: false, isEditing:false);
  }

  void isEditingChanged(bool value) {
    state = state.copyWith(isEditing: value, isCreatingNode: false, isCreatingEdge: false);
  }
}

final graphStatesProvider = NotifierProvider<GraphStatesNotifier, GraphStatesSate>(GraphStatesNotifier.new);