import 'dart:async';
import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';
import 'package:uuid/uuid.dart';

class StudyPackCounts {
  const StudyPackCounts({
    this.multipleChoice = 0,
    this.essay = 0,
    this.feynman = 0,
    this.flashcards = 0,
  });

  final int multipleChoice;
  final int essay;
  final int feynman;
  final int flashcards;

  int get total => multipleChoice + essay + feynman + flashcards;

  StudyPackCounts copyWith({
    int? multipleChoice,
    int? essay,
    int? feynman,
    int? flashcards,
  }) => StudyPackCounts(
    multipleChoice: multipleChoice ?? this.multipleChoice,
    essay: essay ?? this.essay,
    feynman: feynman ?? this.feynman,
    flashcards: flashcards ?? this.flashcards,
  );

  factory StudyPackCounts.fromJson(Map<String, dynamic> json) {
    final counts = StudyPackCounts(
      multipleChoice: _readCount(json, 'multiple_choice'),
      essay: _readCount(json, 'essay'),
      feynman: _readCount(json, 'feynman'),
      flashcards: _readCount(json, 'flashcards'),
    );
    counts.validate();
    return counts;
  }

  Map<String, Object?> toJson() => {
    'multiple_choice': multipleChoice,
    'essay': essay,
    'feynman': feynman,
    'flashcards': flashcards,
  };

  void validate() {
    final counts = [multipleChoice, essay, feynman, flashcards];
    if (counts.any((count) => count < 0 || count > 20) ||
        total == 0 ||
        total > 40) {
      throw ArgumentError.value(this, 'counts', 'Quantidades fora do limite.');
    }
  }
}

class StudyPackRequest {
  const StudyPackRequest({required this.counts, this.instructions = ''});

  final StudyPackCounts counts;
  final String instructions;

  factory StudyPackRequest.fromJson(Map<String, dynamic> json) {
    final instructions = json['instructions'];
    if (instructions != null && instructions is! String) {
      throw const FormatException('Instruções do pacote inválidas.');
    }
    return StudyPackRequest(
      counts: StudyPackCounts.fromJson(json),
      instructions: (instructions as String?)?.trim() ?? '',
    );
  }

  Map<String, Object?> toJson() => {
    ...counts.toJson(),
    'instructions': instructions.trim(),
  };
}

class StudyPackChoice {
  const StudyPackChoice({
    required this.statement,
    required this.isCorrect,
    required this.explanation,
    required this.weight,
  });

  final String statement;
  final bool isCorrect;
  final String explanation;
  final int? weight;
}

class StudyPackMultipleChoice {
  const StudyPackMultipleChoice({
    required this.title,
    required this.statement,
    required this.choices,
  });

  final String title;
  final String statement;
  final List<StudyPackChoice> choices;
}

class StudyPackOpenEnded {
  const StudyPackOpenEnded({
    required this.title,
    required this.statement,
    required this.referenceAnswer,
    required this.type,
  });

  final String title;
  final String statement;
  final String referenceAnswer;
  final String type;
}

class StudyPackFlashcard {
  const StudyPackFlashcard({
    required this.title,
    required this.statement,
    this.targetSkill,
  });

  final String title;
  final String statement;
  final String? targetSkill;
}

class StudyPackDraft {
  const StudyPackDraft({
    required this.multipleChoice,
    required this.openEnded,
    required this.flashcards,
  });

  final List<StudyPackMultipleChoice> multipleChoice;
  final List<StudyPackOpenEnded> openEnded;
  final List<StudyPackFlashcard> flashcards;

  int get total => multipleChoice.length + openEnded.length + flashcards.length;
}

class StudyPackService {
  static const _maxConcurrentGenerationRequests = 4;

  StudyPackService({required this.ai, required this.database});

  final AiContentGenerationService ai;
  final AppDatabase database;

  static List<String> studyMaterialContext(
    Iterable<LearningResourceData> resources,
  ) => [
    for (final resource in resources.take(8))
      '${resource.category}: ${_truncate(resource.title, 120)}. '
          '${_truncate(resource.rationale, 240)}',
  ];

