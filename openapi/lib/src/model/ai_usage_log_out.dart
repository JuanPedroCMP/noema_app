//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_usage_log_out.g.dart';

/// AiUsageLogOut
///
/// Properties:
/// * [id] 
/// * [idUser] 
/// * [idAgentModel] 
/// * [usageDetails] 
/// * [createdAt] 
@BuiltValue()
abstract class AiUsageLogOut implements Built<AiUsageLogOut, AiUsageLogOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'id_agent_model')
  String get idAgentModel;

  @BuiltValueField(wireName: r'usage_details')
  BuiltMap<String, JsonObject?> get usageDetails;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  AiUsageLogOut._();

  factory AiUsageLogOut([void updates(AiUsageLogOutBuilder b)]) = _$AiUsageLogOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiUsageLogOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiUsageLogOut> get serializer => _$AiUsageLogOutSerializer();
}

class _$AiUsageLogOutSerializer implements PrimitiveSerializer<AiUsageLogOut> {
  @override
  final Iterable<Type> types = const [AiUsageLogOut, _$AiUsageLogOut];

  @override
  final String wireName = r'AiUsageLogOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiUsageLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'usage_details';
    yield serializers.serialize(
      object.usageDetails,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AiUsageLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiUsageLogOutBuilder result,
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
        case r'usage_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.usageDetails.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AiUsageLogOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiUsageLogOutBuilder();
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


