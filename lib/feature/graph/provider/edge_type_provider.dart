import 'package:flutter_riverpod/flutter_riverpod.dart';

class EdgeTypeNotifier extends Notifier<int> {

  @override
  int build() {
    return 0;
  }

  void edgeTypeChanged(int value){
    state = value;
  }
}

final edgeTypeProvider = NotifierProvider<EdgeTypeNotifier, int>(EdgeTypeNotifier.new);