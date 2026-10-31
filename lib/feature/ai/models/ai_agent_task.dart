enum AiAgentTask {
  manipulateGraph('manipulate_graph', 'Editar grafo'),
  manipulateNode('manipulate_node', 'Editar nó'),
  generateNodeDescription('generate_node_description', 'Descrever nó'),
  createStudySession('create_study_session', 'Criar sessão de estudo'),
  evaluateEssayQuestion(
    'evaluate_essay_question',
    'Avaliar resposta dissertativa',
  ),
  createEssayQuestion('create_essay_question', 'Criar questão dissertativa'),
  createMultipleChoiceQuestion(
    'create_multiple_choice_question',
    'Criar questão de múltipla escolha',
  ),
  evaluateMultipleChoiceQuestion(
    'evaluate_multiple_choice_question',
    'Avaliar questão de múltipla escolha',
  ),
  createFeynman('create_feynman', 'Criar questão Feynman'),
  evaluateFeynman('evaluate_feynman ', 'Avaliar resposta Feynman'),
  recommendStudyResource('recommend_study_resource', 'Recomendar recursos'),
  studyManager('study_manager', 'Planejar estudos'),
  studyAssistant('study_assistant', 'Assistente de estudos'),
  createFlashcardGroup('create_flashcard_group', 'Criar grupo de flashcards'),
  manipulateFlashcardGroup(
    'manipulate_flashcard_group',
    'Editar grupo de flashcards',
  ),
  createFlashcard('create_flashcard', 'Criar flashcard'),
  createFlashcards('create_flashcardS', 'Criar flashcards');

  const AiAgentTask(this.wireName, this.label);

  final String wireName;
  final String label;

  static AiAgentTask? fromWireName(String value) {
    final normalized = normalize(value);
    for (final task in values) {
      if (normalize(task.wireName) == normalized) return task;
    }
    return null;
  }

  static String normalize(String value) => value.trim().toLowerCase();
}

class AiAgent {
  const AiAgent({
    required this.id,
    required this.alias,
    required this.taskName,
  });

  final String id;
  final String alias;
  final String taskName;

  AiAgentTask? get task => AiAgentTask.fromWireName(taskName);

  factory AiAgent.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final alias = json['alias'];
    final task = json['task'];
    if (id is! String || alias is! String || task is! String) {
      throw const FormatException('O agente retornado tem campos inválidos.');
    }
    return AiAgent(id: id, alias: alias, taskName: task);
  }
}
