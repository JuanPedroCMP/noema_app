//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/agent_model_quality.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agent_model_create.g.dart';

/// AgentModelCreate
///
/// Properties:
/// * [idAgent] 
/// * [idAiModel] 
/// * [qualityExpected] 
/// * [customSystemPrompt] 
/// * [temperature] 
@BuiltValue()
abstract class AgentModelCreate implements Built<AgentModelCreate, AgentModelCreateBuilder> {
  @BuiltValueField(wireName: r'id_agent')
  String get idAgent;

  @BuiltValueField(wireName: r'id_ai_model')
  String get idAiModel;

  @BuiltValueField(wireName: r'quality_expected')
  AgentModelQuality get qualityExpected;
  // enum qualityExpectedEnum {  unusable,  poor,  fair,  good,  very_good,  excellent,  };

  @BuiltValueField(wireName: r'custom_system_prompt')
  String get customSystemPrompt;

  @BuiltValueField(wireName: r'temperature')
  num? get temperature;

  AgentModelCreate._();

  factory AgentModelCreate([void updates(AgentModelCreateBuilder b)]) = _$AgentModelCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgentModelCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgentModelCreate> get serializer => _$AgentModelCreateSerializer();
}

class _$AgentModelCreateSerializer implements PrimitiveSerializer<AgentModelCreate> {
  @override
  final Iterable<Type> types = const [AgentModelCreate, _$AgentModelCreate];

  @override
  final String wireName = r'AgentModelCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgentModelCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_agent';
    yield serializers.serialize(
      object.idAgent,
      specifiedType: const FullType(String),
    );
    yield r'id_ai_model';
    yield serializers.serialize(
      object.idAiModel,
      specifiedType: const FullType(String),
    );
    yield r'quality_expected';
    yield serializers.serialize(
      object.qualityExpected,
      specifiedType: const FullType(AgentModelQuality),
    );
    yield r'custom_system_prompt';
    yield serializers.serialize(
      object.customSystemPrompt,
      specifiedType: const FullType(String),
    );
    yield r'temperature';
    yield object.temperature == null ? null : serializers.serialize(
      object.temperature,
      specifiedType: const FullType.nullable(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AgentModelCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AgentModelCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_agent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAgent = valueDes;
          break;
        case r'id_ai_model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAiModel = valueDes;
          break;
        case r'quality_expected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AgentModelQuality),
          ) as AgentModelQuality;
          result.qualityExpected = valueDes;
          break;
        case r'custom_system_prompt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.customSystemPrompt = valueDes;
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
  AgentModelCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgentModelCreateBuilder();
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

