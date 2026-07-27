//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/task_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agent_update.g.dart';

/// AgentUpdate
///
/// Properties:
/// * [alias] 
/// * [task] 
/// * [baseSystemPrompt] 
/// * [temperature] 
@BuiltValue()
abstract class AgentUpdate implements Built<AgentUpdate, AgentUpdateBuilder> {
  @BuiltValueField(wireName: r'alias')
  String? get alias;

  @BuiltValueField(wireName: r'task')
  TaskType? get task;
  // enum taskEnum {  manipulate_graph,  manipulate_node,  create_study_session,  evaluate_essay_question,  create_essay_question,  create_multiple_choice_question,  evaluate_multiple_choice_question,  create_feynman,  evaluate_feynman ,  recommend_study_resource,  study_manager,  study_assistent,  };

  @BuiltValueField(wireName: r'base_system_prompt')
  String? get baseSystemPrompt;

  @BuiltValueField(wireName: r'temperature')
  num? get temperature;

  AgentUpdate._();

  factory AgentUpdate([void updates(AgentUpdateBuilder b)]) = _$AgentUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgentUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgentUpdate> get serializer => _$AgentUpdateSerializer();
}

class _$AgentUpdateSerializer implements PrimitiveSerializer<AgentUpdate> {
  @override
  final Iterable<Type> types = const [AgentUpdate, _$AgentUpdate];

  @override
  final String wireName = r'AgentUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgentUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.alias != null) {
      yield r'alias';
      yield serializers.serialize(
        object.alias,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.task != null) {
      yield r'task';
      yield serializers.serialize(
        object.task,
        specifiedType: const FullType.nullable(TaskType),
      );
    }
    if (object.baseSystemPrompt != null) {
      yield r'base_system_prompt';
      yield serializers.serialize(
        object.baseSystemPrompt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.temperature != null) {
      yield r'temperature';
      yield serializers.serialize(
        object.temperature,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AgentUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AgentUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'alias':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alias = valueDes;
          break;
        case r'task':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TaskType),
          ) as TaskType?;
          if (valueDes == null) continue;
          result.task = valueDes;
          break;
        case r'base_system_prompt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.baseSystemPrompt = valueDes;
          break;
        case r'temperature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.temperature = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AgentUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgentUpdateBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

