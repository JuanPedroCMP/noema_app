// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeviceUpdateCWProxy {
  DeviceUpdate idUser(String? idUser);

  DeviceUpdate deviceName(String? deviceName);

  DeviceUpdate deviceFingerprint(String? deviceFingerprint);

  DeviceUpdate platform(String? platform);

  DeviceUpdate lastSeenAt(DateTime? lastSeenAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `DeviceUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DeviceUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  DeviceUpdate call({
    String? idUser,
    String? deviceName,
    String? deviceFingerprint,
    String? platform,
    DateTime? lastSeenAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDeviceUpdate.copyWith(...)` or call `instanceOfDeviceUpdate.copyWith.fieldName(value)` for a single field.
class _$DeviceUpdateCWProxyImpl implements _$DeviceUpdateCWProxy {
  const _$DeviceUpdateCWProxyImpl(this._value);

  final DeviceUpdate _value;

  @override
  DeviceUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  DeviceUpdate deviceName(String? deviceName) => call(deviceName: deviceName);

  @override
  DeviceUpdate deviceFingerprint(String? deviceFingerprint) =>
      call(deviceFingerprint: deviceFingerprint);

  @override
  DeviceUpdate platform(String? platform) => call(platform: platform);

  @override
  DeviceUpdate lastSeenAt(DateTime? lastSeenAt) => call(lastSeenAt: lastSeenAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `DeviceUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DeviceUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  DeviceUpdate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? deviceName = const $CopyWithPlaceholder(),
    Object? deviceFingerprint = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? lastSeenAt = const $CopyWithPlaceholder(),
  }) {
    return DeviceUpdate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      deviceName: deviceName == const $CopyWithPlaceholder()
          ? _value.deviceName
          // ignore: cast_nullable_to_non_nullable
          : deviceName as String?,
      deviceFingerprint: deviceFingerprint == const $CopyWithPlaceholder()
          ? _value.deviceFingerprint
          // ignore: cast_nullable_to_non_nullable
          : deviceFingerprint as String?,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as String?,
      lastSeenAt: lastSeenAt == const $CopyWithPlaceholder()
          ? _value.lastSeenAt
          // ignore: cast_nullable_to_non_nullable
          : lastSeenAt as DateTime?,
    );
  }
}

extension $DeviceUpdateCopyWith on DeviceUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDeviceUpdate.copyWith(...)` or `instanceOfDeviceUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeviceUpdateCWProxy get copyWith => _$DeviceUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceUpdate _$DeviceUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeviceUpdate',
      json,
      ($checkedConvert) {
        final val = DeviceUpdate(
          idUser: $checkedConvert('id_user', (v) => v as String?),
          deviceName: $checkedConvert('device_name', (v) => v as String?),
          deviceFingerprint: $checkedConvert(
            'device_fingerprint',
            (v) => v as String?,
          ),
          platform: $checkedConvert('platform', (v) => v as String?),
          lastSeenAt: $checkedConvert(
            'last_seen_at',
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
      },
    );

Map<String, dynamic> _$DeviceUpdateToJson(DeviceUpdate instance) =>
    <String, dynamic>{
      'id_user': ?instance.idUser,
      'device_name': ?instance.deviceName,
      'device_fingerprint': ?instance.deviceFingerprint,
      'platform': ?instance.platform,
      'last_seen_at': ?instance.lastSeenAt?.toIso8601String(),
    };
