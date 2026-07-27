//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_color_theme_create.g.dart';

/// UserColorThemeCreate
///
/// Properties:
/// * [idUser] 
/// * [name] 
/// * [seedColor] 
/// * [overrideJson] 
@BuiltValue()
abstract class UserColorThemeCreate implements Built<UserColorThemeCreate, UserColorThemeCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'seed_color')
  int get seedColor;

  @BuiltValueField(wireName: r'override_json')
  String get overrideJson;

  UserColorThemeCreate._();

  factory UserColorThemeCreate([void updates(UserColorThemeCreateBuilder b)]) = _$UserColorThemeCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserColorThemeCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserColorThemeCreate> get serializer => _$UserColorThemeCreateSerializer();
}

class _$UserColorThemeCreateSerializer implements PrimitiveSerializer<UserColorThemeCreate> {
  @override
  final Iterable<Type> types = const [UserColorThemeCreate, _$UserColorThemeCreate];

  @override
  final String wireName = r'UserColorThemeCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserColorThemeCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserColorThemeCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserColorThemeCreateBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
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
  UserColorThemeCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserColorThemeCreateBuilder();
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

