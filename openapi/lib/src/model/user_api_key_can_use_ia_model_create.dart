//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_api_key_can_use_ia_model_create.g.dart';

/// UserApiKeyCanUseIaModelCreate
///
/// Properties:
/// * [idAiModel] 
/// * [idUserApiKey] 
@BuiltValue()
abstract class UserApiKeyCanUseIaModelCreate implements Built<UserApiKeyCanUseIaModelCreate, UserApiKeyCanUseIaModelCreateBuilder> {
  @BuiltValueField(wireName: r'id_ai_model')
  String get idAiModel;

  @BuiltValueField(wireName: r'id_user_api_key')
  String get idUserApiKey;

  UserApiKeyCanUseIaModelCreate._();

  factory UserApiKeyCanUseIaModelCreate([void updates(UserApiKeyCanUseIaModelCreateBuilder b)]) = _$UserApiKeyCanUseIaModelCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserApiKeyCanUseIaModelCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserApiKeyCanUseIaModelCreate> get serializer => _$UserApiKeyCanUseIaModelCreateSerializer();
}

class _$UserApiKeyCanUseIaModelCreateSerializer implements PrimitiveSerializer<UserApiKeyCanUseIaModelCreate> {
  @override
  final Iterable<Type> types = const [UserApiKeyCanUseIaModelCreate, _$UserApiKeyCanUseIaModelCreate];

  @override
  final String wireName = r'UserApiKeyCanUseIaModelCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserApiKeyCanUseIaModelCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UserApiKeyCanUseIaModelCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserApiKeyCanUseIaModelCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserApiKeyCanUseIaModelCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserApiKeyCanUseIaModelCreateBuilder();
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

