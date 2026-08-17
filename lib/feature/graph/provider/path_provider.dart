import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PathNotifier extends Notifier<(List<Path>, List<String>)> {

  @override
  (List<Path>, List<String>) build() {
    return  const (<Path>[], <String>[]);
  }

  void listPathChanged((List<Path>, List<String>) value){
    state = value;
  }
}

final pathProvider = NotifierProvider<PathNotifier, (List<Path>, List<String>)>(PathNotifier.new);