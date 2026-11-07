import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';

final personalAiConfigurationServiceProvider =
    Provider<PersonalAiConfigurationService>(
      (ref) => PersonalAiConfigurationService(ref),
    );

class PersonalAiConfigurationService {
  PersonalAiConfigurationService(this._ref);

  final Ref _ref;

  Dio get _dio => _ref.read(apiClientProvider).dio;

  Options get _authenticatedOptions => Options(
    extra: {
      'secure': [
        {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
      ],
    },
  );

  Future<List<PersonalAiProvider>> listProviders() async {
    final responses = await Future.wait<Object>([
      _getList('/api/v1/ai/me/providers'),
      _getList(
        '/api/v1/ai/provider/list',
        queryParameters: const {'is_active': true},
      ),
    ]);
    final globalIds = _decodeList(
      responses[1],
      PersonalAiProvider.fromJson,
    ).map((provider) => provider.id).toSet();
    return _decodeList(responses[0], PersonalAiProvider.fromJson)
        .map(
          (provider) =>
              provider.copyWith(isOwned: !globalIds.contains(provider.id)),
        )
        .toList(growable: false);
  }

  Future<List<PersonalAiModel>> listModels() async => _decodeList(
    await _getList('/api/v1/ai/me/models'),
    PersonalAiModel.fromJson,
  );

  Future<PersonalAiConfiguration> load() async {
    final results = await Future.wait<Object>([
      _getList('/api/v1/ai/me/providers'),
      _getList('/api/v1/ai/me/models'),
      _getList('/api/v1/ai/me/agents'),
      _getList('/api/v1/ai/me/agent-models'),
      _getList(
        '/api/v1/ai/provider/list',
        queryParameters: const {'is_active': true},
      ),
      _getList('/api/v1/ai/agent/list'),
    ]);

    final globalProviderIds = _decodeList(
      results[4],
      PersonalAiProvider.fromJson,
    ).map((provider) => provider.id).toSet();
    final globalAgentIds = _decodeList(
      results[5],
      PersonalAiAgent.fromJson,
    ).map((agent) => agent.id).toSet();

    final providers = _decodeList(results[0], PersonalAiProvider.fromJson)
        .map(
          (provider) => provider.copyWith(
            isOwned: !globalProviderIds.contains(provider.id),
          ),
        )
        .toList();
    final ownedProviderIds = providers
        .where((provider) => provider.isOwned)
        .map((provider) => provider.id)
        .toSet();
    final agents = _decodeList(results[2], PersonalAiAgent.fromJson)
        .map(
          (agent) =>
              agent.copyWith(isOwned: !globalAgentIds.contains(agent.id)),
        )
        .toList();

    return PersonalAiConfiguration(
      providers: providers,
      models: _decodeList(results[1], PersonalAiModel.fromJson)
          .map(
            (model) => model.copyWith(
              isOwned: ownedProviderIds.contains(model.providerId),
            ),
          )
          .toList(),
      agents: agents,
      agentModels: _decodeList(results[3], PersonalAiAgentModel.fromJson),
    );
  }

  Future<PersonalAiProvider> createProvider({
    required String slug,
    required String displayName,
    required String baseUrl,
  }) => _send(
    'POST',
    '/api/v1/ai/me/providers',
    data: {
      'slug': slug,
      'display_name': displayName,
      'base_url': baseUrl,
      'protocol': 'openai_compatible',
    },
    decode: PersonalAiProvider.fromJson,
  );

  Future<PersonalAiProvider> updateProvider(
    String id,
    Map<String, Object?> data,
  ) => _send(
    'PUT',
    '/api/v1/ai/me/providers/$id',
    data: data,
    decode: PersonalAiProvider.fromJson,
  );

  Future<void> deleteProvider(String id) =>
      _delete('/api/v1/ai/me/providers/$id');

  Future<PersonalAiModel> createModel(Map<String, Object?> data) => _send(
    'POST',
    '/api/v1/ai/me/models',
    data: data,
    decode: PersonalAiModel.fromJson,
  );

  Future<PersonalAiModel> updateModel(String id, Map<String, Object?> data) =>
      _send(
        'PUT',
        '/api/v1/ai/me/models/$id',
        data: data,
        decode: PersonalAiModel.fromJson,
      );

  Future<void> deleteModel(String id) => _delete('/api/v1/ai/me/models/$id');

  Future<PersonalAiAgent> createAgent(Map<String, Object?> data) => _send(
    'POST',
    '/api/v1/ai/me/agents',
    data: data,
    decode: PersonalAiAgent.fromJson,
  );

  Future<PersonalAiAgent> updateAgent(String id, Map<String, Object?> data) =>
      _send(
        'PUT',
        '/api/v1/ai/me/agents/$id',
        data: data,
        decode: PersonalAiAgent.fromJson,
      );

  Future<void> deleteAgent(String id) => _delete('/api/v1/ai/me/agents/$id');

  Future<PersonalAiAgentModel> createAgentModel(Map<String, Object?> data) =>
      _send(
        'POST',
        '/api/v1/ai/me/agent-models',
        data: data,
        decode: PersonalAiAgentModel.fromJson,
      );

  Future<PersonalAiAgentModel> updateAgentModel(
    String id,
    Map<String, Object?> data,
  ) => _send(
    'PUT',
    '/api/v1/ai/me/agent-models/$id',
    data: data,
    decode: PersonalAiAgentModel.fromJson,
  );

  Future<void> deleteAgentModel(String id) =>
      _delete('/api/v1/ai/me/agent-models/$id');

  Future<List<Object?>> _getList(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    final response = await _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
      options: _authenticatedOptions,
    );
    final body = response.data;
    if (body is! List) {
      throw const FormatException('A API retornou uma lista inválida.');
    }
    return List<Object?>.from(body);
  }

