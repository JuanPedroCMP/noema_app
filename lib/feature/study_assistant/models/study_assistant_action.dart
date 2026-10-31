enum StudyAssistantActionType {
  navigate,
  createGraph,
  createFlashcards,
  createExercise,
}

class StudyAssistantAction {
  const StudyAssistantAction({
    required this.type,
    required this.title,
    this.prompt = '',
    this.destination,
    this.exerciseType,
    this.graphId,
    this.nodeId,
  });

  final StudyAssistantActionType type;
  final String title;
  final String prompt;
  final String? destination;
  final String? exerciseType;
  final String? graphId;
  final String? nodeId;

  static StudyAssistantAction? fromJson(Object? value) {
    if (value is! Map) return null;
    final json = Map<String, dynamic>.from(value);
    final rawType = json['type'];
    if (rawType is! String) return null;
    final type = switch (rawType.trim().toLowerCase()) {
      'navigate' => StudyAssistantActionType.navigate,
      'create_graph' => StudyAssistantActionType.createGraph,
      'create_flashcards' || 'create_flashcard' =>
        StudyAssistantActionType.createFlashcards,
      'create_exercise' || 'create_question' =>
        StudyAssistantActionType.createExercise,
      _ => null,
    };
    if (type == null) return null;

    final title = json['title'];
    final prompt = json['prompt'];
    final destination = json['destination'];
    final exerciseType = json['exerciseType'] ?? json['exercise_type'];
    final graphId = json['graphId'] ?? json['graph_id'];
    final nodeId = json['nodeId'] ?? json['node_id'];
    return StudyAssistantAction(
      type: type,
      title: title is String && title.trim().isNotEmpty
          ? _limit(title.trim(), 80)
          : _defaultTitle(type),
      prompt: prompt is String ? _limit(prompt.trim(), 1000) : '',
      destination: destination is String ? destination : null,
      exerciseType: exerciseType is String ? exerciseType : null,
      graphId: graphId is String ? graphId : null,
      nodeId: nodeId is String ? nodeId : null,
    );
  }

  static String _defaultTitle(StudyAssistantActionType type) => switch (type) {
    StudyAssistantActionType.navigate => 'Abrir página',
    StudyAssistantActionType.createGraph => 'Preparar novo grafo',
    StudyAssistantActionType.createFlashcards => 'Preparar flashcards',
    StudyAssistantActionType.createExercise => 'Preparar exercício',
  };

  static String _limit(String value, int maxLength) =>
      value.length <= maxLength ? value : value.substring(0, maxLength);
}

class StudyAssistantHandoff {
  const StudyAssistantHandoff({
    required this.type,
    required this.prompt,
    this.exerciseType,
    this.graphId,
    this.nodeId,
    this.autoGenerate = false,
  });

  final StudyAssistantActionType type;
  final String prompt;
  final String? exerciseType;
  final String? graphId;
  final String? nodeId;
  final bool autoGenerate;
}
