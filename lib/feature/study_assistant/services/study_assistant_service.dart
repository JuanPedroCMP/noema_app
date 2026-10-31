import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';
import 'package:noema/feature/study_assistant/services/study_assistant_context_service.dart';

class StudyAssistantResponse {
  const StudyAssistantResponse({required this.text, required this.actions});

  final String text;
  final List<StudyAssistantAction> actions;
}

class StudyAssistantService {
  StudyAssistantService(this._ref);

  final Ref _ref;

  Future<StudyAssistantResponse> respond({
    required List<StudyAssistantMessage> history,
    required String currentPath,
  }) async {
    final settings = await _ref.read(studyAssistantSettingsProvider.future);
    final context = await _ref
        .read(studyAssistantContextServiceProvider)
        .build(currentPath: currentPath);
    final conversation = history
        .takeLast(8)
        .map((message) {
          final role = message.isUser ? 'Estudante' : 'Assistente';
          final text = message.text.trim();
          final boundedText = text.length <= 650
              ? text
              : '${text.substring(0, 649)}…';
          return '$role: $boundedText';
        })
        .join('\n');
    final responseStyle = switch (settings.responseStyle) {
      StudyAssistantResponseStyle.concise =>
        'Prefira respostas curtas, com a informação essencial e poucos exemplos.',
      StudyAssistantResponseStyle.balanced =>
        'Equilibre clareza e concisão; explique o necessário e use exemplos breves quando ajudarem.',
      StudyAssistantResponseStyle.detailed =>
        'Explique passo a passo, inclua contexto e exemplos úteis, sem repetir ideias.',
    };
    final prompt =
        '''
Você é o assistente de estudos do Noema. Ajude o estudante com explicações claras, planejamento e próximos passos práticos. Responda em português brasileiro, a menos que o estudante peça outro idioma.
$responseStyle

Não diga que navegou, criou, salvou ou gerou algo. Você não executa ferramentas: quando fizer sentido, proponha no máximo 3 ações para o aplicativo preparar. Não proponha ação sem os dados necessários e não invente IDs.

Retorne somente um objeto JSON com este formato:
{"reply":"resposta ao estudante","actions":[{"type":"create_graph|create_flashcards|create_exercise|navigate","title":"rótulo curto","prompt":"tema e instruções","destination":"home|graphs|flashcards|notes|study_sessions","exerciseType":"multiple_choice|open_ended","graphId":"ID de um grafo do contexto","nodeId":"ID de um nó do contexto"}]}
Use reply sempre. actions pode ser uma lista vazia. Para navegação use apenas destinos conhecidos. Para exercícios, inclua graphId e nodeId apenas se esses IDs estiverem no contexto.

Conversa recente:
$conversation
''';
    final payload = await _ref
        .read(aiContentGenerationServiceProvider)
        .generate(
          task: AiAgentTask.studyAssistant,
          prompt: prompt,
          context: context,
        );
    final reply = _readReply(payload);
    if (reply == null) {
      throw const FormatException(
        'A resposta do assistente não contém o campo "reply".',
      );
    }
    final rawActions = payload['actions'];
    final actions = rawActions is List
        ? rawActions
              .map(StudyAssistantAction.fromJson)
              .whereType<StudyAssistantAction>()
              .take(3)
              .toList(growable: false)
        : const <StudyAssistantAction>[];
    return StudyAssistantResponse(text: reply, actions: actions);
  }

  String? _readReply(Map<String, dynamic> payload) {
    for (final key in const ['reply', 'message', 'text', 'answer']) {
      final value = payload[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}

extension<T> on List<T> {
  Iterable<T> takeLast(int count) => skip(length > count ? length - count : 0);
}

final studyAssistantServiceProvider = Provider<StudyAssistantService>(
  StudyAssistantService.new,
);
