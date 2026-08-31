import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModeOpenEndedNotifier extends Notifier<int>{
  @override
  int build() {
    return 0;
  }

  void modeChanged(int value){
    state = value;
  }
}

final modeOpenEndedProvider = NotifierProvider<ModeOpenEndedNotifier, int>(ModeOpenEndedNotifier.new);