// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeviceOutCWProxy {
  DeviceOut id(String id);

  DeviceOut idUser(String idUser);

  DeviceOut deviceName(String deviceName);

  DeviceOut deviceFingerprint(String deviceFingerprint);

  DeviceOut platform(String platform);

  DeviceOut lastSeenAt(DateTime? lastSeenAt);

  DeviceOut createdAt(DateTime? createdAt);

  DeviceOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `DeviceOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DeviceOut(...).copyWith(id: 12, name: "My name")
  /// ```
  DeviceOut call({
    String id,
    String idUser,
    String deviceName,
    String deviceFingerprint,
    String platform,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDeviceOut.copyWith(...)` or call `instanceOfDeviceOut.copyWith.fieldName(value)` for a single field.
class _$DeviceOutCWProxyImpl implements _$DeviceOutCWProxy {
  const _$DeviceOutCWProxyImpl(this._value);

  final DeviceOut _value;

  @override
  DeviceOut id(String id) => call(id: id);

  @override
  DeviceOut idUser(String idUser) => call(idUser: idUser);

  @override
  DeviceOut deviceName(String deviceName) => call(deviceName: deviceName);

  @override
  DeviceOut deviceFingerprint(String deviceFingerprint) =>
      call(deviceFingerprint: deviceFingerprint);

  @override
  DeviceOut platform(String platform) => call(platform: platform);

  @override
  DeviceOut lastSeenAt(DateTime? lastSeenAt) => call(lastSeenAt: lastSeenAt);

  @override
  DeviceOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  DeviceOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `DeviceOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DeviceOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  DeviceOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? deviceName = const $CopyWithPlaceholder(),
    Object? deviceFingerprint = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? lastSeenAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return DeviceOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      deviceName:
          deviceName == const $CopyWithPlaceholder() || deviceName == null
          ? _value.deviceName
          // ignore: cast_nullable_to_non_nullable
          : deviceName as String,
      deviceFingerprint:
          deviceFingerprint == const $CopyWithPlaceholder() ||
              deviceFingerprint == null
          ? _value.deviceFingerprint
          // ignore: cast_nullable_to_non_nullable
          : deviceFingerprint as String,
      platform: platform == const $CopyWithPlaceholder() || platform == null
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as String,
      lastSeenAt: lastSeenAt == const $CopyWithPlaceholder()
          ? _value.lastSeenAt
          // ignore: cast_nullable_to_non_nullable
          : lastSeenAt as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $DeviceOutCopyWith on DeviceOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDeviceOut.copyWith(...)` or `instanceOfDeviceOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeviceOutCWProxy get copyWith => _$DeviceOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceOut _$DeviceOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'DeviceOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'id_user',
        'device_name',
        'device_fingerprint',
        'platform',
        'last_seen_at',
        'created_at',
        'updated_at',
      ],
    );
    final val = DeviceOut(
      id: $checkedConvert('id', (v) => v as String),
      idUser: $checkedConvert('id_user', (v) => v as String),
      deviceName: $checkedConvert('device_name', (v) => v as String),
      deviceFingerprint: $checkedConvert(
        'device_fingerprint',
        (v) => v as String,
      ),
      platform: $checkedConvert('platform', (v) => v as String),
      lastSeenAt: $checkedConvert(
        'last_seen_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'idUser': 'id_user',
    'deviceName': 'device_name',
    'deviceFingerprint': 'device_fingerprint',
    'lastSeenAt': 'last_seen_at',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$DeviceOutToJson(DeviceOut instance) => <String, dynamic>{
  'id': instance.id,
  'id_user': instance.idUser,
  'device_name': instance.deviceName,
  'device_fingerprint': instance.deviceFingerprint,
  'platform': instance.platform,
  'last_seen_at': instance.lastSeenAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
