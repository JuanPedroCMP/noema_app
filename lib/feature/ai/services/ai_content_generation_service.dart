import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/service/compact_graph_context.dart';

final aiResponseLanguageResolverProvider = Provider<Future<String?> Function()>(
  (ref) {
    return () async {
      final database = ref.read(appDatabaseProvider);
      final user = await AppUserDao(database).getActiveUser();
      if (user == null) return null;
      final config = await ConfigDao(database).getConfigByUser(userId: user.id);
      if (config == null) return null;

      final order = readConfigPreference(
        config.preferences,
        responseLanguagePreferenceOrderKey,
      );
      final languageId = order is List
          ? order.whereType<String>().firstOrNull
          : null;
      if (languageId == null) return null;

      String? findLanguageName(Object? value) {
        if (value is! List) return null;
        for (final item in value) {
          if (item is Map &&
              item['id'] == languageId &&
              item['name'] is String &&
              (item['name'] as String).trim().isNotEmpty) {
            return (item['name'] as String).trim();
          }
        }
        return null;
      }

      final cachedLanguage = findLanguageName(
        readConfigPreference(config.preferences, cachedResponseLanguagesKey),
      );
      if (cachedLanguage != null) return cachedLanguage;

      final response = await ref
          .read(apiClientProvider)
          .getLanguageApi()
          .listLanguagesApiV1UserConfigLanguageListGet();
      final remoteLanguage = response.data
          ?.where((language) {
            if (languageId == fallbackPortugueseLanguageId) {
              final name = language.name.toLowerCase();
              return name.contains('portugu') || name.startsWith('pt');
            }
            if (languageId == fallbackEnglishLanguageId) {
              final name = language.name.toLowerCase();
              return name.contains('english') ||
                  name.contains('inglês') ||
                  name.startsWith('en');
            }
            return language.id == languageId;
          })
          .firstOrNull
          ?.name;
      if (remoteLanguage == null || remoteLanguage.trim().isEmpty) {
        throw StateError(
          'O idioma escolhido para respostas não está disponível na API.',
        );
      }
      return remoteLanguage.trim();
    };
  },
);

class AiContentGenerationService {
  AiContentGenerationService(this._ref);

  final Ref _ref;

