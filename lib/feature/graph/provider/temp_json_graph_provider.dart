import 'package:flutter_riverpod/flutter_riverpod.dart';

class TempJsonGraphNotifier extends Notifier<String> {

  @override
  String build() {
    return '';
  }

  void jsonChanged(String value){
    state = value;
  }
}

final tempJsonGraphProvider = NotifierProvider<TempJsonGraphNotifier, String>(TempJsonGraphNotifier.new);