  Future<StudyPackDraft> generate({
    required String nodeTitle,
    required String? nodeDescription,
    required StudyPackRequest request,
    List<String> studyMaterials = const [],
    AiRequestPriority priority = AiRequestPriority.user,
  }) async {
    request.counts.validate();
    final generationGate = _StudyPackGenerationGate(
      _maxConcurrentGenerationRequests,
    );
    final multipleChoiceFuture = _generateMany(
      task: AiAgentTask.createMultipleChoiceQuestion,
      count: request.counts.multipleChoice,
      generationGate: generationGate,
      priority: priority,
      nodeTitle: nodeTitle,
      nodeDescription: nodeDescription,
      instructions: request.instructions,
      studyMaterials: studyMaterials,
      typeInstructions:
          'Crie uma questão objetiva com título, statement e exatamente 4 '
          'choices. Cada choice deve ter statement, is_correct, explanation '
          'e weight inteiro não negativo. Exatamente uma alternativa correta.',
      parse: _parseMultipleChoice,
    );
    final essayFuture = _generateMany(
      task: AiAgentTask.createEssayQuestion,
      count: request.counts.essay,
      generationGate: generationGate,
      priority: priority,
      nodeTitle: nodeTitle,
      nodeDescription: nodeDescription,
      instructions: request.instructions,
      studyMaterials: studyMaterials,
      typeInstructions:
          'Crie uma questão dissertativa com title, statement e '
          'reference_correct_answer.',
      parse: (json) => _parseOpenEnded(json, 'ESSAY'),
    );
    final feynmanFuture = _generateMany(
      task: AiAgentTask.createFeynman,
      count: request.counts.feynman,
      generationGate: generationGate,
      priority: priority,
      nodeTitle: nodeTitle,
      nodeDescription: nodeDescription,
      instructions: request.instructions,
      studyMaterials: studyMaterials,
      typeInstructions:
          'Crie uma questão pelo método Feynman com title, statement e '
          'reference_correct_answer.',
      parse: (json) => _parseOpenEnded(json, 'FEYNMAN'),
    );
    final flashcardsFuture = _generateFlashcards(
      count: request.counts.flashcards,
      generationGate: generationGate,
      priority: priority,
      nodeTitle: nodeTitle,
      nodeDescription: nodeDescription,
      instructions: request.instructions,
      studyMaterials: studyMaterials,
    );

    final generated = await Future.wait<Object>([
      multipleChoiceFuture,
      essayFuture,
      feynmanFuture,
      flashcardsFuture,
    ]);
    return StudyPackDraft(
      multipleChoice: generated[0] as List<StudyPackMultipleChoice>,
      openEnded: [
        ...generated[1] as List<StudyPackOpenEnded>,
        ...generated[2] as List<StudyPackOpenEnded>,
      ],
      flashcards: generated[3] as List<StudyPackFlashcard>,
    );
  }

  Future<List<StudyPackFlashcard>> _generateFlashcards({
    required int count,
    required _StudyPackGenerationGate generationGate,
    required AiRequestPriority priority,
    required String nodeTitle,
    required String? nodeDescription,
    required String instructions,
    required List<String> studyMaterials,
  }) async {
    if (count == 0) return const [];
    final task = AiAgentTask.createFlashcards;
    final agentId = await ai.resolveAgentId(task);
    final prompt =
        '''
Crie exatamente $count flashcard(s) de estudo sobre "$nodeTitle".
Descrição do nó: ${nodeDescription?.trim().isNotEmpty == true ? nodeDescription : 'não informada'}
Materiais de estudo já vinculados:
${studyMaterials.isEmpty ? 'nenhum' : studyMaterials.map((material) => '- $material').join('\n')}
Instruções adicionais: ${instructions.trim().isEmpty ? 'nenhuma' : instructions.trim()}
Retorne somente um objeto JSON no formato {"flashcards":[{"title":"pergunta","statement":"resposta","target_skill":"habilidade avaliada"}]}.
A lista deve conter exatamente $count itens distintos. Use title como pergunta, statement como resposta e target_skill opcional. Não inclua texto fora do JSON.
''';
    return generationGate.run(
      () => ai.generateWithRetry(
        task: task,
        agentId: agentId,
        prompt: prompt,
        priority: priority,
        parse: (json) => _parseFlashcards(json, expectedCount: count),
      ),
    );
  }

  Future<List<T>> _generateMany<T>({
    required AiAgentTask task,
    required int count,
    required _StudyPackGenerationGate generationGate,
    required AiRequestPriority priority,
    required String nodeTitle,
    required String? nodeDescription,
    required String instructions,
    required List<String> studyMaterials,
    required String typeInstructions,
    required T Function(Map<String, dynamic>) parse,
  }) async {
    if (count == 0) return const [];
    final agentId = await ai.resolveAgentId(task);
    final prompts = List.generate(count, (index) {
      return '''
Crie uma questão para um pacote de estudo sobre "$nodeTitle".
Descrição do nó: ${nodeDescription?.trim().isNotEmpty == true ? nodeDescription : 'não informada'}
Materiais de estudo já vinculados:
${studyMaterials.isEmpty ? 'nenhum' : studyMaterials.map((material) => '- $material').join('\n')}
Instruções adicionais: ${instructions.trim().isEmpty ? 'nenhuma' : instructions.trim()}
$typeInstructions
Retorne somente um objeto JSON válido, sem markdown ou texto adicional.
Esta é a questão ${index + 1} de $count. Faça cada item distinto.
''';
    });
    return Future.wait<T>(
      prompts.map(
        (prompt) => generationGate.run(
          () => ai.generateWithRetry<T>(
            task: task,
            agentId: agentId,
            prompt: prompt,
            priority: priority,
            parse: parse,
          ),
        ),
      ),
    );
  }

