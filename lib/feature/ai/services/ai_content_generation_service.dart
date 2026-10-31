import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';

class AiContentGenerationService {
  AiContentGenerationService(this._ref);

  final Ref _ref;

  Future<List<AiAgent>> listAgents({AiAgentTask? task}) async {
    final response = await _ref
        .read(apiClientProvider)
        .dio
        .get<dynamic>(
          '/api/v1/ai/agent/list',
          options: Options(
            extra: {
              'secure': [
                {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
              ],
            },
          ),
        );
    final body = response.data;
    if (body is! List) {
      throw const FormatException(
        'A API retornou uma lista de agentes inválida.',
      );
    }

    final agents = body
        .map((item) {
          if (item is! Map) {
            throw const FormatException('A API retornou um agente inválido.');
          }
          return AiAgent.fromJson(Map<String, dynamic>.from(item));
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

    Future<Map<String, dynamic>> action() => _generateNow(
      task: task,
      userPrompt: userPrompt,
      agentId: agentId,
    );
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

  Future<String> resolveAgentId(AiAgentTask task) async {
    final matchingAgents = await listAgents(task: task);
    if (matchingAgents.isEmpty) {
      throw StateError(
        'Nenhum agente está configurado para a tarefa "${task.label}".',
      );
    }
    return matchingAgents.first.id;
  }

  Future<String> generateNodeDescription({
    required String nodeId,
    required String title,
    required String type,
    required String? existingDescription,
    required String agentId,
  }) async {
    final prompt = '''
Gere uma descrição curta, correta e didática para o nó de estudo abaixo.
Retorne somente um objeto JSON com a chave "description" contendo a descrição em português.
Não inclua título, identificadores, markdown ou texto fora do JSON.

Nó: $title
Tipo: $type
Descrição atual (se houver): ${existingDescription?.trim().isNotEmpty == true ? existingDescription : "não informada"}
''';
    final response = await generate(
      task: AiAgentTask.generateNodeDescription,
      prompt: prompt,
      agentId: agentId,
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
    final response = await client.getAiRouterApi().useAiApiV1AiRouterUseAiPost(
      userPrompt: userPrompt,
      agentId: selectedAgentId,
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
    try {
      return jsonDecode(value);
    } on FormatException {
      return value;
    }
  }
}

final aiContentGenerationServiceProvider = Provider<AiContentGenerationService>(
  AiContentGenerationService.new,
);
