//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_color_theme_update.g.dart';

/// UserColorThemeUpdate
///
/// Properties:
/// * [idUser] 
/// * [name] 
/// * [seedColor] 
/// * [overrideJson] 
@BuiltValue()
abstract class UserColorThemeUpdate implements Built<UserColorThemeUpdate, UserColorThemeUpdateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'seed_color')
  int? get seedColor;

  @BuiltValueField(wireName: r'override_json')
  String? get overrideJson;

  UserColorThemeUpdate._();

  factory UserColorThemeUpdate([void updates(UserColorThemeUpdateBuilder b)]) = _$UserColorThemeUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserColorThemeUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserColorThemeUpdate> get serializer => _$UserColorThemeUpdateSerializer();
}

class _$UserColorThemeUpdateSerializer implements PrimitiveSerializer<UserColorThemeUpdate> {
  @override
  final Iterable<Type> types = const [UserColorThemeUpdate, _$UserColorThemeUpdate];

  @override
  final String wireName = r'UserColorThemeUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserColorThemeUpdate object, {
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
    if (object.seedColor != null) {
      yield r'seed_color';
      yield serializers.serialize(
        object.seedColor,
        specifiedType: const FullType.nullable(int),
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
    UserColorThemeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserColorThemeUpdateBuilder result,
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
        case r'seed_color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.seedColor = valueDes;
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
  UserColorThemeUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserColorThemeUpdateBuilder();
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

