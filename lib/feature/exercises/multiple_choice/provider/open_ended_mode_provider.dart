import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModeMultipleChoiseNotifier extends Notifier<int>{
  @override
  int build() {
    return 0;
  }

  void modeChanged(int value){
    state = value;
  }
}

final modeMultipleChoiseProvider = NotifierProvider<ModeMultipleChoiseNotifier, int>(ModeMultipleChoiseNotifier.new);