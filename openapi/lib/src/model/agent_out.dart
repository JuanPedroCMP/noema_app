//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/task_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agent_out.g.dart';

/// AgentOut
///
/// Properties:
/// * [id] 
/// * [alias] 
/// * [task] 
/// * [baseSystemPrompt] 
/// * [temperature] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class AgentOut implements Built<AgentOut, AgentOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'alias')
  String get alias;

  @BuiltValueField(wireName: r'task')
  TaskType get task;
  // enum taskEnum {  manipulate_graph,  manipulate_node,  create_study_session,  evaluate_essay_question,  create_essay_question,  create_multiple_choice_question,  evaluate_multiple_choice_question,  create_feynman,  evaluate_feynman ,  recommend_study_resource,  study_manager,  study_assistent,  };

  @BuiltValueField(wireName: r'base_system_prompt')
  String get baseSystemPrompt;

  @BuiltValueField(wireName: r'temperature')
  num? get temperature;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  AgentOut._();

  factory AgentOut([void updates(AgentOutBuilder b)]) = _$AgentOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgentOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgentOut> get serializer => _$AgentOutSerializer();
}

class _$AgentOutSerializer implements PrimitiveSerializer<AgentOut> {
  @override
  final Iterable<Type> types = const [AgentOut, _$AgentOut];

  @override
  final String wireName = r'AgentOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgentOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'alias';
    yield serializers.serialize(
      object.alias,
      specifiedType: const FullType(String),
    );
    yield r'task';
    yield serializers.serialize(
      object.task,
      specifiedType: const FullType(TaskType),
    );
    yield r'base_system_prompt';
    yield serializers.serialize(
      object.baseSystemPrompt,
      specifiedType: const FullType(String),
    );
    yield r'temperature';
    yield object.temperature == null ? null : serializers.serialize(
      object.temperature,
      specifiedType: const FullType.nullable(num),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'updated_at';
    yield object.updatedAt == null ? null : serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AgentOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AgentOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'alias':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.alias = valueDes;
          break;
        case r'task':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaskType),
          ) as TaskType;
          result.task = valueDes;
          break;
        case r'base_system_prompt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AgentOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgentOutBuilder();
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

