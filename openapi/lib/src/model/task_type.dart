//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum TaskType {
  @JsonValue(r'manipulate_graph')
  manipulateGraph(r'manipulate_graph'),
  @JsonValue(r'manipulate_node')
  manipulateNode(r'manipulate_node'),
  @JsonValue(r'create_study_session')
  createStudySession(r'create_study_session'),
  @JsonValue(r'evaluate_essay_question')
  evaluateEssayQuestion(r'evaluate_essay_question'),
  @JsonValue(r'create_essay_question')
  createEssayQuestion(r'create_essay_question'),
  @JsonValue(r'create_multiple_choice_question')
  createMultipleChoiceQuestion(r'create_multiple_choice_question'),
  @JsonValue(r'evaluate_multiple_choice_question')
  evaluateMultipleChoiceQuestion(r'evaluate_multiple_choice_question'),
  @JsonValue(r'create_feynman')
  createFeynman(r'create_feynman'),
  @JsonValue(r'evaluate_feynman ')
  evaluateFeynman(r'evaluate_feynman '),
  @JsonValue(r'recommend_study_resource')
  recommendStudyResource(r'recommend_study_resource'),
  @JsonValue(r'study_manager')
  studyManager(r'study_manager'),
  @JsonValue(r'study_assistent')
  studyAssistent(r'study_assistent'),
  @JsonValue(r'create_flashcard_group')
  createFlashcardGroup(r'create_flashcard_group'),
  @JsonValue(r'manipulate_flashcard_group')
  manipulateFlashcardGroup(r'manipulate_flashcard_group'),
  @JsonValue(r'create_flashcard')
  createFlashcard(r'create_flashcard'),
  @JsonValue(r'create_flashcardS')
  createFlashcardS(r'create_flashcardS');

  const TaskType(this.value);

  final String value;

  @override
  String toString() => value;
}
