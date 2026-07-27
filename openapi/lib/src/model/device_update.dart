//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_update.g.dart';

/// DeviceUpdate
///
/// Properties:
/// * [idUser] 
/// * [deviceName] 
/// * [deviceFingerprint] 
/// * [platform] 
/// * [lastSeenAt] 
@BuiltValue()
abstract class DeviceUpdate implements Built<DeviceUpdate, DeviceUpdateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'device_name')
  String? get deviceName;

  @BuiltValueField(wireName: r'device_fingerprint')
  String? get deviceFingerprint;

  @BuiltValueField(wireName: r'platform')
  String? get platform;

  @BuiltValueField(wireName: r'last_seen_at')
  DateTime? get lastSeenAt;

  DeviceUpdate._();

  factory DeviceUpdate([void updates(DeviceUpdateBuilder b)]) = _$DeviceUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceUpdate> get serializer => _$DeviceUpdateSerializer();
}

class _$DeviceUpdateSerializer implements PrimitiveSerializer<DeviceUpdate> {
  @override
  final Iterable<Type> types = const [DeviceUpdate, _$DeviceUpdate];

  @override
  final String wireName = r'DeviceUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idUser != null) {
      yield r'id_user';
      yield serializers.serialize(
        object.idUser,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.deviceName != null) {
      yield r'device_name';
      yield serializers.serialize(
        object.deviceName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.deviceFingerprint != null) {
      yield r'device_fingerprint';
      yield serializers.serialize(
        object.deviceFingerprint,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.platform != null) {
      yield r'platform';
      yield serializers.serialize(
        object.platform,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.lastSeenAt != null) {
      yield r'last_seen_at';
      yield serializers.serialize(
        object.lastSeenAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeviceUpdateBuilder result,
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
        case r'device_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceName = valueDes;
          break;
        case r'device_fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceFingerprint = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.platform = valueDes;
          break;
        case r'last_seen_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastSeenAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceUpdateBuilder();
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

