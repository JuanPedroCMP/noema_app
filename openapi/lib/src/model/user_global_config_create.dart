//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_global_config_create.g.dart';

/// UserGlobalConfigCreate
///
/// Properties:
/// * [idUser] 
/// * [idLanguage] 
/// * [idUserColorTheme] 
/// * [idUserTypographyTheme] 
/// * [preferences] 
@BuiltValue()
abstract class UserGlobalConfigCreate implements Built<UserGlobalConfigCreate, UserGlobalConfigCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'id_language')
  String get idLanguage;

  @BuiltValueField(wireName: r'id_user_color_theme')
  String get idUserColorTheme;

  @BuiltValueField(wireName: r'id_user_typography_theme')
  String get idUserTypographyTheme;

  @BuiltValueField(wireName: r'preferences')
  String get preferences;

  UserGlobalConfigCreate._();

  factory UserGlobalConfigCreate([void updates(UserGlobalConfigCreateBuilder b)]) = _$UserGlobalConfigCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserGlobalConfigCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserGlobalConfigCreate> get serializer => _$UserGlobalConfigCreateSerializer();
}

class _$UserGlobalConfigCreateSerializer implements PrimitiveSerializer<UserGlobalConfigCreate> {
  @override
  final Iterable<Type> types = const [UserGlobalConfigCreate, _$UserGlobalConfigCreate];

  @override
  final String wireName = r'UserGlobalConfigCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserGlobalConfigCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_user';
    yield serializers.serialize(
      object.idUser,
      specifiedType: const FullType(String),
    );
    yield r'id_language';
    yield serializers.serialize(
      object.idLanguage,
      specifiedType: const FullType(String),
    );
    yield r'id_user_color_theme';
    yield serializers.serialize(
      object.idUserColorTheme,
      specifiedType: const FullType(String),
    );
    yield r'id_user_typography_theme';
    yield serializers.serialize(
      object.idUserTypographyTheme,
      specifiedType: const FullType(String),
    );
    yield r'preferences';
    yield serializers.serialize(
      object.preferences,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserGlobalConfigCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserGlobalConfigCreateBuilder result,
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
        case r'id_language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idLanguage = valueDes;
          break;
        case r'id_user_color_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idUserColorTheme = valueDes;
          break;
        case r'id_user_typography_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idUserTypographyTheme = valueDes;
          break;
        case r'preferences':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.preferences = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserGlobalConfigCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserGlobalConfigCreateBuilder();
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