  List<T> _decodeList<T>(
    Object? body,
    T Function(Map<String, dynamic>) decode,
  ) {
    if (body is! List<Object?>) {
      throw const FormatException('A API retornou uma lista inválida.');
    }
    return body
        .map((item) {
          if (item is! Map) {
            throw const FormatException('A API retornou um item inválido.');
          }
          return decode(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
  }

  Future<T> _send<T>(
    String method,
    String path, {
    required Map<String, Object?> data,
    required T Function(Map<String, dynamic>) decode,
  }) async {
    final response = await _dio.request<Object?>(
      path,
      data: data,
      options: _authenticatedOptions.copyWith(method: method),
    );
    final body = response.data;
    if (body is! Map) {
      throw const FormatException('A API não confirmou a alteração.');
    }
    return decode(Map<String, dynamic>.from(body));
  }

  Future<void> _delete(String path) async {
    await _dio.delete<Object?>(path, options: _authenticatedOptions);
  }
}

class PersonalAiConfiguration {
  const PersonalAiConfiguration({
    required this.providers,
    required this.models,
    required this.agents,
    required this.agentModels,
  });

  final List<PersonalAiProvider> providers;
  final List<PersonalAiModel> models;
  final List<PersonalAiAgent> agents;
  final List<PersonalAiAgentModel> agentModels;
}

class PersonalAiProvider {
  const PersonalAiProvider({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.baseUrl,
    required this.protocol,
    required this.isActive,
    this.isOwned = false,
  });

  final String id;
  final String slug;
  final String displayName;
  final String? baseUrl;
  final String protocol;
  final bool isActive;
  final bool isOwned;

  PersonalAiProvider copyWith({bool? isOwned}) => PersonalAiProvider(
    id: id,
    slug: slug,
    displayName: displayName,
    baseUrl: baseUrl,
    protocol: protocol,
    isActive: isActive,
    isOwned: isOwned ?? this.isOwned,
  );

  factory PersonalAiProvider.fromJson(Map<String, dynamic> json) =>
      PersonalAiProvider(
        id: _stringField(json, 'id'),
        slug: _stringField(json, 'slug'),
        displayName: _stringField(json, 'display_name'),
        baseUrl: json['base_url'] as String?,
        protocol: json['protocol'] is String
            ? json['protocol'] as String
            : 'native',
        isActive: json['is_active'] != false,
      );
}

class PersonalAiModel {
  const PersonalAiModel({
    required this.id,
    required this.providerId,
    required this.slug,
    required this.displayName,
    required this.contextWindow,
    required this.inputTokenLimit,
    required this.outputTokenLimit,
    required this.supportsVision,
    required this.isActive,
    this.isOwned = false,
  });

  final String id;
  final String providerId;
  final String slug;
  final String displayName;
  final int? contextWindow;
  final int? inputTokenLimit;
  final int? outputTokenLimit;
  final bool supportsVision;
  final bool isActive;
  final bool isOwned;

  PersonalAiModel copyWith({bool? isOwned}) => PersonalAiModel(
    id: id,
    providerId: providerId,
    slug: slug,
    displayName: displayName,
    contextWindow: contextWindow,
    inputTokenLimit: inputTokenLimit,
    outputTokenLimit: outputTokenLimit,
    supportsVision: supportsVision,
    isActive: isActive,
    isOwned: isOwned ?? this.isOwned,
  );

  factory PersonalAiModel.fromJson(Map<String, dynamic> json) =>
      PersonalAiModel(
        id: _stringField(json, 'id'),
        providerId: _stringField(json, 'id_ai_provider'),
        slug: _stringField(json, 'slug'),
        displayName: _stringField(json, 'display_name'),
        contextWindow: _intField(json, 'context_window'),
        inputTokenLimit: _intField(json, 'input_token_limit'),
        outputTokenLimit: _intField(json, 'output_token_limit'),
        supportsVision: json['supports_vision'] == true,
        isActive: json['is_active'] != false,
      );
}

class PersonalAiAgent {
  const PersonalAiAgent({
    required this.id,
    required this.alias,
    required this.task,
    required this.baseSystemPrompt,
    required this.temperature,
    required this.isActive,
    this.isOwned = false,
  });

  final String id;
  final String alias;
  final String task;
  final String baseSystemPrompt;
  final num? temperature;
  final bool isActive;
  final bool isOwned;

  PersonalAiAgent copyWith({bool? isOwned}) => PersonalAiAgent(
    id: id,
    alias: alias,
    task: task,
    baseSystemPrompt: baseSystemPrompt,
    temperature: temperature,
    isActive: isActive,
    isOwned: isOwned ?? this.isOwned,
  );

  factory PersonalAiAgent.fromJson(Map<String, dynamic> json) =>
      PersonalAiAgent(
        id: _stringField(json, 'id'),
        alias: _stringField(json, 'alias'),
        task: _stringField(json, 'task'),
        baseSystemPrompt: _stringField(json, 'base_system_prompt'),
        temperature: json['temperature'] as num?,
        isActive: json['is_active'] != false,
      );
}

class PersonalAiAgentModel {
  const PersonalAiAgentModel({
    required this.id,
    required this.agentId,
    required this.modelId,
    required this.qualityExpected,
    required this.customSystemPrompt,
    required this.temperature,
    required this.isActive,
  });

  final String id;
  final String agentId;
  final String modelId;
  final String? qualityExpected;
  final String customSystemPrompt;
  final num? temperature;
  final bool isActive;

  factory PersonalAiAgentModel.fromJson(Map<String, dynamic> json) =>
      PersonalAiAgentModel(
        id: _stringField(json, 'id'),
        agentId: _stringField(json, 'id_agent'),
        modelId: _stringField(json, 'id_ai_model'),
        qualityExpected: json['quality_expected'] as String?,
        customSystemPrompt: json['custom_system_prompt'] is String
            ? json['custom_system_prompt'] as String
            : '',
        temperature: json['custom_temperature'] as num?,
        isActive: json['is_active'] != false,
      );
}

String _stringField(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('A API retornou um valor inválido para "$key".');
  }
  return value;
}

int? _intField(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is int) return value;
  throw FormatException('A API retornou um valor inválido para "$key".');
}

String personalAiErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail;
      if (detail is Map) {
        final message = detail['message'];
        if (message is String && message.trim().isNotEmpty) return message;
        final code = detail['code'];
        if (code is String && code.trim().isNotEmpty) return code;
      }
      if (detail is List && detail.isNotEmpty && detail.first is Map) {
        final message = (detail.first as Map)['msg'];
        if (message is String && message.trim().isNotEmpty) {
          return 'Verifique os dados informados: $message';
        }
      }
    }
    if (error.response?.statusCode == 401) {
      return 'Sua sessão expirou. Entre novamente para gerenciar suas configurações de IA.';
    }
    if (error.response?.statusCode == 403) {
      return 'A API recusou esta alteração. Verifique se o recurso pertence à sua conta.';
    }
  }
  if (error is FormatException) return error.message;
  return 'Não foi possível concluir a operação. Verifique a conexão e tente novamente.';
}
