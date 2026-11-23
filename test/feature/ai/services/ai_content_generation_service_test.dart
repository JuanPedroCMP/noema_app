import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart';

void main() {
  test('matches the backend task name for the study assistant', () {
    expect(AiAgentTask.studyAssistant.wireName, 'study_assistent');
  });

  test('accepts graphs larger than 30 nodes', () {
    final response = GraphResponse.fromJson({
      'graph_title': 'Grafo grande',
      'graph_description': 'Teste sem limite artificial',
      'nodes': [
        for (var index = 1; index <= 31; index++)
          {'node_id': index, 'title': 'Nó $index', 'type': 'TOPIC'},
      ],
      'edges': const [],
    });

    response.validate();

    expect(response.nodes, hasLength(31));
  });

  test(
    'does not wait for remote auth/config loading to resolve response language',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database
          .into(database.appUser)
          .insert(
            AppUserCompanion.insert(
              id: 'local-user',
              remoteId: 'remote-user',
              userName: 'student',
              displayName: 'Student',
              primaryEmail: 'student@example.com',
              lastSeenAt: 0,
              isActive: const drift.Value(true),
            ),
          );
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          userProvider.overrideWith(_UnexpectedUserNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final language = await container.read(
        aiResponseLanguageResolverProvider,
      )();

      expect(language, null);
    },
  );

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
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => 'English',
          ),
        ],
      );
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
        '/api/v1/ai/me/agents',
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
      expect(adapter.responseLanguageHeader, 'English');
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
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
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

  test(
    'generates a batch with the supplied agent and preserves prompt order',
    () async {
      final adapter = _AiBatchAdapter();
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
      addTearDown(container.dispose);

      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final results = await container
          .read(aiContentGenerationServiceProvider)
          .generateBatch(
            task: AiAgentTask.createEssayQuestion,
            agentId: 'essay-agent-id',
            prompts: const ['first prompt', 'second prompt'],
          );

      expect(results, hasLength(2));
      expect(results[0]['prompt'], contains('first prompt'));
      expect(results[1]['prompt'], contains('second prompt'));
      expect(adapter.agentIds, ['essay-agent-id', 'essay-agent-id']);
      expect(adapter.prompts, hasLength(2));
    },
  );

  test(
    'generates node descriptions through the background request queue',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database
          .into(database.appUser)
          .insert(
            AppUserCompanion.insert(
              id: 'user-id',
              remoteId: 'remote-user-id',
              userName: 'student',
              displayName: 'Student',
              primaryEmail: 'student@example.com',
              lastSeenAt: 0,
            ),
          );
      await database
          .into(database.knowledgeGraph)
          .insert(
            KnowledgeGraphCompanion.insert(
              id: 'graph-id',
              userId: 'user-id',
              title: 'Biologia',
            ),
          );
      await database
          .into(database.graphNode)
          .insert(
            GraphNodeCompanion.insert(
              id: 'node-id',
              graphId: 'graph-id',
              type: 'CONCEPT',
              title: 'Fotossíntese',
              positionX: 0,
              positionY: 0,
            ),
          );
      final adapter = _NodeDescriptionAdapter();
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          aiQueueConcurrencyProvider.overrideWith(_TestConcurrencyNotifier.new),
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
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

      expect(
        description,
        'Processo pelo qual plantas convertem luz em energia.',
      );
      expect(adapter.requestPath, '/api/v1/ai_router/use_ai');
      expect(adapter.method, 'POST');
      expect(adapter.queryParameters['agent_id'], 'description-agent-id');
      expect(adapter.queryParameters['user_prompt'], contains('Fotossíntese'));
      expect(
        adapter.queryParameters['user_prompt'],
        contains('não a preserve nem apenas a parafraseie'),
      );
      expect(
        adapter.queryParameters['user_prompt'],
        isNot(contains('português')),
      );
      expect(adapter.authorization, ['Bearer', 'test-access-token'].join(' '));
      expect(
        container.read(aiRequestQueueProvider).activeBackgroundRequests,
        0,
      );
    },
  );

  test(
    'repairs hierarchical cycles, self-loops, and invalid edges in GraphResponse',
    () {
      final response = GraphResponse.fromJson({
        'graph_title': '',
        'graph_description': 'Biologia para o ENEM',
        'nodes': [
          {'node_id': '1', 'title': 'Biologia', 'type': 'AREA'},
          {'node_id': 2, 'title': 'Citologia', 'type': 'TOPIC'},
          {'node_id': 2, 'title': 'Duplicado', 'type': 'TOPIC'},
        ],
        'edges': [
          {'source_node': 2, 'target_node': 1, 'type': 'SUBTOPIC'},
          // Cycle: 1 is also SUBTOPIC of 2
          {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
          // Self-loop and dangling edge
          {'source_node': 1, 'target_node': 1, 'type': 'PREREQUISITE'},
          {'source_node': 1, 'target_node': 99, 'type': 'SUBTOPIC'},
        ],
      });

      final repaired = response.repair();
      repaired.validate();

      expect(repaired.graphTitle, 'Biologia para o ENEM');
      expect(repaired.nodes, hasLength(2));
      expect(repaired.edges, hasLength(1));
      expect(repaired.edges.single.sourceNode, 2);
      expect(repaired.edges.single.targetNode, 1);
    },
  );

  test(
    'extracts JSON from markdown fences and retries on invalid response',
    () async {
      final adapter = _RetryAdapter();
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
      addTearDown(container.dispose);

      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final graph = await container
          .read(aiContentGenerationServiceProvider)
          .generateWithRetry<GraphResponse>(
            task: AiAgentTask.manipulateGraph,
            prompt: 'Biologia',
            agentId: 'graph-agent',
            maxAttempts: 2,
            parse: (payload) {
              final g = GraphResponse.fromJson(payload).repair();
              final fatalProblems = g
                  .validate()
                  .where((problem) => problem.fatal)
                  .toList();
              if (fatalProblems.isNotEmpty) {
                throw FormatException(
                  fatalProblems.map((problem) => problem.message).join('\n'),
                );
              }
              return g;
            },
          );

      expect(adapter.attempts, 2);
      expect(
        adapter.prompts.last,
        contains('A IA não gerou nenhum nó para o grafo.'),
      );
      expect(
        adapter.prompts.last,
        contains('Preserve valid content and fix every reported issue.'),
      );
      expect(graph.graphTitle, 'Biologia');
      expect(graph.nodes, hasLength(1));
    },
  );

  test('retries once with structured graph-quality feedback', () async {
    final adapter = _GraphFeedbackAdapter();
    final container = ProviderContainer(
      overrides: [
        aiResponseLanguageResolverProvider.overrideWithValue(() async => null),
      ],
    );
    addTearDown(container.dispose);
    final client = container.read(apiClientProvider);
    client.dio.httpClientAdapter = adapter;
    setApiAccessToken(client, 'test-access-token');

    final graph = await container
        .read(aiContentGenerationServiceProvider)
        .generateWithRetry<GraphResponse>(
          task: AiAgentTask.manipulateGraph,
          prompt: 'MODE: CREATE\nÁlgebra',
          agentId: 'graph-agent',
          maxAttempts: 2,
          parse: (payload) {
            final result = GraphResponse.fromJson(payload).repair();
            final fatalProblems = result
                .validate()
                .where((problem) => problem.fatal)
                .toList();
            if (fatalProblems.isNotEmpty) {
              throw FormatException(
                fatalProblems.map((problem) => problem.message).join('\n'),
              );
            }
            return result;
          },
          retryFeedback: (result) => result
              .validate()
              .where((problem) => problem.retryable)
              .map(
                (problem) =>
                    '- ${problem.code} [nós: ${problem.nodeIds.join(', ')}]: '
                    '${problem.message}',
              )
              .join('\n'),
        );

    expect(adapter.prompts, hasLength(2));
    expect(adapter.prompts.first, 'MODE: CREATE\nÁlgebra');
    expect(
      adapter.prompts.last,
      contains('não é foundation e não tem pré-requisito'),
    );
    expect(
      adapter.prompts.last,
      contains('leaf_without_prerequisite [nós: 2]'),
    );
    expect(adapter.prompts.last, contains('missing_scope_plan'));
    expect(adapter.prompts.last, contains('missing_coverage_map'));
    final prerequisite = graph.edges.singleWhere(
      (edge) => edge.type == 'PREREQUISITE',
    );
    expect(prerequisite.sourceNode, 1);
    expect(prerequisite.targetNode, 2);
    expect(graph.validate().where((problem) => problem.retryable), isEmpty);
  });

  test(
    'generates the graph through one server-side pipeline request',
    () async {
      final adapter = _ServerGraphPipelineAdapter();
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
      addTearDown(container.dispose);
      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final service = container.read(aiContentGenerationServiceProvider);
      final graph = await service.generateGraphWithServerPipeline(
        prompt: 'Aprender a treinar e avaliar modelos',
        agentId: 'graph-agent',
      );

      expect(adapter.prompts, hasLength(1));
      expect(adapter.prompts.single, startsWith('MODE: SERVER_CREATE\n'));
      expect(adapter.prompts.single, contains('Aprender a treinar'));
      expect(graph.blueprint?.outcomes, hasLength(2));
      expect(graph.toJson().containsKey('blueprint'), isFalse);
      expect(graph.validate().where((problem) => problem.retryable), isEmpty);
    },
  );

  test(
    'accepts the server-approved single foundation prerequisite warning',
    () async {
      final adapter = _ServerGraphPipelineAdapter(
        includeFoundationPrerequisiteWarning: true,
      );
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
      addTearDown(container.dispose);
      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final graph = await container
          .read(aiContentGenerationServiceProvider)
          .generateGraphWithServerPipeline(
            prompt: 'Aprender a treinar e avaliar modelos',
            agentId: 'graph-agent',
          );

      expect(
        graph.validate().map((problem) => problem.code),
        ['foundation_has_prerequisite'],
      );
      expect(graph.hasCoverageAuditProblems, isFalse);
    },
  );

  test(
    'accepts a marked server fallback with non-fatal coverage warnings',
    () async {
      final adapter = _ServerGraphPipelineAdapter(
        qualityFallback: true,
        omitCoverageMap: true,
      );
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
      addTearDown(container.dispose);
      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      final graph = await container
          .read(aiContentGenerationServiceProvider)
          .generateGraphWithServerPipeline(
            prompt: 'Aprender a treinar e avaliar modelos',
            agentId: 'graph-agent',
          );

      expect(graph.qualityFallback, isTrue);
      expect(graph.hasCoverageAuditProblems, isTrue);
      expect(graph.blocksSaveForCoverage, isFalse);
      expect(graph.toJson().containsKey('quality_fallback'), isFalse);
    },
  );

  test('rejects a marked fallback that cannot produce a usable graph', () async {
    final adapter = _ServerGraphPipelineAdapter(
      qualityFallback: true,
      emptyNodes: true,
    );
    final container = ProviderContainer(
      overrides: [
        aiResponseLanguageResolverProvider.overrideWithValue(
          () async => null,
        ),
      ],
    );
    addTearDown(container.dispose);
    final client = container.read(apiClientProvider);
    client.dio.httpClientAdapter = adapter;
    setApiAccessToken(client, 'test-access-token');

    await expectLater(
      container
          .read(aiContentGenerationServiceProvider)
          .generateGraphWithServerPipeline(
            prompt: 'Aprender a treinar e avaliar modelos',
            agentId: 'graph-agent',
          ),
      throwsA(isA<FormatException>()),
    );
  });

  test(
    'still rejects a server response with another quality warning',
    () async {
      final adapter = _ServerGraphPipelineAdapter(
        includeFoundationPrerequisiteWarning: true,
        omitDependentObjective: true,
      );
      final container = ProviderContainer(
        overrides: [
          aiResponseLanguageResolverProvider.overrideWithValue(
            () async => null,
          ),
        ],
      );
      addTearDown(container.dispose);
      final client = container.read(apiClientProvider);
      client.dio.httpClientAdapter = adapter;
      setApiAccessToken(client, 'test-access-token');

      await expectLater(
        container
            .read(aiContentGenerationServiceProvider)
            .generateGraphWithServerPipeline(
              prompt: 'Aprender a treinar e avaliar modelos',
              agentId: 'graph-agent',
            ),
        throwsA(isA<FormatException>()),
      );
    },
  );
}

