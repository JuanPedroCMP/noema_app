//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_usage_log_create.g.dart';

/// AiUsageLogCreate
///
/// Properties:
/// * [idUser] 
/// * [idAgentModel] 
/// * [usageDatails] 
@BuiltValue()
abstract class AiUsageLogCreate implements Built<AiUsageLogCreate, AiUsageLogCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'id_agent_model')
  String get idAgentModel;

  @BuiltValueField(wireName: r'usage_datails')
  String get usageDatails;

  AiUsageLogCreate._();

  factory AiUsageLogCreate([void updates(AiUsageLogCreateBuilder b)]) = _$AiUsageLogCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiUsageLogCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiUsageLogCreate> get serializer => _$AiUsageLogCreateSerializer();
}

class _$AiUsageLogCreateSerializer implements PrimitiveSerializer<AiUsageLogCreate> {
  @override
  final Iterable<Type> types = const [AiUsageLogCreate, _$AiUsageLogCreate];

  @override
  final String wireName = r'AiUsageLogCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiUsageLogCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_user';
    yield serializers.serialize(
      object.idUser,
      specifiedType: const FullType(String),
    );
    yield r'id_agent_model';
    yield serializers.serialize(
      object.idAgentModel,
      specifiedType: const FullType(String),
    );
    yield r'usage_datails';
    yield serializers.serialize(
      object.usageDatails,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AiUsageLogCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiUsageLogCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idUser = valueDes;
          break;
        case r'id_agent_model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAgentModel = valueDes;
          break;
        case r'usage_datails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.usageDatails = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AiUsageLogCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiUsageLogCreateBuilder();
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

