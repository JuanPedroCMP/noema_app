//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_typography_theme_out.g.dart';

/// UserTypographyThemeOut
///
/// Properties:
/// * [id] 
/// * [idUser] 
/// * [name] 
/// * [displayFont] 
/// * [bodyFont] 
/// * [monoFont] 
/// * [overrideJson] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class UserTypographyThemeOut implements Built<UserTypographyThemeOut, UserTypographyThemeOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'display_font')
  String get displayFont;

  @BuiltValueField(wireName: r'body_font')
  String get bodyFont;

  @BuiltValueField(wireName: r'mono_font')
  String get monoFont;

  @BuiltValueField(wireName: r'override_json')
  BuiltMap<String, JsonObject?> get overrideJson;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  UserTypographyThemeOut._();

  factory UserTypographyThemeOut([void updates(UserTypographyThemeOutBuilder b)]) = _$UserTypographyThemeOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserTypographyThemeOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserTypographyThemeOut> get serializer => _$UserTypographyThemeOutSerializer();
}

class _$UserTypographyThemeOutSerializer implements PrimitiveSerializer<UserTypographyThemeOut> {
  @override
  final Iterable<Type> types = const [UserTypographyThemeOut, _$UserTypographyThemeOut];

  @override
  final String wireName = r'UserTypographyThemeOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserTypographyThemeOut object, {
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
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'display_font';
    yield serializers.serialize(
      object.displayFont,
      specifiedType: const FullType(String),
    );
    yield r'body_font';
    yield serializers.serialize(
      object.bodyFont,
      specifiedType: const FullType(String),
    );
    yield r'mono_font';
    yield serializers.serialize(
      object.monoFont,
      specifiedType: const FullType(String),
    );
    yield r'override_json';
    yield serializers.serialize(
      object.overrideJson,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'updated_at';
    yield object.updatedAt == null ? null : serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserTypographyThemeOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserTypographyThemeOutBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'display_font':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayFont = valueDes;
          break;
        case r'body_font':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bodyFont = valueDes;
          break;
        case r'mono_font':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.monoFont = valueDes;
          break;
        case r'override_json':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.overrideJson.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserTypographyThemeOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserTypographyThemeOutBuilder();
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

