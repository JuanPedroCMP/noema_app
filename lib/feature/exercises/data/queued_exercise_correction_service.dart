import 'dart:convert';

import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_response_log_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_response_log_dao.dart';
import 'package:noema/feature/review/data/domain_mastery_service.dart';
import 'package:noema/feature/review/data/fsrs_review_service.dart';

class QueuedExerciseCorrectionService {
  const QueuedExerciseCorrectionService({
    required this.database,
    required this.ai,
  });

  final AppDatabase database;
  final AiContentGenerationService ai;

  Future<void> correct({
    required AiBackgroundTaskData task,
    required GraphNodeData node,
  }) async {
    final responseId = task.subjectId;
    if (responseId == null || responseId.isEmpty) {
      throw StateError('A tarefa de correção não possui uma resposta associada.');
    }

    switch (task.taskType) {
      case aiOpenEndedCorrectionTaskType:
        return _correctOpenEnded(responseId, node, task);
      case aiMultipleChoiceCorrectionTaskType:
        return _correctMultipleChoice(responseId, node, task);
      default:
        throw ArgumentError.value(task.taskType, 'task.taskType');
    }
  }

  Future<void> _correctOpenEnded(
    String responseId,
    GraphNodeData node,
    AiBackgroundTaskData task,
  ) async {
    final responseDao = OpenEndedResponseLogDao(database);
    final response = await responseDao.getOpenEndedResponseLog(id: responseId);
    if (response == null || response.corrected) return;

    final snapshot = _decodeObject(response.questionSnapshot);
    final isFeynman = (snapshot['type'] as String?)?.toUpperCase() == 'FEYNMAN';
    final taskType = isFeynman
        ? AiAgentTask.evaluateFeynman
        : AiAgentTask.evaluateEssayQuestion;
    final correction = await _evaluate(
      task: taskType,
      node: node,
      context: {
        'question': snapshot,
        'student_answer': response.userAnswer ?? '',
      },
    );

    await database.transaction(() async {
      final current = await responseDao.getOpenEndedResponseLog(
        id: responseId,
      );
      if (current == null || current.corrected) return;
      await responseDao.updateOpenEndedResponseLog(
        id: responseId,
        aiFeedback: correction.feedback,
        score: correction.score,
        weight: (correction.score * 100).round(),
        isCorrect: correction.score >= 0.6,
        masteryDemonstrated: correction.mastery,
        corrected: true,
      );
      await FsrsReviewService(database).review(
        itemType: ReviewItemType.openEnded,
        itemId: current.openEndedId,
        nodeId: task.nodeId,
        rating: _ratingForScore(correction.score),
        durationSeconds: current.durationSeconds,
        score: correction.score,
        method: ReviewMethod.aiCorrection,
        eventOrigin: current.studySessionLogId == null
            ? DomainEventOrigin.revision
            : DomainEventOrigin.studySession,
        sourceStudySessionType: isFeynman ? 'FEYNMAN' : 'ESSAY',
        sourceResponseId: current.id,
      );
    });
  }