class _UnexpectedUserNotifier extends UserNotifier {
  @override
  Future<AppUserData> build() async {
    throw StateError('AI language resolution must not wait for auth state.');
  }
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
  String? responseLanguageHeader;
  String? agentListAuthorization;
  String? globalAgentListAuthorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestPaths.add(options.path);
    if (options.path == '/api/v1/ai/me/agents') {
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
    if (options.path == '/api/v1/ai/agent/list') {
      globalAgentListAuthorization =
          options.headers['Authorization'] as String?;
      return _jsonResponse([
        {
          'id': 'another-task-agent',
          'alias': 'global-flashcard-agent',
          'task': 'create_flashcard',
        },
        {
          'id': 'global-graph-agent',
          'alias': 'global-graph-agent',
          'task': 'manipulate_graph',
        },
      ]);
    }

    postMethod = options.method;
    postUri = options.uri.toString();
    postQueryParameters = Map<String, dynamic>.from(options.queryParameters);
    postAuthorization = options.headers['Authorization'] as String?;
    responseLanguageHeader = options.headers['X-Response-Language'] as String?;
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

class _AiBatchAdapter implements HttpClientAdapter {
  final List<String> agentIds = [];
  final List<String> prompts = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final agentId = options.queryParameters['agent_id'] as String;
    final prompt = options.queryParameters['user_prompt'] as String;
    agentIds.add(agentId);
    prompts.add(prompt);
    return _jsonResponse({'prompt': prompt});
  }

  @override
  void close({bool force = false}) {}
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

class _RetryAdapter implements HttpClientAdapter {
  int attempts = 0;
  final List<String> prompts = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    attempts++;
    prompts.add(options.queryParameters['user_prompt'] as String);
    if (attempts == 1) {
      // First attempt returns empty nodes (unrepairable).
      return _jsonResponse({'graph_title': 'Vazio', 'nodes': [], 'edges': []});
    }
    // Second attempt returns markdown-fenced JSON.
    return _jsonResponse({
      'response':
          '```json\n{"graph_title":"Biologia","nodes":[{"node_id":1,"title":"Célula","type":"CONCEPT"}],"edges":[]}\n```',
    });
  }

  @override
  void close({bool force = false}) {}
}

class _GraphFeedbackAdapter implements HttpClientAdapter {
  final List<String> prompts = [];
  var attempts = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    prompts.add(options.queryParameters['user_prompt'] as String);
    attempts++;
    if (attempts == 1) {
      return _jsonResponse({
        'graph_title': 'Álgebra',
        'nodes': [
          {'node_id': 10, 'title': 'Matemática', 'type': 'AREA'},
          {'node_id': 11, 'title': 'Álgebra', 'type': 'TOPIC'},
          {
            'node_id': 1,
            'title': 'Aritmética',
            'type': 'CONCEPT',
            'level': 'foundation',
            'description': 'Resolver operações aritméticas básicas.',
          },
          {
            'node_id': 2,
            'title': 'Equações',
            'type': 'CONCEPT',
            'level': 'core',
            'description': 'Resolver equações algébricas simples.',
          },
        ],
        'edges': [],
      });
    }
    return _jsonResponse({
      'graph_title': 'Álgebra',
      'plan':
          'Ensinar operações aritméticas e resolver equações simples, '
          'partindo de fundamentos de aritmética.',
      'coverage': [
        {
          'outcome': 'Resolver operações aritméticas básicas.',
          'node_ids': [1],
        },
        {
          'outcome': 'Resolver equações algébricas simples.',
          'node_ids': [2],
        },
      ],
      'nodes': [
        {'node_id': 10, 'title': 'Matemática', 'type': 'AREA'},
        {'node_id': 11, 'title': 'Álgebra', 'type': 'TOPIC'},
        {
          'node_id': 1,
          'title': 'Aritmética',
          'type': 'CONCEPT',
          'level': 'foundation',
          'description': 'Resolver operações aritméticas básicas.',
        },
        {
          'node_id': 2,
          'title': 'Equações',
          'type': 'CONCEPT',
          'level': 'core',
          'description': 'Resolver equações algébricas simples.',
        },
      ],
      'edges': [
        {'source_node': 10, 'target_node': 11, 'type': 'SUBTOPIC'},
        {'source_node': 11, 'target_node': 1, 'type': 'SUBTOPIC'},
        {'source_node': 11, 'target_node': 2, 'type': 'SUBTOPIC'},
        {
          'source_node': 1,
          'target_node': 2,
          'type': 'PREREQUISITE',
          'weight': 1.0,
        },
      ],
    });
  }

