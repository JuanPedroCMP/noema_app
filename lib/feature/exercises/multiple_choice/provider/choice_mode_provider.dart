import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChoiseModeNotifier extends Notifier<int>{
  @override
  int build() {
    return 0;
  }

  void modeChanged(int value){
    state = value;
  }
}

final modeOpenEndedProvider = NotifierProvider<ChoiseModeNotifier, int>(ChoiseModeNotifier.new);