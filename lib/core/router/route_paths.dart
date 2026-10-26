abstract final class RoutePaths {
  static const home = '/';
  static const notes = '/notes';
  static const config = '/config';
  static const test = '/test';
  static const graphs = '/graphs';
  static const flashcards = '/flashcards';
  static const studySessions = '/study-sessions';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const splash = '/splash';

  static String graph(String graphId) => '$graphs/$graphId';

  static String studySession(String sessionId) => '$studySessions/$sessionId';

  static String studySessionEdit(String sessionId) =>
      '${studySession(sessionId)}/edit';

  static String studySessionCreate() => '$studySessions/create';

  static String studySessionRun(String sessionId) =>
      '${studySession(sessionId)}/run';

  static String flashcardsForNode(String graphId, String nodeId) =>
      '${graph(graphId)}/flashcards/$nodeId';

  static String exercises(String graphId, String nodeId) =>
      '${graph(graphId)}/exercises/$nodeId';

  static String openEndedCreate(String graphId, String nodeId) =>
      '${exercises(graphId, nodeId)}/open-ended/create';

  static String openEnded(String graphId, String nodeId, String questionId) =>
      '${exercises(graphId, nodeId)}/open-ended/$questionId';

  static String openEndedEdit(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${openEnded(graphId, nodeId, questionId)}/edit';

  static String openEndedAnswer(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${openEnded(graphId, nodeId, questionId)}/answer';

  static String openEndedView(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${openEnded(graphId, nodeId, questionId)}/view';

  static String multipleChoiceCreate(String graphId, String nodeId) =>
      '${exercises(graphId, nodeId)}/multiple-choice/create';

  static String multipleChoice(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${exercises(graphId, nodeId)}/multiple-choice/$questionId';

  static String multipleChoiceEdit(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${multipleChoice(graphId, nodeId, questionId)}/edit';

  static String multipleChoiceAnswer(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${multipleChoice(graphId, nodeId, questionId)}/answer';

  static String multipleChoiceView(
    String graphId,
    String nodeId,
    String questionId,
  ) => '${multipleChoice(graphId, nodeId, questionId)}/view';
}