  Future<void> save({
    required String nodeId,
    required String flashcardDeckName,
    required StudyPackDraft draft,
    String? idempotencyKey,
  }) async {
    await database.transaction(() async {
      final multipleChoiceDao = MultipleChoiceDao(database);
      final choiceDao = ChoiceDao(database);
      final openEndedDao = OpenEndedDao(database);
      for (var index = 0; index < draft.multipleChoice.length; index++) {
        final question = draft.multipleChoice[index];
        final questionId = idempotencyKey == null
            ? await multipleChoiceDao.insertMultipleChoice(
                nodeId: nodeId,
                title: question.title,
                statement: question.statement,
                isAiGenerated: true,
              )
            : '${idempotencyKey}_mc_$index';
        if (idempotencyKey != null) {
          await database
              .into(database.multipleChoice)
              .insert(
                MultipleChoiceCompanion.insert(
                  id: questionId,
                  nodeId: nodeId,
                  title: question.title,
                  statement: question.statement,
                  isAiGenerated: const Value(true),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
        for (
          var choiceIndex = 0;
          choiceIndex < question.choices.length;
          choiceIndex++
        ) {
          final choice = question.choices[choiceIndex];
          if (idempotencyKey == null) {
            await choiceDao.insertChoice(
              multipleChoiceId: questionId,
              isCorrect: choice.isCorrect,
              statement: choice.statement,
              explanation: choice.explanation,
              weight: choice.weight,
              isAiGenerated: true,
            );
          } else {
            await database
                .into(database.choice)
                .insert(
                  ChoiceCompanion.insert(
                    id: '${idempotencyKey}_mc_${index}_choice_$choiceIndex',
                    multipleChoiceId: questionId,
                    isCorrect: choice.isCorrect,
                    statement: choice.statement,
                    explanation: Value(choice.explanation),
                    weight: Value(choice.weight),
                    isAiGenerated: const Value(true),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
          }
        }
      }
      for (var index = 0; index < draft.openEnded.length; index++) {
        final question = draft.openEnded[index];
        if (idempotencyKey == null) {
          await openEndedDao.insertOpenEnded(
            nodeId: nodeId,
            title: question.title,
            statement: question.statement,
            type: question.type,
            referenceCorrectAnswer: question.referenceAnswer,
            isAiGenerated: true,
          );
        } else {
          await database
              .into(database.openEnded)
              .insert(
                OpenEndedCompanion.insert(
                  id: '${idempotencyKey}_open_$index',
                  nodeId: nodeId,
                  title: question.title,
                  statement: question.statement,
                  type: question.type,
                  referenceCorrectAnswer: Value(question.referenceAnswer),
                  isAiGenerated: const Value(true),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }

      if (draft.flashcards.isEmpty) return;
      final deckId = idempotencyKey == null
          ? const Uuid().v4()
          : '${idempotencyKey}_deck';
      await database
          .into(database.flashcardGroup)
          .insert(
            FlashcardGroupCompanion.insert(
              id: deckId,
              nodeId: nodeId,
              name: flashcardDeckName.trim(),
            ),
            mode: idempotencyKey == null
                ? InsertMode.insert
                : InsertMode.insertOrIgnore,
          );
      for (var index = 0; index < draft.flashcards.length; index++) {
        final card = draft.flashcards[index];
        final cardId = idempotencyKey == null
            ? const Uuid().v4()
            : '${idempotencyKey}_card_$index';
        await database
            .into(database.flashcard)
            .insert(
              FlashcardCompanion.insert(
                id: cardId,
                nodeId: nodeId,
                title: card.title,
                statement: card.statement,
                targetSkill: Value(card.targetSkill),
                isAiGenerated: const Value(true),
              ),
              mode: idempotencyKey == null
                  ? InsertMode.insert
                  : InsertMode.insertOrIgnore,
            );
        await database
            .into(database.flashcardBelongsGroup)
            .insert(
              FlashcardBelongsGroupCompanion.insert(
                id: idempotencyKey == null
                    ? const Uuid().v4()
                    : '${idempotencyKey}_card_link_$index',
                flashcardId: cardId,
                flashcardGroupId: deckId,
              ),
              mode: idempotencyKey == null
                  ? InsertMode.insert
                  : InsertMode.insertOrIgnore,
            );
      }
    });
  }

  static StudyPackMultipleChoice _parseMultipleChoice(
    Map<String, dynamic> json,
  ) {
    final rawChoices = json['choices'] ?? json['choises'];
    if (rawChoices is! List) {
      throw const FormatException('A lista de alternativas não foi retornada.');
    }
    final choices = rawChoices
        .map((raw) {
          if (raw is! Map ||
              raw['is_correct'] is! bool ||
              raw['statement'] is! String ||
              (raw['statement'] as String).trim().isEmpty) {
            throw const FormatException('Uma alternativa está incompleta.');
          }
          final rawWeight = raw['weight'] ?? raw['weigth'];
          if (rawWeight != null && rawWeight is! num) {
            throw const FormatException('O peso da alternativa é inválido.');
          }
          final weight = (rawWeight as num?)?.toInt();
          if (weight != null && weight < 0) {
            throw const FormatException(
              'O peso da alternativa não pode ser negativo.',
            );
          }
          return StudyPackChoice(
            statement: (raw['statement'] as String).trim(),
            isCorrect: raw['is_correct'] as bool,
            explanation: raw['explanation'] is String
                ? (raw['explanation'] as String).trim()
                : '',
            weight: weight,
          );
        })
        .toList(growable: false);
    if (choices.length != 4 ||
        choices.where((choice) => choice.isCorrect).length != 1) {
      throw const FormatException(
        'A questão deve ter exatamente quatro alternativas e uma resposta '
        'correta.',
      );
    }
    return StudyPackMultipleChoice(
      title: _requiredString(json, 'title'),
      statement: _requiredString(json, 'statement'),
      choices: choices,
    );
  }

  static StudyPackOpenEnded _parseOpenEnded(
    Map<String, dynamic> json,
    String type,
  ) => StudyPackOpenEnded(
    title: _requiredString(json, 'title'),
    statement: _requiredString(json, 'statement'),
    referenceAnswer: _requiredString(
      json,
      'reference_correct_answer',
      alternateKey: 'reference_answer',
    ),
    type: type,
  );

  static List<StudyPackFlashcard> _parseFlashcards(
    Map<String, dynamic> json, {
    required int expectedCount,
  }) {
    final rawFlashcards = json['flashcards'];
    if (rawFlashcards is! List || rawFlashcards.length != expectedCount) {
      throw const FormatException(
        'A quantidade de flashcards retornada não corresponde à solicitada.',
      );
    }
    return rawFlashcards
        .map((raw) {
          if (raw is! Map) {
            throw const FormatException('Um flashcard retornado é inválido.');
          }
          return _parseFlashcard(Map<String, dynamic>.from(raw));
        })
        .toList(growable: false);
  }

  static StudyPackFlashcard _parseFlashcard(Map<String, dynamic> json) {
    final targetSkill = json['target_skill'];
    return StudyPackFlashcard(
      title: _requiredString(json, 'title'),
      statement: _requiredString(json, 'statement'),
      targetSkill: targetSkill is String ? targetSkill.trim() : null,
    );
  }

  static String _requiredString(
    Map<String, dynamic> json,
    String key, {
    String? alternateKey,
  }) {
    final value =
        json[key] ?? (alternateKey == null ? null : json[alternateKey]);
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Campo "$key" ausente ou vazio.');
    }
    return value.trim();
  }
}

class _StudyPackGenerationGate {
  _StudyPackGenerationGate(this._maxConcurrentRequests);

  final int _maxConcurrentRequests;
  final Queue<Completer<void>> _waitingRequests = Queue();
  int _activeRequests = 0;

  Future<T> run<T>(Future<T> Function() action) async {
    if (_activeRequests >= _maxConcurrentRequests) {
      final turn = Completer<void>();
      _waitingRequests.addLast(turn);
      await turn.future;
    } else {
      _activeRequests++;
    }

    try {
      return await action();
    } finally {
      if (_waitingRequests.isEmpty) {
        _activeRequests--;
      } else {
        _waitingRequests.removeFirst().complete();
      }
    }
  }
}

int _readCount(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('Quantidade "$key" inválida.');
  return value;
}

String _truncate(String value, int maximumLength) {
  final normalized = value.trim();
  if (normalized.length <= maximumLength) return normalized;
  return '${normalized.substring(0, maximumLength - 1)}…';
}