  Future<List<AiAgent>> listAgents({AiAgentTask? task}) async {
    final dio = _ref.read(apiClientProvider).dio;
    final responses = await Future.wait([
      dio.get<dynamic>(
        '/api/v1/ai/me/agents',
        options: Options(
          extra: {
            'secure': [
              {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
            ],
          },
        ),
      ),
      dio.get<dynamic>('/api/v1/ai/agent/list'),
    ]);
    final personalBody = responses[0].data;
    final globalBody = responses[1].data;
    if (personalBody is! List || globalBody is! List) {
      throw const FormatException(
        'A API retornou uma lista de agentes inválida.',
      );
    }

    final globalAgents = globalBody
        .map((item) {
          if (item is! Map) {
            throw const FormatException('A API retornou um agente inválido.');
          }
          return AiAgent.fromJson(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
    final globalIds = globalAgents.map((agent) => agent.id).toSet();
    final agents = personalBody
        .map((item) {
          if (item is! Map) {
            throw const FormatException('A API retornou um agente inválido.');
          }
          final agent = AiAgent.fromJson(Map<String, dynamic>.from(item));
          return AiAgent(
            id: agent.id,
            alias: agent.alias,
            taskName: agent.taskName,
            isPersonal: !globalIds.contains(agent.id),
          );
        })
        .toList(growable: false);

    if (task == null) return agents;
    return agents
        .where(
          (agent) =>
              AiAgentTask.normalize(agent.taskName) ==
              AiAgentTask.normalize(task.wireName),
        )
        .toList(growable: false);
  }

  Future<Map<String, dynamic>> generate({
    required AiAgentTask task,
    required String prompt,
    String? agentId,
    Map<String, dynamic>? context,
    AiRequestPriority priority = AiRequestPriority.user,
  }) async {
    final normalizedPrompt = prompt.trim();
    if (normalizedPrompt.isEmpty) {
      throw ArgumentError.value(prompt, 'prompt', 'must not be empty');
    }
    final userPrompt = task == AiAgentTask.manipulateGraph
        ? normalizedPrompt
        : buildUserPrompt(prompt: normalizedPrompt, context: context);

    Future<Map<String, dynamic>> action() =>
        _generateNow(task: task, userPrompt: userPrompt, agentId: agentId);
    final queue = _ref.read(aiRequestQueueProvider);
    if (priority == AiRequestPriority.user) {
      return queue.run(priority: priority, action: action);
    }

    final concurrency = await _ref.read(aiQueueConcurrencyProvider.future);
    return queue.run(
      priority: priority,
      backgroundConcurrencyLimit: concurrency,
      action: action,
    );
  }

  Future<List<Map<String, dynamic>>> generateBatch({
    required AiAgentTask task,
    required String agentId,
    required List<String> prompts,
  }) {
    if (prompts.isEmpty) {
      throw ArgumentError.value(prompts, 'prompts', 'must not be empty');
    }
    return Future.wait(
      prompts.map(
        (prompt) => generate(task: task, prompt: prompt, agentId: agentId),
      ),
    );
  }

  Future<T> generateWithRetry<T>({
    required AiAgentTask task,
    required String prompt,
    required T Function(Map<String, dynamic> payload) parse,
    String Function(T parsed)? retryFeedback,
    String? agentId,
    Map<String, dynamic>? context,
    AiRequestPriority priority = AiRequestPriority.user,
    int maxAttempts = 2,
  }) async {
    if (maxAttempts < 1) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts', 'must be >= 1');
    }
    FormatException? lastFormatError;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final payload = await generate(
          task: task,
          prompt: prompt,
          agentId: agentId,
          context: context,
          priority: priority,
        );
        return parse(payload);
      } on FormatException catch (error) {
        lastFormatError = error;
        if (kDebugMode) {
          developer.log(
            'Resposta de IA inválida na tentativa $attempt/$maxAttempts '
            '(task=${task.wireName}): ${error.message}',
            name: 'noema.ai',
          );
        }
        if (attempt == maxAttempts) rethrow;
      }
    }
    throw lastFormatError!;
  }

  Future<String> resolveAgentId(AiAgentTask task) async {
    final matchingAgents = await listAgents(task: task);
    if (matchingAgents.isEmpty) {
      throw StateError(
        'Nenhum agente está configurado para a tarefa "${task.label}".',
      );
    }
    return matchingAgents.where((agent) => agent.isPersonal).firstOrNull?.id ??
        matchingAgents.first.id;
  }

  Future<String> generateNodeDescription({
    required String nodeId,
    required String title,
    required String type,
    required String? existingDescription,
    required String agentId,
  }) async {
    final database = _ref.read(appDatabaseProvider);
    final node = await GraphNodeDao(
      database,
    ).getGraphNode(id: nodeId);
    if (node == null || node.softDeleted) {
      throw StateError('O nó $nodeId não existe mais.');
    }
    final graphNodes = await GraphNodeDao(
      database,
    ).getGraphNodesByGraph(graphId: node.graphId);
    final graphEdges = await GraphEdgeDao(
      database,
    ).getGraphEdgesByGraph(graphId: node.graphId);
    final graphContext = compactGraphSnapshot(
      nodes: graphNodes,
      edges: graphEdges,
    ).toJson(includeNodeTypes: true, targetNodeId: nodeId);

    final prompt =
        '''
Gere uma descrição curta, correta e didática para o nó de estudo abaixo.
Retorne somente um objeto JSON com a chave "description" contendo a descrição.
Não inclua título, identificadores, markdown ou texto fora do JSON.

Nó: $title
Tipo: $type
Descrição atual (se houver): ${existingDescription?.trim().isNotEmpty == true ? existingDescription : "não informada"}

Use o mapa de conhecimento completo no contexto para delimitar o assunto,
diferenciar este nó dos conceitos próximos e respeitar pré-requisitos e
subtópicos. Descreva somente o nó alvo.
''';
    final response = await generate(
      task: AiAgentTask.generateNodeDescription,
      prompt: prompt,
      agentId: agentId,
      context: {'graph': graphContext},
      priority: AiRequestPriority.background,
    );
    final description = response['description'] ?? response['node_description'];
    if (description is! String || description.trim().isEmpty) {
      throw FormatException(
        'A IA não retornou uma descrição válida para o nó $nodeId.',
      );
    }
    return description.trim();
  }

  Future<Map<String, dynamic>> _generateNow({
    required AiAgentTask task,
    required String userPrompt,
    required String? agentId,
  }) async {
    if (kDebugMode) {
      developer.log(
        'Preparando solicitação de IA '
        '(task=${task.wireName}, promptLength=${userPrompt.length}).',
        name: 'noema.ai',
      );
    }

    final selectedAgentId = agentId ?? await resolveAgentId(task);
    if (kDebugMode) {
      developer.log(
        'Chamando API de IA (task=${task.wireName}, '
        'agentId=$selectedAgentId)',
        name: 'noema.ai',
      );
    }

    final client = _ref.read(apiClientProvider);
    final responseLanguage = await _ref.read(
      aiResponseLanguageResolverProvider,
    )();
    final response = await client.getAiRouterApi().useAiApiV1AiRouterUseAiPost(
      userPrompt: userPrompt,
      agentId: selectedAgentId,
      headers: responseLanguage == null
          ? null
          : {'X-Response-Language': responseLanguage},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('A IA retornou uma resposta vazia.');
    }

    final decoded = jsonDecode(jsonEncode(data.value));
    final payload =
        decoded is Map<String, dynamic> && decoded.containsKey('response')
        ? decoded['response']
        : decoded;
    final normalizedPayload = _decodeJsonString(payload);
    if (normalizedPayload is! Map<String, dynamic>) {
      throw const FormatException('A resposta da IA não é um objeto JSON.');
    }
    return normalizedPayload;
  }

  static String buildUserPrompt({
    required String prompt,
    Map<String, dynamic>? context,
  }) {
    final normalizedPrompt = prompt.trim();
    if (context == null || context.isEmpty) return normalizedPrompt;
    return '$normalizedPrompt\n\nContexto relevante (JSON):\n${jsonEncode(context)}';
  }

  dynamic _decodeJsonString(dynamic value) {
    if (value is! String) return value;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return value;

    try {
      return jsonDecode(trimmed);
    } on FormatException {
      // Strip markdown code fences (e.g. ```json ... ```) if present.
      final fenceMatch = RegExp(
        r'^```(?:json)?\s*([\s\S]*?)\s*```$',
        caseSensitive: false,
      ).firstMatch(trimmed);
      if (fenceMatch != null) {
        final inner = fenceMatch.group(1)!.trim();
        try {
          return jsonDecode(inner);
        } on FormatException {
          // Fall through to brace extraction.
        }
      }

      // Extract outermost JSON object if wrapped in prose.
      final start = trimmed.indexOf('{');
      final end = trimmed.lastIndexOf('}');
      if (start != -1 && end > start) {
        try {
          return jsonDecode(trimmed.substring(start, end + 1));
        } on FormatException {
          return value;
        }
      }
      return value;
    }
  }
}

final aiContentGenerationServiceProvider = Provider<AiContentGenerationService>(
  AiContentGenerationService.new,
);
