//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_api_key_create.g.dart';

/// UserApiKeyCreate
///
/// Properties:
/// * [idAiProvider] 
/// * [name] 
/// * [apiKey] 
/// * [isActive] 
@BuiltValue()
abstract class UserApiKeyCreate implements Built<UserApiKeyCreate, UserApiKeyCreateBuilder> {
  @BuiltValueField(wireName: r'id_ai_provider')
  String get idAiProvider;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'api_key')
  String get apiKey;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  UserApiKeyCreate._();

  factory UserApiKeyCreate([void updates(UserApiKeyCreateBuilder b)]) = _$UserApiKeyCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserApiKeyCreateBuilder b) => b
      ..isActive = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserApiKeyCreate> get serializer => _$UserApiKeyCreateSerializer();
}

class _$UserApiKeyCreateSerializer implements PrimitiveSerializer<UserApiKeyCreate> {
  @override
  final Iterable<Type> types = const [UserApiKeyCreate, _$UserApiKeyCreate];

  @override
  final String wireName = r'UserApiKeyCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserApiKeyCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_ai_provider';
    yield serializers.serialize(
      object.idAiProvider,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'api_key';
    yield serializers.serialize(
      object.apiKey,
      specifiedType: const FullType(String),
    );
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserApiKeyCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserApiKeyCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_ai_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAiProvider = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'api_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apiKey = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  UserApiKeyCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserApiKeyCreateBuilder();
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

