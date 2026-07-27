//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_color_theme_out.g.dart';

/// UserColorThemeOut
///
/// Properties:
/// * [id] 
/// * [idUser] 
/// * [name] 
/// * [seedColor] 
/// * [overrideJson] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class UserColorThemeOut implements Built<UserColorThemeOut, UserColorThemeOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'seed_color')
  int get seedColor;

  @BuiltValueField(wireName: r'override_json')
  BuiltMap<String, JsonObject?> get overrideJson;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  UserColorThemeOut._();

  factory UserColorThemeOut([void updates(UserColorThemeOutBuilder b)]) = _$UserColorThemeOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserColorThemeOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserColorThemeOut> get serializer => _$UserColorThemeOutSerializer();
}

class _$UserColorThemeOutSerializer implements PrimitiveSerializer<UserColorThemeOut> {
  @override
  final Iterable<Type> types = const [UserColorThemeOut, _$UserColorThemeOut];

  @override
  final String wireName = r'UserColorThemeOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserColorThemeOut object, {
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
    yield r'seed_color';
    yield serializers.serialize(
      object.seedColor,
      specifiedType: const FullType(int),
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
    UserColorThemeOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserColorThemeOutBuilder result,
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
        case r'seed_color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seedColor = valueDes;
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
  UserColorThemeOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserColorThemeOutBuilder();
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