  @override
  void close({bool force = false}) {}
}

class _ServerGraphPipelineAdapter implements HttpClientAdapter {
  _ServerGraphPipelineAdapter({
    this.includeFoundationPrerequisiteWarning = false,
    this.omitDependentObjective = false,
    this.qualityFallback = false,
    this.omitCoverageMap = false,
    this.emptyNodes = false,
  });

  final bool includeFoundationPrerequisiteWarning;
  final bool omitDependentObjective;
  final bool qualityFallback;
  final bool omitCoverageMap;
  final bool emptyNodes;
  final List<String> prompts = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final prompt = options.queryParameters['user_prompt'] as String;
    prompts.add(prompt);
    return _jsonResponse({
      'graph_description': 'Treino e avaliação de modelos.',
      'graph_title': 'Treino e avaliação',
      'plan': 'Preparar entradas e avaliar as previsões.',
      if (qualityFallback) 'quality_fallback': true,
      'blueprint': {
        'scope': 'Treinar um modelo e avaliar suas previsões.',
        'assumptions': [],
        'prior_knowledge': [],
        'outcomes': [
          {
            'id': 'outcome_1',
            'outcome': 'Prepare model inputs.',
            'evidence': 'Transformar um conjunto pequeno em atributos.',
            'prerequisite_ids': [],
          },
          {
            'id': 'outcome_2',
            'outcome': 'Evaluate model predictions.',
            'evidence': 'Comparar previsões com uma linha de base.',
            'prerequisite_ids': ['outcome_1'],
          },
        ],
      },
      if (!omitCoverageMap)
        'coverage': [
          {
            'outcome_id': 'outcome_1',
            'outcome': 'Prepare model inputs.',
            'node_ids': [3],
          },
          {
            'outcome_id': 'outcome_2',
            'outcome': 'Evaluate model predictions.',
            'node_ids': [4],
          },
        ],
      'nodes': [
        if (!emptyNodes) ...[
          {'node_id': 1, 'title': 'Modelagem', 'type': 'AREA'},
          {'node_id': 2, 'title': 'Fundamentos', 'type': 'TOPIC'},
          {
            'node_id': 3,
            'title': 'Preparação de dados',
            'description': 'Transformar dados em atributos de entrada.',
            'type': 'CONCEPT',
            'level': 'foundation',
          },
          {
            'node_id': 4,
            'title': 'Avaliação de modelos',
            if (!omitDependentObjective)
              'description': 'Comparar previsões com uma linha de base.',
            'type': 'CONCEPT',
            'level': includeFoundationPrerequisiteWarning
                ? 'foundation'
                : 'core',
          },
        ],
      ],
      'edges': [
        {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
        {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
        {'source_node': 2, 'target_node': 4, 'type': 'SUBTOPIC'},
        {
          'source_node': 3,
          'target_node': 4,
          'type': 'PREREQUISITE',
          'weight': 1.0,
        },
      ],
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
