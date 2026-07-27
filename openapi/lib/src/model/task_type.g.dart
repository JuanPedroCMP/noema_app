// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaskType _$manipulateGraph = const TaskType._('manipulateGraph');
const TaskType _$manipulateNode = const TaskType._('manipulateNode');
const TaskType _$createStudySession = const TaskType._('createStudySession');
const TaskType _$evaluateEssayQuestion =
    const TaskType._('evaluateEssayQuestion');
const TaskType _$createEssayQuestion = const TaskType._('createEssayQuestion');
const TaskType _$createMultipleChoiceQuestion =
    const TaskType._('createMultipleChoiceQuestion');
const TaskType _$evaluateMultipleChoiceQuestion =
    const TaskType._('evaluateMultipleChoiceQuestion');
const TaskType _$createFeynman = const TaskType._('createFeynman');
const TaskType _$evaluateFeynman = const TaskType._('evaluateFeynman');
const TaskType _$recommendStudyResource =
    const TaskType._('recommendStudyResource');
const TaskType _$studyManager = const TaskType._('studyManager');
const TaskType _$studyAssistent = const TaskType._('studyAssistent');

TaskType _$valueOf(String name) {
  switch (name) {
    case 'manipulateGraph':
      return _$manipulateGraph;
    case 'manipulateNode':
      return _$manipulateNode;
    case 'createStudySession':
      return _$createStudySession;
    case 'evaluateEssayQuestion':
      return _$evaluateEssayQuestion;
    case 'createEssayQuestion':
      return _$createEssayQuestion;
    case 'createMultipleChoiceQuestion':
      return _$createMultipleChoiceQuestion;
    case 'evaluateMultipleChoiceQuestion':
      return _$evaluateMultipleChoiceQuestion;
    case 'createFeynman':
      return _$createFeynman;
    case 'evaluateFeynman':
      return _$evaluateFeynman;
    case 'recommendStudyResource':
      return _$recommendStudyResource;
    case 'studyManager':
      return _$studyManager;
    case 'studyAssistent':
      return _$studyAssistent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaskType> _$values = BuiltSet<TaskType>(const <TaskType>[
  _$manipulateGraph,
  _$manipulateNode,
  _$createStudySession,
  _$evaluateEssayQuestion,
  _$createEssayQuestion,
  _$createMultipleChoiceQuestion,
  _$evaluateMultipleChoiceQuestion,
  _$createFeynman,
  _$evaluateFeynman,
  _$recommendStudyResource,
  _$studyManager,
  _$studyAssistent,
]);

class _$TaskTypeMeta {
  const _$TaskTypeMeta();
  TaskType get manipulateGraph => _$manipulateGraph;
  TaskType get manipulateNode => _$manipulateNode;
  TaskType get createStudySession => _$createStudySession;
  TaskType get evaluateEssayQuestion => _$evaluateEssayQuestion;
  TaskType get createEssayQuestion => _$createEssayQuestion;
  TaskType get createMultipleChoiceQuestion => _$createMultipleChoiceQuestion;
  TaskType get evaluateMultipleChoiceQuestion =>
      _$evaluateMultipleChoiceQuestion;
  TaskType get createFeynman => _$createFeynman;
  TaskType get evaluateFeynman => _$evaluateFeynman;
  TaskType get recommendStudyResource => _$recommendStudyResource;
  TaskType get studyManager => _$studyManager;
  TaskType get studyAssistent => _$studyAssistent;
  TaskType valueOf(String name) => _$valueOf(name);
  BuiltSet<TaskType> get values => _$values;
}

abstract class _$TaskTypeMixin {
  // ignore: non_constant_identifier_names
  _$TaskTypeMeta get TaskType => const _$TaskTypeMeta();
}

Serializer<TaskType> _$taskTypeSerializer = _$TaskTypeSerializer();

class _$TaskTypeSerializer implements PrimitiveSerializer<TaskType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manipulateGraph': 'manipulate_graph',
    'manipulateNode': 'manipulate_node',
    'createStudySession': 'create_study_session',
    'evaluateEssayQuestion': 'evaluate_essay_question',
    'createEssayQuestion': 'create_essay_question',
    'createMultipleChoiceQuestion': 'create_multiple_choice_question',
    'evaluateMultipleChoiceQuestion': 'evaluate_multiple_choice_question',
    'createFeynman': 'create_feynman',
    'evaluateFeynman': 'evaluate_feynman ',
    'recommendStudyResource': 'recommend_study_resource',
    'studyManager': 'study_manager',
    'studyAssistent': 'study_assistent',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manipulate_graph': 'manipulateGraph',
    'manipulate_node': 'manipulateNode',
    'create_study_session': 'createStudySession',
    'evaluate_essay_question': 'evaluateEssayQuestion',
    'create_essay_question': 'createEssayQuestion',
    'create_multiple_choice_question': 'createMultipleChoiceQuestion',
    'evaluate_multiple_choice_question': 'evaluateMultipleChoiceQuestion',
    'create_feynman': 'createFeynman',
    'evaluate_feynman ': 'evaluateFeynman',
    'recommend_study_resource': 'recommendStudyResource',
    'study_manager': 'studyManager',
    'study_assistent': 'studyAssistent',
  };

  @override
  final Iterable<Type> types = const <Type>[TaskType];
  @override
  final String wireName = 'TaskType';

  @override
  Object serialize(Serializers serializers, TaskType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaskType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaskType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
