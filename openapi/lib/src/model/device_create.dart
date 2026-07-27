//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_create.g.dart';

/// DeviceCreate
///
/// Properties:
/// * [idUser] 
/// * [deviceName] 
/// * [deviceFingerprint] 
/// * [platform] 
@BuiltValue()
abstract class DeviceCreate implements Built<DeviceCreate, DeviceCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'device_name')
  String get deviceName;

  @BuiltValueField(wireName: r'device_fingerprint')
  String get deviceFingerprint;

  @BuiltValueField(wireName: r'platform')
  String get platform;

  DeviceCreate._();

  factory DeviceCreate([void updates(DeviceCreateBuilder b)]) = _$DeviceCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceCreate> get serializer => _$DeviceCreateSerializer();
}

class _$DeviceCreateSerializer implements PrimitiveSerializer<DeviceCreate> {
  @override
  final Iterable<Type> types = const [DeviceCreate, _$DeviceCreate];

  @override
  final String wireName = r'DeviceCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_user';
    yield serializers.serialize(
      object.idUser,
      specifiedType: const FullType(String),
    );
    yield r'device_name';
    yield serializers.serialize(
      object.deviceName,
      specifiedType: const FullType(String),
    );
    yield r'device_fingerprint';
    yield serializers.serialize(
      object.deviceFingerprint,
      specifiedType: const FullType(String),
    );
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeviceCreateBuilder result,
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
        case r'device_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceName = valueDes;
          break;
        case r'device_fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceFingerprint = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.platform = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceCreateBuilder();
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

