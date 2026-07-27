//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/agent_model_quality.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agent_model_out.g.dart';

/// AgentModelOut
///
/// Properties:
/// * [id] 
/// * [idAgent] 
/// * [idAiModel] 
/// * [qualityExpected] 
/// * [customSystemPrompt] 
/// * [customTemperature] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class AgentModelOut implements Built<AgentModelOut, AgentModelOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_agent')
  String get idAgent;

  @BuiltValueField(wireName: r'id_ai_model')
  String get idAiModel;

  @BuiltValueField(wireName: r'quality_expected')
  AgentModelQuality get qualityExpected;
  // enum qualityExpectedEnum {  unusable,  poor,  fair,  good,  very_good,  excellent,  };

  @BuiltValueField(wireName: r'custom_system_prompt')
  String get customSystemPrompt;

  @BuiltValueField(wireName: r'custom_temperature')
  num? get customTemperature;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  AgentModelOut._();

  factory AgentModelOut([void updates(AgentModelOutBuilder b)]) = _$AgentModelOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgentModelOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgentModelOut> get serializer => _$AgentModelOutSerializer();
}

class _$AgentModelOutSerializer implements PrimitiveSerializer<AgentModelOut> {
  @override
  final Iterable<Type> types = const [AgentModelOut, _$AgentModelOut];

  @override
  final String wireName = r'AgentModelOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgentModelOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'custom_temperature';
    yield object.customTemperature == null ? null : serializers.serialize(
      object.customTemperature,
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
    AgentModelOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AgentModelOutBuilder result,
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
        case r'custom_temperature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.customTemperature = valueDes;
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
  AgentModelOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgentModelOutBuilder();
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

