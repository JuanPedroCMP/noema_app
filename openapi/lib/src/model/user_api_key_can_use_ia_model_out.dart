//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_api_key_can_use_ia_model_out.g.dart';

/// UserApiKeyCanUseIaModelOut
///
/// Properties:
/// * [id] 
/// * [idAiModel] 
/// * [idUserApiKey] 
/// * [createdAt] 
@BuiltValue()
abstract class UserApiKeyCanUseIaModelOut implements Built<UserApiKeyCanUseIaModelOut, UserApiKeyCanUseIaModelOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_ai_model')
  String get idAiModel;

  @BuiltValueField(wireName: r'id_user_api_key')
  String get idUserApiKey;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  UserApiKeyCanUseIaModelOut._();

  factory UserApiKeyCanUseIaModelOut([void updates(UserApiKeyCanUseIaModelOutBuilder b)]) = _$UserApiKeyCanUseIaModelOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserApiKeyCanUseIaModelOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserApiKeyCanUseIaModelOut> get serializer => _$UserApiKeyCanUseIaModelOutSerializer();
}

class _$UserApiKeyCanUseIaModelOutSerializer implements PrimitiveSerializer<UserApiKeyCanUseIaModelOut> {
  @override
  final Iterable<Type> types = const [UserApiKeyCanUseIaModelOut, _$UserApiKeyCanUseIaModelOut];

  @override
  final String wireName = r'UserApiKeyCanUseIaModelOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserApiKeyCanUseIaModelOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'id_ai_model';
    yield serializers.serialize(
      object.idAiModel,
      specifiedType: const FullType(String),
    );
    yield r'id_user_api_key';
    yield serializers.serialize(
      object.idUserApiKey,
      specifiedType: const FullType(String),
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
    UserApiKeyCanUseIaModelOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserApiKeyCanUseIaModelOutBuilder result,
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
        case r'id_ai_model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAiModel = valueDes;
          break;
        case r'id_user_api_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idUserApiKey = valueDes;
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
  UserApiKeyCanUseIaModelOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserApiKeyCanUseIaModelOutBuilder();
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

