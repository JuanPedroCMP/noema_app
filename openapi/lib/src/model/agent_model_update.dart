//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/agent_model_quality.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agent_model_update.g.dart';

/// AgentModelUpdate
///
/// Properties:
/// * [idAgent] 
/// * [idAiModel] 
/// * [qualityExpected] 
/// * [customSystemPrompt] 
/// * [customTemperature] 
@BuiltValue()
abstract class AgentModelUpdate implements Built<AgentModelUpdate, AgentModelUpdateBuilder> {
  @BuiltValueField(wireName: r'id_agent')
  String? get idAgent;

  @BuiltValueField(wireName: r'id_ai_model')
  String? get idAiModel;

  @BuiltValueField(wireName: r'quality_expected')
  AgentModelQuality? get qualityExpected;
  // enum qualityExpectedEnum {  unusable,  poor,  fair,  good,  very_good,  excellent,  };

  @BuiltValueField(wireName: r'custom_system_prompt')
  String? get customSystemPrompt;

  @BuiltValueField(wireName: r'custom_temperature')
  num? get customTemperature;

  AgentModelUpdate._();

  factory AgentModelUpdate([void updates(AgentModelUpdateBuilder b)]) = _$AgentModelUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgentModelUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgentModelUpdate> get serializer => _$AgentModelUpdateSerializer();
}

class _$AgentModelUpdateSerializer implements PrimitiveSerializer<AgentModelUpdate> {
  @override
  final Iterable<Type> types = const [AgentModelUpdate, _$AgentModelUpdate];

  @override
  final String wireName = r'AgentModelUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgentModelUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idAgent != null) {
      yield r'id_agent';
      yield serializers.serialize(
        object.idAgent,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idAiModel != null) {
      yield r'id_ai_model';
      yield serializers.serialize(
        object.idAiModel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.qualityExpected != null) {
      yield r'quality_expected';
      yield serializers.serialize(
        object.qualityExpected,
        specifiedType: const FullType.nullable(AgentModelQuality),
      );
    }
    if (object.customSystemPrompt != null) {
      yield r'custom_system_prompt';
      yield serializers.serialize(
        object.customSystemPrompt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.customTemperature != null) {
      yield r'custom_temperature';
      yield serializers.serialize(
        object.customTemperature,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AgentModelUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AgentModelUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_agent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idAgent = valueDes;
          break;
        case r'id_ai_model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idAiModel = valueDes;
          break;
        case r'quality_expected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AgentModelQuality),
          ) as AgentModelQuality?;
          if (valueDes == null) continue;
          result.qualityExpected = valueDes;
          break;
        case r'custom_system_prompt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customSystemPrompt = valueDes;
          break;
        case r'custom_temperature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.customTemperature = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AgentModelUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgentModelUpdateBuilder();
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

