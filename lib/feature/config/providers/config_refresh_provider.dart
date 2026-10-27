import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void refresh() => state++;
}

final configRefreshProvider =
    NotifierProvider<ConfigRefreshNotifier, int>(ConfigRefreshNotifier.new);
