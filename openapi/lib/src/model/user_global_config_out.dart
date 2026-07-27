//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_global_config_out.g.dart';

/// UserGlobalConfigOut
///
/// Properties:
/// * [id] 
/// * [idUser] 
/// * [idLanguage] 
/// * [idUserColorTheme] 
/// * [idUserTypographyTheme] 
/// * [preferences] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class UserGlobalConfigOut implements Built<UserGlobalConfigOut, UserGlobalConfigOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'id_language')
  String get idLanguage;

  @BuiltValueField(wireName: r'id_user_color_theme')
  String get idUserColorTheme;

  @BuiltValueField(wireName: r'id_user_typography_theme')
  String get idUserTypographyTheme;

  @BuiltValueField(wireName: r'preferences')
  BuiltMap<String, JsonObject?> get preferences;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  UserGlobalConfigOut._();

  factory UserGlobalConfigOut([void updates(UserGlobalConfigOutBuilder b)]) = _$UserGlobalConfigOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserGlobalConfigOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserGlobalConfigOut> get serializer => _$UserGlobalConfigOutSerializer();
}

class _$UserGlobalConfigOutSerializer implements PrimitiveSerializer<UserGlobalConfigOut> {
  @override
  final Iterable<Type> types = const [UserGlobalConfigOut, _$UserGlobalConfigOut];

  @override
  final String wireName = r'UserGlobalConfigOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserGlobalConfigOut object, {
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
    UserGlobalConfigOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserGlobalConfigOutBuilder result,
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
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.preferences.replace(valueDes);
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
  UserGlobalConfigOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserGlobalConfigOutBuilder();
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