  Future<void> _correctMultipleChoice(
    String responseId,
    GraphNodeData node,
    AiBackgroundTaskData task,
  ) async {
    final responseDao = MultipleChoiceResponseLogDao(database);
    final response = await responseDao.getMultipleChoiceResponseLog(
      id: responseId,
    );
    if (response == null || response.corrected) return;

    final snapshot = _decodeObject(response.questionSnapshot);
    final alternatives = _decodeJsonList(response.questionChoiceSnapshot)
        .whereType<Map>()
        .map((choice) => Map<String, dynamic>.from(choice))
        .toList(growable: false);
    final selectedIds = _decodeJsonList(response.selectedChoiceIds)
        .whereType<String>()
        .toList(growable: false);
    final correction = await _evaluate(
      task: AiAgentTask.evaluateMultipleChoiceQuestion,
      node: node,
      context: {
        'question': snapshot,
        'alternatives': alternatives,
        'selected_alternative_ids': selectedIds,
        'objective_score': response.score,
        'correct_alternatives': alternatives
            .where((choice) => choice['is_correct'] == true)
            .toList(),
      },
    );

    await database.transaction(() async {
      final current = await responseDao.getMultipleChoiceResponseLog(
        id: responseId,
      );
      if (current == null || current.corrected) return;
      await responseDao.updateMultipleChoiceResponseLog(
        id: responseId,
        aiFeedback: correction.feedback,
        score: correction.score,
        corrected: true,
      );
      await FsrsReviewService(database).review(
        itemType: ReviewItemType.multipleChoice,
        itemId: current.multipleChoiceId,
        nodeId: task.nodeId,
        rating: _ratingForScore(correction.score),
        durationSeconds: current.durationSeconds,
        score: correction.score,
        method: ReviewMethod.aiCorrection,
        eventOrigin: current.studySessionLogId == null
            ? DomainEventOrigin.revision
            : DomainEventOrigin.studySession,
        sourceStudySessionType: 'MULTIPLE_CHOICE',
        sourceResponseId: current.id,
      );
    });
  }

  Future<_ExerciseCorrection> _evaluate({
    required AiAgentTask task,
    required GraphNodeData node,
    required Map<String, dynamic> context,
  }) async {
    final result = await ai.generate(
      task: task,
      priority: AiRequestPriority.background,
      prompt: '''
Avalie esta tentativa de estudo com rigor pedagógico, respeito e foco no aprendizado.
Tipo de tarefa: ${task.label}.
Contexto do nó: ${jsonEncode({
        'title': node.title,
        'description': node.description,
        'type': node.type,
      })}
Dados da tentativa: ${jsonEncode(context)}

Considere a resposta de referência e as alternativas corretas quando estiverem
presentes. Não invente informações ausentes. Em múltipla escolha, explique por
que a seleção está correta ou incorreta e corrija equívocos conceituais.
Retorne somente um objeto JSON com:
{
  "feedback": "feedback claro e específico em português",
  "score": 0.0,
  "is_correct": false,
  "mastery_demonstrated": "WEAK|PARTIAL|ADEQUATE|STRONG"
}
score deve ser um número entre 0 e 1.
''',
    );
    final feedback = result['feedback'] ??
        result['ai_feedback'] ??
        result['explanation'] ??
        result['comment'];
    if (feedback is! String || feedback.trim().isEmpty) {
      throw const FormatException(
        'A IA não retornou um feedback de correção válido.',
      );
    }
    final rawScore = result['score'] ?? result['grade'] ?? result['weight'];
    if (rawScore is! num || !rawScore.isFinite) {
      throw const FormatException('A IA não retornou uma nota válida.');
    }
    var score = rawScore.toDouble();
    if (score > 1) score /= 100;
    if (score < 0 || score > 1) {
      throw const FormatException(
        'A nota retornada pela IA deve estar entre 0 e 1.',
      );
    }
    final rawMastery =
        (result['mastery_demonstrated'] ?? result['mastery'] ?? 'ADEQUATE')
            .toString()
            .toUpperCase();
    final mastery = switch (rawMastery) {
      'WEAK' || 'PARTIAL' || 'STRONG' => rawMastery,
      _ => 'ADEQUATE',
    };
    return _ExerciseCorrection(
      feedback: feedback.trim(),
      score: score,
      mastery: mastery,
    );
  }

  Map<String, dynamic> _decodeObject(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('O registro da tentativa está inválido.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  List<dynamic> _decodeJsonList(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw const FormatException('Os dados da tentativa estão inválidos.');
    }
    return decoded;
  }

  fsrs.Rating _ratingForScore(double score) {
    if (score < 0.25) return fsrs.Rating.again;
    if (score < 0.6) return fsrs.Rating.hard;
    if (score < 0.9) return fsrs.Rating.good;
    return fsrs.Rating.easy;
  }
}

class _ExerciseCorrection {
  const _ExerciseCorrection({
    required this.feedback,
    required this.score,
    required this.mastery,
  });

  final String feedback;
  final double score;
  final String mastery;
}
