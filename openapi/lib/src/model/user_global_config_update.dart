//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_global_config_update.g.dart';

/// UserGlobalConfigUpdate
///
/// Properties:
/// * [idUser] 
/// * [idLanguage] 
/// * [idUserColorTheme] 
/// * [idUserTypographyTheme] 
/// * [preferences] 
@BuiltValue()
abstract class UserGlobalConfigUpdate implements Built<UserGlobalConfigUpdate, UserGlobalConfigUpdateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'id_language')
  String? get idLanguage;

  @BuiltValueField(wireName: r'id_user_color_theme')
  String? get idUserColorTheme;

  @BuiltValueField(wireName: r'id_user_typography_theme')
  String? get idUserTypographyTheme;

  @BuiltValueField(wireName: r'preferences')
  String? get preferences;

  UserGlobalConfigUpdate._();

  factory UserGlobalConfigUpdate([void updates(UserGlobalConfigUpdateBuilder b)]) = _$UserGlobalConfigUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserGlobalConfigUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserGlobalConfigUpdate> get serializer => _$UserGlobalConfigUpdateSerializer();
}

class _$UserGlobalConfigUpdateSerializer implements PrimitiveSerializer<UserGlobalConfigUpdate> {
  @override
  final Iterable<Type> types = const [UserGlobalConfigUpdate, _$UserGlobalConfigUpdate];

  @override
  final String wireName = r'UserGlobalConfigUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserGlobalConfigUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idUser != null) {
      yield r'id_user';
      yield serializers.serialize(
        object.idUser,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idLanguage != null) {
      yield r'id_language';
      yield serializers.serialize(
        object.idLanguage,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idUserColorTheme != null) {
      yield r'id_user_color_theme';
      yield serializers.serialize(
        object.idUserColorTheme,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idUserTypographyTheme != null) {
      yield r'id_user_typography_theme';
      yield serializers.serialize(
        object.idUserTypographyTheme,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.preferences != null) {
      yield r'preferences';
      yield serializers.serialize(
        object.preferences,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserGlobalConfigUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserGlobalConfigUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idUser = valueDes;
          break;
        case r'id_language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idLanguage = valueDes;
          break;
        case r'id_user_color_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idUserColorTheme = valueDes;
          break;
        case r'id_user_typography_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idUserTypographyTheme = valueDes;
          break;
        case r'preferences':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  UserGlobalConfigUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserGlobalConfigUpdateBuilder();
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

