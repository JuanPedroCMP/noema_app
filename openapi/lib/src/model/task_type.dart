//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'task_type.g.dart';

class TaskType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'manipulate_graph')
  static const TaskType manipulateGraph = _$manipulateGraph;
  @BuiltValueEnumConst(wireName: r'manipulate_node')
  static const TaskType manipulateNode = _$manipulateNode;
  @BuiltValueEnumConst(wireName: r'create_study_session')
  static const TaskType createStudySession = _$createStudySession;
  @BuiltValueEnumConst(wireName: r'evaluate_essay_question')
  static const TaskType evaluateEssayQuestion = _$evaluateEssayQuestion;
  @BuiltValueEnumConst(wireName: r'create_essay_question')
  static const TaskType createEssayQuestion = _$createEssayQuestion;
  @BuiltValueEnumConst(wireName: r'create_multiple_choice_question')
  static const TaskType createMultipleChoiceQuestion = _$createMultipleChoiceQuestion;
  @BuiltValueEnumConst(wireName: r'evaluate_multiple_choice_question')
  static const TaskType evaluateMultipleChoiceQuestion = _$evaluateMultipleChoiceQuestion;
  @BuiltValueEnumConst(wireName: r'create_feynman')
  static const TaskType createFeynman = _$createFeynman;
  @BuiltValueEnumConst(wireName: r'evaluate_feynman ')
  static const TaskType evaluateFeynman = _$evaluateFeynman;
  @BuiltValueEnumConst(wireName: r'recommend_study_resource')
  static const TaskType recommendStudyResource = _$recommendStudyResource;
  @BuiltValueEnumConst(wireName: r'study_manager')
  static const TaskType studyManager = _$studyManager;
  @BuiltValueEnumConst(wireName: r'study_assistent')
  static const TaskType studyAssistent = _$studyAssistent;

  static Serializer<TaskType> get serializer => _$taskTypeSerializer;

  const TaskType._(String name): super(name);

  static BuiltSet<TaskType> get values => _$values;
  static TaskType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TaskTypeMixin = Object with _$TaskTypeMixin;

