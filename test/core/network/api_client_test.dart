import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/network/api_client.dart';

void main() {
  test(
    'uses the configured authorization value on protected requests',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final client = container.read(apiClientProvider);
      final adapter = _RecordingAdapter();
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');
      expect(client.dio.options.receiveTimeout, const Duration(minutes: 2));

      await client.dio.get<void>(
        '/protected',
        options: Options(
          extra: {
            'secure': [
              {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
            ],
          },
        ),
      );

      expect(adapter.authorization, ['Bearer', 'test-access-token'].join(' '));
    },
  );
}

class _RecordingAdapter implements HttpClientAdapter {
  String? authorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authorization = options.headers['Authorization'] as String?;
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}
