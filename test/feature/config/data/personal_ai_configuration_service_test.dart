import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/personal_ai_configuration_service.dart';

void main() {
  test(
    'loads visible resources and identifies which ones are personal',
    () async {
      final adapter = _ConfigurationAdapter();
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final configuration = await container
          .read(personalAiConfigurationServiceProvider)
          .load();

      expect(configuration.providers, hasLength(2));
      expect(
        configuration.providers
            .singleWhere((item) => item.id == 'global-provider')
            .isOwned,
        isFalse,
      );
      expect(
        configuration.providers
            .singleWhere((item) => item.id == 'personal-provider')
            .isOwned,
        isTrue,
      );
      expect(
        configuration.models
            .singleWhere((item) => item.id == 'personal-model')
            .isOwned,
        isTrue,
      );
      expect(
        configuration.models
            .singleWhere((item) => item.id == 'global-model')
            .isOwned,
        isFalse,
      );
      expect(
        configuration.agents
            .singleWhere((item) => item.id == 'personal-agent')
            .isOwned,
        isTrue,
      );
      expect(adapter.authenticatedPaths, contains('/api/v1/ai/me/providers'));
      expect(
        adapter.authorizationHeaders,
        everyElement('Bearer test-access-token'),
      );
    },
  );
}

class _ConfigurationAdapter implements HttpClientAdapter {
  final List<String> authenticatedPaths = [];
  final List<String?> authorizationHeaders = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authenticatedPaths.add(options.path);
    authorizationHeaders.add(options.headers['Authorization'] as String?);
    final body = switch (options.path) {
      '/api/v1/ai/me/providers' => [
        _provider('personal-provider', protocol: 'openai_compatible'),
        _provider('global-provider'),
      ],
      '/api/v1/ai/me/models' => [
        _model('personal-model', 'personal-provider'),
        _model('global-model', 'global-provider'),
      ],
      '/api/v1/ai/me/agents' => [
        _agent('personal-agent'),
        _agent('global-agent'),
      ],
      '/api/v1/ai/me/agent-models' => [_link()],
      '/api/v1/ai/provider/list' => [_provider('global-provider')],
      '/api/v1/ai/agent/list' => [_agent('global-agent')],
      _ => throw StateError('Unexpected endpoint: ${options.path}'),
    };
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}

  Map<String, Object?> _provider(String id, {String protocol = 'native'}) => {
    'id': id,
    'slug': id,
    'display_name': id,
    'base_url': 'https://example.test/v1',
    'protocol': protocol,
    'is_active': true,
  };

  Map<String, Object?> _model(String id, String providerId) => {
    'id': id,
    'id_ai_provider': providerId,
    'slug': id,
    'display_name': id,
    'context_window': 4096,
    'input_token_limit': 3072,
    'output_token_limit': 1024,
    'supports_vision': false,
    'is_active': true,
  };

  Map<String, Object?> _agent(String id) => {
    'id': id,
    'alias': id,
    'task': 'manipulate_graph',
    'base_system_prompt': 'Use clear language.',
    'temperature': 0.4,
    'is_active': true,
  };

  Map<String, Object?> _link() => {
    'id': 'link-id',
    'id_agent': 'personal-agent',
    'id_ai_model': 'personal-model',
    'quality_expected': 'good',
    'custom_system_prompt': '',
    'custom_temperature': null,
    'is_active': true,
  };
}
