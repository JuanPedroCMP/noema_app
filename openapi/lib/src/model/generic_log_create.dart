//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generic_log_create.g.dart';

/// GenericLogCreate
///
/// Properties:
/// * [idUser] 
/// * [type] 
/// * [details] 
@BuiltValue()
abstract class GenericLogCreate implements Built<GenericLogCreate, GenericLogCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'details')
  String get details;

  GenericLogCreate._();

  factory GenericLogCreate([void updates(GenericLogCreateBuilder b)]) = _$GenericLogCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GenericLogCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GenericLogCreate> get serializer => _$GenericLogCreateSerializer();
}

class _$GenericLogCreateSerializer implements PrimitiveSerializer<GenericLogCreate> {
  @override
  final Iterable<Type> types = const [GenericLogCreate, _$GenericLogCreate];

  @override
  final String wireName = r'GenericLogCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GenericLogCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_user';
    yield object.idUser == null ? null : serializers.serialize(
      object.idUser,
      specifiedType: const FullType.nullable(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'details';
    yield serializers.serialize(
      object.details,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GenericLogCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GenericLogCreateBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.details = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GenericLogCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GenericLogCreateBuilder();
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

