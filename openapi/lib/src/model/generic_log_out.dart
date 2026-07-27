//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generic_log_out.g.dart';

/// GenericLogOut
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [idUser] 
/// * [details] 
/// * [createdAt] 
@BuiltValue()
abstract class GenericLogOut implements Built<GenericLogOut, GenericLogOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'details')
  JsonObject? get details;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  GenericLogOut._();

  factory GenericLogOut([void updates(GenericLogOutBuilder b)]) = _$GenericLogOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GenericLogOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GenericLogOut> get serializer => _$GenericLogOutSerializer();
}

class _$GenericLogOutSerializer implements PrimitiveSerializer<GenericLogOut> {
  @override
  final Iterable<Type> types = const [GenericLogOut, _$GenericLogOut];

  @override
  final String wireName = r'GenericLogOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GenericLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'id_user';
    yield object.idUser == null ? null : serializers.serialize(
      object.idUser,
      specifiedType: const FullType.nullable(String),
    );
    yield r'details';
    yield object.details == null ? null : serializers.serialize(
      object.details,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GenericLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GenericLogOutBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idUser = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.details = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GenericLogOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GenericLogOutBuilder();
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

