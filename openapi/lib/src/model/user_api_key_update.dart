//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_api_key_update.g.dart';

/// UserApiKeyUpdate
///
/// Properties:
/// * [idAiProvider] 
/// * [idUser] 
/// * [name] 
/// * [apiKey] 
/// * [isActive] 
@BuiltValue()
abstract class UserApiKeyUpdate implements Built<UserApiKeyUpdate, UserApiKeyUpdateBuilder> {
  @BuiltValueField(wireName: r'id_ai_provider')
  String? get idAiProvider;

  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'api_key')
  String? get apiKey;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  UserApiKeyUpdate._();

  factory UserApiKeyUpdate([void updates(UserApiKeyUpdateBuilder b)]) = _$UserApiKeyUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserApiKeyUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserApiKeyUpdate> get serializer => _$UserApiKeyUpdateSerializer();
}

class _$UserApiKeyUpdateSerializer implements PrimitiveSerializer<UserApiKeyUpdate> {
  @override
  final Iterable<Type> types = const [UserApiKeyUpdate, _$UserApiKeyUpdate];

  @override
  final String wireName = r'UserApiKeyUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserApiKeyUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idAiProvider != null) {
      yield r'id_ai_provider';
      yield serializers.serialize(
        object.idAiProvider,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idUser != null) {
      yield r'id_user';
      yield serializers.serialize(
        object.idUser,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.apiKey != null) {
      yield r'api_key';
      yield serializers.serialize(
        object.apiKey,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserApiKeyUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserApiKeyUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_ai_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idAiProvider = valueDes;
          break;
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idUser = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'api_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.apiKey = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserApiKeyUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserApiKeyUpdateBuilder();
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

