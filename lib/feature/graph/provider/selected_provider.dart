import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedNotifier extends Notifier<String> {

  @override
  String build() {
    return '';
  }

  void selectedChanged(String value){
    state = value;
  }
}

final selectedProvider = NotifierProvider<SelectedNotifier, String>(SelectedNotifier.new);