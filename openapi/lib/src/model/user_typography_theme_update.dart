//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_typography_theme_update.g.dart';

/// UserTypographyThemeUpdate
///
/// Properties:
/// * [idUser] 
/// * [name] 
/// * [displayFont] 
/// * [bodyFont] 
/// * [monoFont] 
/// * [overrideJson] 
@BuiltValue()
abstract class UserTypographyThemeUpdate implements Built<UserTypographyThemeUpdate, UserTypographyThemeUpdateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'display_font')
  String? get displayFont;

  @BuiltValueField(wireName: r'body_font')
  String? get bodyFont;

  @BuiltValueField(wireName: r'mono_font')
  String? get monoFont;

  @BuiltValueField(wireName: r'override_json')
  String? get overrideJson;

  UserTypographyThemeUpdate._();

  factory UserTypographyThemeUpdate([void updates(UserTypographyThemeUpdateBuilder b)]) = _$UserTypographyThemeUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserTypographyThemeUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserTypographyThemeUpdate> get serializer => _$UserTypographyThemeUpdateSerializer();
}

class _$UserTypographyThemeUpdateSerializer implements PrimitiveSerializer<UserTypographyThemeUpdate> {
  @override
  final Iterable<Type> types = const [UserTypographyThemeUpdate, _$UserTypographyThemeUpdate];

  @override
  final String wireName = r'UserTypographyThemeUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserTypographyThemeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.displayFont != null) {
      yield r'display_font';
      yield serializers.serialize(
        object.displayFont,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.bodyFont != null) {
      yield r'body_font';
      yield serializers.serialize(
        object.bodyFont,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.monoFont != null) {
      yield r'mono_font';
      yield serializers.serialize(
        object.monoFont,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.overrideJson != null) {
      yield r'override_json';
      yield serializers.serialize(
        object.overrideJson,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserTypographyThemeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserTypographyThemeUpdateBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'display_font':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayFont = valueDes;
          break;
        case r'body_font':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bodyFont = valueDes;
          break;
        case r'mono_font':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.monoFont = valueDes;
          break;
        case r'override_json':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.overrideJson = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserTypographyThemeUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserTypographyThemeUpdateBuilder();
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

