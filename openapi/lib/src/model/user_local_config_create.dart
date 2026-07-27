//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_local_config_create.g.dart';

/// UserLocalConfigCreate
///
/// Properties:
/// * [idUser] 
/// * [idDevice] 
/// * [idLanguage] 
/// * [idUserColorTheme] 
/// * [idUserTypographyTheme] 
/// * [preferences] 
@BuiltValue()
abstract class UserLocalConfigCreate implements Built<UserLocalConfigCreate, UserLocalConfigCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'id_device')
  String? get idDevice;

  @BuiltValueField(wireName: r'id_language')
  String get idLanguage;

  @BuiltValueField(wireName: r'id_user_color_theme')
  String get idUserColorTheme;

  @BuiltValueField(wireName: r'id_user_typography_theme')
  String get idUserTypographyTheme;

  @BuiltValueField(wireName: r'preferences')
  String get preferences;

  UserLocalConfigCreate._();

  factory UserLocalConfigCreate([void updates(UserLocalConfigCreateBuilder b)]) = _$UserLocalConfigCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserLocalConfigCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserLocalConfigCreate> get serializer => _$UserLocalConfigCreateSerializer();
}

class _$UserLocalConfigCreateSerializer implements PrimitiveSerializer<UserLocalConfigCreate> {
  @override
  final Iterable<Type> types = const [UserLocalConfigCreate, _$UserLocalConfigCreate];

  @override
  final String wireName = r'UserLocalConfigCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserLocalConfigCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_user';
    yield serializers.serialize(
      object.idUser,
      specifiedType: const FullType(String),
    );
    if (object.idDevice != null) {
      yield r'id_device';
      yield serializers.serialize(
        object.idDevice,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    UserLocalConfigCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserLocalConfigCreateBuilder result,
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
        case r'id_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idDevice = valueDes;
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
  UserLocalConfigCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserLocalConfigCreateBuilder();
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

