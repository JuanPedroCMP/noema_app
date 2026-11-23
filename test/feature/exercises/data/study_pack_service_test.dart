import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test(
    'generates the requested flashcards from the API list response',
    () async {
      final ai = container.read(_stubAiProvider);
      final service = StudyPackService(ai: ai, database: database);
      final draft = await service.generate(
        nodeTitle: 'Célula',
        nodeDescription: 'Unidade básica da vida.',
        request: StudyPackRequest(counts: const StudyPackCounts(flashcards: 2)),
      );

      expect(ai.task, AiAgentTask.createFlashcards);
      expect(ai.prompt, contains('exatamente 2'));
      expect(draft.flashcards, hasLength(2));
      expect(draft.flashcards.first.title, 'O que é uma célula?');
      expect(draft.flashcards.first.targetSkill, 'memória');
    },
  );

  test(
    'generates every requested content type with the API response shape',
    () async {
      final ai = container.read(_stubAiProvider);
      final draft = await StudyPackService(ai: ai, database: database).generate(
        nodeTitle: 'Célula',
        nodeDescription: 'Unidade básica da vida.',
        request: StudyPackRequest(
          counts: const StudyPackCounts(
            multipleChoice: 1,
            essay: 1,
            feynman: 1,
            flashcards: 1,
          ),
        ),
      );

      expect(draft.total, 4);
      expect(draft.multipleChoice, hasLength(1));
      expect(draft.multipleChoice.single.choices, hasLength(4));
      expect(draft.multipleChoice.single.choices.first.weight, 2);
      expect(draft.openEnded.map((question) => question.type), [
        'ESSAY',
        'FEYNMAN',
      ]);
      expect(
        ai.generationTasks,
        containsAll([
          AiAgentTask.createMultipleChoiceQuestion,
          AiAgentTask.createEssayQuestion,
          AiAgentTask.createFeynman,
        ]),
      );
      expect(draft.flashcards, hasLength(1));
    },
  );

  test(
    'rejects a flashcard list whose length differs from the request',
    () async {
      final ai = container.read(_stubAiProvider);
      ai.returnWrongFlashcardCount = true;

      await expectLater(
        StudyPackService(ai: ai, database: database).generate(
          nodeTitle: 'Célula',
          nodeDescription: null,
          request: StudyPackRequest(
            counts: const StudyPackCounts(flashcards: 1),
          ),
        ),
        throwsFormatException,
      );
    },
  );

  test(
    'rejects multiple-choice questions without exactly four alternatives',
    () async {
      final ai = container.read(_stubAiProvider);
      ai.returnTooManyMultipleChoiceChoices = true;

      await expectLater(
        StudyPackService(ai: ai, database: database).generate(
          nodeTitle: 'Célula',
          nodeDescription: null,
          request: StudyPackRequest(
            counts: const StudyPackCounts(multipleChoice: 1),
          ),
        ),
        throwsFormatException,
      );
    },
  );

  test('limits concurrent requests across the whole pack', () async {
    final ai = container.read(_stubAiProvider)..simulateLatency = true;
    final draft = await StudyPackService(ai: ai, database: database).generate(
      nodeTitle: 'Célula',
      nodeDescription: null,
      request: StudyPackRequest(
        counts: const StudyPackCounts(multipleChoice: 8, essay: 8),
      ),
    );

    expect(draft.total, 16);
    expect(ai.maximumConcurrentGenerations, lessThanOrEqualTo(4));
    expect(ai.maximumConcurrentGenerations, greaterThan(1));
  });
}

final _stubAiProvider = Provider<_StubAiContentGenerationService>(
  _StubAiContentGenerationService.new,
);

class _StubAiContentGenerationService extends AiContentGenerationService {
  _StubAiContentGenerationService(super.ref);

  AiAgentTask? task;
  String? prompt;
  final generationTasks = <AiAgentTask>[];
  bool returnWrongFlashcardCount = false;
  bool returnTooManyMultipleChoiceChoices = false;
  bool simulateLatency = false;
  int _activeGenerations = 0;
  int maximumConcurrentGenerations = 0;

  @override
  Future<String> resolveAgentId(AiAgentTask task) async {
    this.task = task;
    return 'agent-id';
  }

  @override
  Future<T> generateWithRetry<T>({
    required AiAgentTask task,
    required String prompt,
    required T Function(Map<String, dynamic> payload) parse,
    String? agentId,
    Map<String, dynamic>? context,
    AiRequestPriority priority = AiRequestPriority.user,
    String Function(T)? retryFeedback,
    int maxAttempts = 2,
  }) async {
    this.task = task;
    this.prompt = prompt;
    generationTasks.add(task);
    _activeGenerations++;
    if (_activeGenerations > maximumConcurrentGenerations) {
      maximumConcurrentGenerations = _activeGenerations;
    }
    try {
      if (simulateLatency) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      final response = switch (task) {
        AiAgentTask.createMultipleChoiceQuestion => {
          'title': 'Estrutura celular',
          'statement': 'Qual estrutura controla a entrada de substâncias?',
          'choices': [
            {
              'is_correct': true,
              'statement': 'Membrana plasmática',
              'explanation': 'Regula as trocas com o meio.',
              'weight': 2,
            },
            {
              'is_correct': false,
              'statement': 'Ribossomo',
              'explanation': 'Participa da síntese proteica.',
              'weight': 1,
            },
            {
              'is_correct': false,
              'statement': 'Nucléolo',
              'explanation': 'Está relacionado à formação de ribossomos.',
              'weight': 1,
            },
            {
              'is_correct': false,
              'statement': 'Centríolo',
              'explanation': 'Participa da divisão celular.',
              'weight': 1,
            },
          ],
        },
        AiAgentTask.createEssayQuestion || AiAgentTask.createFeynman => {
          'title': 'Descreva a célula',
          'statement': 'Explique a organização celular.',
          'reference_correct_answer': 'A célula é a unidade básica da vida.',
        },
        AiAgentTask.createFlashcards => null,
        _ => throw StateError('Unexpected task: ${task.wireName}'),
      };
      if (response != null) {
        if (task == AiAgentTask.createMultipleChoiceQuestion &&
            returnTooManyMultipleChoiceChoices) {
          (response['choices'] as List).add({
            'is_correct': false,
            'statement': 'Parede celular',
            'explanation': 'Protege a célula vegetal.',
            'weight': 1,
          });
        }
        return parse(response);
      }

      final flashcardExamples = [
        {
          'title': 'O que é uma célula?',
          'statement':
              'A unidade básica estrutural e funcional dos seres vivos.',
          'target_skill': 'memória',
        },
        {
          'title': 'Qual a função da membrana celular?',
          'statement': 'Controlar a entrada e a saída de substâncias.',
        },
      ];
      final requestedCount =
          int.tryParse(
            RegExp(r'exatamente (\d+)').firstMatch(prompt)?.group(1) ?? '',
          ) ??
          0;
      final returnedCount = returnWrongFlashcardCount
          ? requestedCount + 1
          : requestedCount;
      return parse({
        'flashcards': List.generate(
          returnedCount,
          (index) => flashcardExamples[index % flashcardExamples.length],
        ),
      });
    } finally {
      _activeGenerations--;
    }
  }
}
