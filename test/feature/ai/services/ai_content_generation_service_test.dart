import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart';

void main() {
  test(
    'posts the selected agent and prompt, then waits for the response',
    () async {
      const agentId = 'c85e5671-a9bb-4c68-9734-3b8f492e5aff';
      const prompt = 'quero aprender Biologia básica';
      final postStarted = Completer<void>();
      final postResponse = Completer<ResponseBody>();
      final adapter = _AiApiAdapter(
        agentId: agentId,
        prompt: prompt,
        postStarted: postStarted,
        postResponse: postResponse,
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      var generationFinished = false;
      final generation = container
          .read(aiContentGenerationServiceProvider)
          .generate(task: AiAgentTask.manipulateGraph, prompt: '  $prompt  ')
          .whenComplete(() => generationFinished = true);

      await postStarted.future;
      expect(generationFinished, isFalse);
      expect(adapter.requestPaths, [
        '/api/v1/ai/agent/list',
        '/api/v1/ai_router/use_ai',
      ]);
      expect(adapter.postMethod, 'POST');
      final requestUri = Uri.parse(adapter.postUri!);
      expect(requestUri.path, '/api/v1/ai_router/use_ai');
      expect(requestUri.queryParameters, {
        'user_prompt': prompt,
        'agent_id': agentId,
      });
      expect(adapter.postQueryParameters, {
        'user_prompt': prompt,
        'agent_id': agentId,
      });
      expect(
        adapter.postAuthorization,
        ['Bearer', 'test-access-token'].join(' '),
      );
      expect(
        adapter.agentListAuthorization,
        ['Bearer', 'test-access-token'].join(' '),
      );

      postResponse.complete(
        _jsonResponse({
          'graph_title': 'Biologia Básica',
          'nodes': [
            {'node_id': 1, 'title': 'Biologia', 'type': 'AREA'},
            {'node_id': 2, 'title': 'Biologia básica', 'type': 'TOPIC'},
          ],
          'edges': [
            {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
          ],
        }),
      );

      final result = await generation;
      final graph = GraphResponse.fromJson(result);
      graph.validate();
      expect(graph.graphTitle, 'Biologia Básica');
      expect(graph.nodes, hasLength(2));
      expect(graph.edges, hasLength(1));
      expect(generationFinished, isTrue);
    },
  );

  test(
    'uses the supplied graph agent without fetching the agent list',
    () async {
      const agentId = 'c85e5671-a9bb-4c68-9734-3b8f492e5aff';
      const prompt = 'quero aprender Biologia básica';
      final postStarted = Completer<void>();
      final postResponse = Completer<ResponseBody>();
      final adapter = _AiApiAdapter(
        agentId: agentId,
        prompt: prompt,
        postStarted: postStarted,
        postResponse: postResponse,
        rejectAgentList: true,
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final generation = container
          .read(aiContentGenerationServiceProvider)
          .generate(
            task: AiAgentTask.manipulateGraph,
            prompt: prompt,
            agentId: agentId,
            context: const {'must_not_be_sent': true},
          );

      await postStarted.future;
      expect(adapter.requestPaths, ['/api/v1/ai_router/use_ai']);
      expect(adapter.postQueryParameters, {
        'user_prompt': prompt,
        'agent_id': agentId,
      });

      postResponse.complete(
        _jsonResponse({
          'graph_title': 'Biologia Básica',
          'nodes': [
            {'node_id': 1, 'title': 'Biologia', 'type': 'AREA'},
            {'node_id': 2, 'title': 'Biologia básica', 'type': 'TOPIC'},
          ],
          'edges': [
            {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
          ],
        }),
      );
      final graph = GraphResponse.fromJson(await generation);
      graph.validate();
      expect(graph.graphTitle, 'Biologia Básica');
    },
  );

  test('generates node descriptions through the background request queue', () async {
    final adapter = _NodeDescriptionAdapter();
    final container = ProviderContainer(
      overrides: [
        aiQueueConcurrencyProvider.overrideWith(
          _TestConcurrencyNotifier.new,
        ),
      ],
    );
    addTearDown(container.dispose);

    final client = container.read(apiClientProvider);
    client.dio.httpClientAdapter = adapter;
    setApiAccessToken(client, 'test-access-token');

    final description = await container
        .read(aiContentGenerationServiceProvider)
        .generateNodeDescription(
          nodeId: 'node-id',
          title: 'Fotossíntese',
          type: 'CONCEPT',
          existingDescription: null,
          agentId: 'description-agent-id',
        );

    expect(description, 'Processo pelo qual plantas convertem luz em energia.');
    expect(adapter.requestPath, '/api/v1/ai_router/use_ai');
    expect(adapter.method, 'POST');
    expect(adapter.queryParameters['agent_id'], 'description-agent-id');
    expect(
      adapter.queryParameters['user_prompt'],
      contains('Fotossíntese'),
    );
    expect(adapter.authorization, ['Bearer', 'test-access-token'].join(' '));
    expect(container.read(aiRequestQueueProvider).activeBackgroundRequests, 0);
  });
}

class _AiApiAdapter implements HttpClientAdapter {
  _AiApiAdapter({
    required this.agentId,
    required this.prompt,
    required this.postStarted,
    required this.postResponse,
    this.rejectAgentList = false,
  });

  final String agentId;
  final String prompt;
  final Completer<void> postStarted;
  final Completer<ResponseBody> postResponse;
  final bool rejectAgentList;

  final List<String> requestPaths = [];
  String? postMethod;
  String? postUri;
  Map<String, dynamic>? postQueryParameters;
  String? postAuthorization;
  String? agentListAuthorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestPaths.add(options.path);
    if (options.path == '/api/v1/ai/agent/list') {
      agentListAuthorization = options.headers['Authorization'] as String?;
      if (rejectAgentList) {
        throw StateError('The graph flow must not fetch the agent list.');
      }
      return _jsonResponse([
        {
          'id': 'another-task-agent',
          'alias': 'flashcard-agent',
          'task': 'create_flashcard',
        },
        {'id': agentId, 'alias': 'graph-agent', 'task': 'manipulate_graph'},
      ]);
    }

    postMethod = options.method;
    postUri = options.uri.toString();
    postQueryParameters = Map<String, dynamic>.from(options.queryParameters);
    postAuthorization = options.headers['Authorization'] as String?;
    expect(prompt, options.queryParameters['user_prompt']);
    postStarted.complete();
    return postResponse.future;
  }

  @override
  void close({bool force = false}) {}
}

class _TestConcurrencyNotifier extends AiQueueConcurrencyNotifier {
  @override
  Future<int> build() async => 2;
}

class _NodeDescriptionAdapter implements HttpClientAdapter {
  String? requestPath;
  String? method;
  Map<String, dynamic> queryParameters = {};
  String? authorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestPath = options.path;
    method = options.method;
    queryParameters = Map<String, dynamic>.from(options.queryParameters);
    authorization = options.headers['Authorization'] as String?;
    return _jsonResponse({
      'description': 'Processo pelo qual plantas convertem luz em energia.',
    });
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(Object body) => ResponseBody.fromString(
  jsonEncode(body),
  200,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);
