import 'dart:convert';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';

class AiContentGenerationService {
  AiContentGenerationService(this._ref);

  final Ref _ref;

  Future<List<AiAgent>> listAgents({AiAgentTask? task}) async {
    final response = await _ref
        .read(apiClientProvider)
        .dio
        .get<dynamic>('/api/v1/ai/agent/list');
    final body = response.data;
    if (body is! List) {
      throw const FormatException('A API retornou uma lista de agentes inválida.');
    }

    final agents = body.map((item) {
      if (item is! Map) {
        throw const FormatException('A API retornou um agente inválido.');
      }
      return AiAgent.fromJson(Map<String, dynamic>.from(item));
    }).toList(growable: false);

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
  }) async {
    final normalizedPrompt = prompt.trim();
    if (normalizedPrompt.isEmpty) {
      throw ArgumentError.value(prompt, 'prompt', 'must not be empty');
    }
    final userPrompt = buildUserPrompt(
      prompt: normalizedPrompt,
      context: context,
    );

    final matchingAgents = await listAgents(task: task);
    if (matchingAgents.isEmpty) {
      throw StateError(
        'Nenhum agente está configurado para a tarefa "${task.label}".',
      );
    }
    final agent = agentId == null
        ? matchingAgents.first
        : matchingAgents.where((candidate) => candidate.id == agentId).firstOrNull;
    if (agent == null) {
      throw ArgumentError.value(
        agentId,
        'agentId',
        'does not identify an agent for ${task.wireName}',
      );
    }

    final client = _ref.read(apiClientProvider);
    final response = await client
        .getAiRouterApi()
        .useAiApiV1AiRouterUseAiPost(
          userPrompt: userPrompt,
          agentId: agent.id,
        );
    final data = response.data;
    if (data == null) {
      throw const FormatException('A IA retornou uma resposta vazia.');
    }

    final serialized = client.serializers.serialize(
      data,
      specifiedType: const FullType(JsonObject),
    );
    final decoded = jsonDecode(jsonEncode(serialized));
    final payload = decoded is Map<String, dynamic> && decoded.containsKey('response')
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

final aiContentGenerationServiceProvider =
    Provider<AiContentGenerationService>(AiContentGenerationService.new);
