import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Exemplo de um stream que emite números a cada segundo
final serverConnectionChecker = StreamProvider<bool>((ref) async* {
  final checker = InternetConnectionChecker.createInstance(
    requireAllAddressesToRespond: true,
    addresses: [AddressCheckOption(uri: Uri.parse('https://api.tccnoema.me'))],
  );
  
  ref.onDispose(checker.dispose);

  yield await checker.hasConnection;

  await for (final status in checker.onStatusChange) {
    yield status == InternetConnectionStatus.connected;
  }
});
