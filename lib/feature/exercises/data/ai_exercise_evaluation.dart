import 'dart:convert';

import 'package:noema/feature/ai/models/ai_agent_task.dart';

String buildAiExerciseEvaluationPrompt({
  required AiAgentTask task,
  required String nodeTitle,
  required String? nodeDescription,
  required String nodeType,
  required Map<String, dynamic> context,
}) {
  final responseInstructions = switch (task) {
    AiAgentTask.evaluateMultipleChoiceQuestion =>
      'Retorne explanation com a análise da resposta e tips com próximos passos.',
    AiAgentTask.evaluateEssayQuestion =>
      'Retorne feedback, conceptualRequisites com fidelity_to_question, '
          'teoric_precision e response_deep, e textCoerence com coerence, '
          'argument_struct e argument_clarity. Cada critério deve ser um '
          'inteiro de 0 a 100.',
    AiAgentTask.evaluateFeynman =>
      'Retorne feedback, conceptualRequisites com fidelity_to_question, '
          'teoric_precision e response_deep, textCoerence com coerence, '
          'argument_struct e argument_clarity, e feynmanRequisites com '
          'explanation_acessibility, logic_progression e gaps. Cada critério '
          'deve ser um inteiro de 0 a 100; gaps representa a gravidade das lacunas.',
    _ => throw ArgumentError.value(
      task,
      'task',
      'is not an exercise evaluation',
    ),
  };

  return '''
Avalie esta tentativa de estudo com rigor pedagógico, respeito e foco no aprendizado.
Tipo de tarefa: ${task.label}.
Contexto do nó: ${jsonEncode({'title': nodeTitle, 'description': nodeDescription, 'type': nodeType})}
Dados da tentativa: ${jsonEncode(context)}

Considere a resposta de referência e as alternativas corretas quando estiverem
presentes. Não invente informações ausentes. Em múltipla escolha, explique por
que a seleção está correta ou incorreta e corrija equívocos conceituais.
$responseInstructions
''';
}

Map<String, dynamic> normalizeAiExerciseEvaluation({
  required AiAgentTask task,
  required Map<String, dynamic> response,
  required Map<String, dynamic> context,
}) {
  late final String feedback;
  late final double score;

  if (task == AiAgentTask.evaluateMultipleChoiceQuestion) {
    final explanation = _requiredText(response, 'explanation');
    final tips = response['tips'];
    feedback = tips is String && tips.trim().isNotEmpty
        ? '${explanation.trim()}\n\n${tips.trim()}'
        : explanation.trim();
    score = _normalizeScore(context['objective_score']);
  } else {
    feedback = _requiredText(response, 'feedback').trim();
    final criteria = <double>[
      ..._requiredCriteria(response, 'conceptualRequisites', const [
        'fidelity_to_question',
        'teoric_precision',
        'response_deep',
      ]),
      ..._requiredCriteria(response, 'textCoerence', const [
        'coerence',
        'argument_struct',
        'argument_clarity',
      ]),
    ];
    if (task == AiAgentTask.evaluateFeynman) {
      final feynmanCriteria = _requiredCriteria(
        response,
        'feynmanRequisites',
        const ['explanation_acessibility', 'logic_progression', 'gaps'],
      );
      criteria
        ..add(feynmanCriteria[0])
        ..add(feynmanCriteria[1])
        ..add(1 - feynmanCriteria[2]);
    }
    score = criteria.reduce((sum, value) => sum + value) / criteria.length;
  }

  return {
    'feedback': feedback,
    'score': score,
    'mastery_demonstrated': _masteryForScore(score),
  };
}

String _requiredText(Map<String, dynamic> response, String key) {
  final value = response[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('A resposta da IA não contém "$key" válido.');
  }
  return value;
}

List<double> _requiredCriteria(
  Map<String, dynamic> response,
  String objectKey,
  List<String> keys,
) {
  final rawObject = response[objectKey];
  if (rawObject is! Map) {
    throw FormatException('A resposta da IA não contém "$objectKey" válido.');
  }
  final values = Map<String, dynamic>.from(rawObject);
  return [
    for (final key in keys) _normalizeRubricScore(values[key], field: key),
  ];
}

double _normalizeRubricScore(Object? value, {required String field}) {
  if (value is! num || !value.isFinite || value < 0 || value > 100) {
    throw FormatException('O critério "$field" deve estar entre 0 e 100.');
  }
  return value / 100;
}

double _normalizeScore(Object? value, {String field = 'score'}) {
  if (value is! num || !value.isFinite) {
    throw FormatException('A resposta da IA não contém "$field" numérico.');
  }
  final score = value > 1 ? value / 100 : value.toDouble();
  if (score < 0 || score > 1) {
    throw FormatException('O valor "$field" deve estar entre 0 e 100.');
  }
  return score;
}

String _masteryForScore(double score) => switch (score) {
  < 0.4 => 'WEAK',
  < 0.6 => 'PARTIAL',
  < 0.8 => 'ADEQUATE',
  _ => 'STRONG',
};
