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

  test('does not apply the global receive timeout to AI requests', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final client = container.read(apiClientProvider);
    final adapter = _RecordingAdapter();
    client.dio.httpClientAdapter = adapter;

    for (final path in const [
      '/api/v1/ai_router/use_ai',
      '/api/v1/ai_router/get_materials',
    ]) {
      await client.dio.post<void>(
        path,
        options: Options(
          extra: {
            'secure': [
              {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
            ],
          },
        ),
      );
    }

    expect(client.dio.options.receiveTimeout, const Duration(minutes: 2));
    expect(adapter.requestPaths, [
      '/api/v1/ai_router/use_ai',
      '/api/v1/ai_router/get_materials',
    ]);
    expect(adapter.receiveTimeouts, [Duration.zero, Duration.zero]);
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  String? authorization;
  final List<String> requestPaths = [];
  final List<Duration?> receiveTimeouts = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestPaths.add(options.path);
    receiveTimeouts.add(options.receiveTimeout);
    authorization = options.headers['Authorization'] as String?;
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}
