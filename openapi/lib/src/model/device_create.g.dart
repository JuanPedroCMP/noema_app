// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeviceCreateCWProxy {
  DeviceCreate idUser(String idUser);

  DeviceCreate deviceName(String deviceName);

  DeviceCreate deviceFingerprint(String deviceFingerprint);

  DeviceCreate platform(String platform);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `DeviceCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DeviceCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  DeviceCreate call({
    String idUser,
    String deviceName,
    String deviceFingerprint,
    String platform,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDeviceCreate.copyWith(...)` or call `instanceOfDeviceCreate.copyWith.fieldName(value)` for a single field.
class _$DeviceCreateCWProxyImpl implements _$DeviceCreateCWProxy {
  const _$DeviceCreateCWProxyImpl(this._value);

  final DeviceCreate _value;

  @override
  DeviceCreate idUser(String idUser) => call(idUser: idUser);

  @override
  DeviceCreate deviceName(String deviceName) => call(deviceName: deviceName);

  @override
  DeviceCreate deviceFingerprint(String deviceFingerprint) =>
      call(deviceFingerprint: deviceFingerprint);

  @override
  DeviceCreate platform(String platform) => call(platform: platform);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `DeviceCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DeviceCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  DeviceCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? deviceName = const $CopyWithPlaceholder(),
    Object? deviceFingerprint = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
  }) {
    return DeviceCreate(
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
    );
  }
}

extension $DeviceCreateCopyWith on DeviceCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDeviceCreate.copyWith(...)` or `instanceOfDeviceCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeviceCreateCWProxy get copyWith => _$DeviceCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceCreate _$DeviceCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeviceCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id_user',
            'device_name',
            'device_fingerprint',
            'platform',
          ],
        );
        final val = DeviceCreate(
          idUser: $checkedConvert('id_user', (v) => v as String),
          deviceName: $checkedConvert('device_name', (v) => v as String),
          deviceFingerprint: $checkedConvert(
            'device_fingerprint',
            (v) => v as String,
          ),
          platform: $checkedConvert('platform', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'idUser': 'id_user',
        'deviceName': 'device_name',
        'deviceFingerprint': 'device_fingerprint',
      },
    );

Map<String, dynamic> _$DeviceCreateToJson(DeviceCreate instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'device_name': instance.deviceName,
      'device_fingerprint': instance.deviceFingerprint,
      'platform': instance.platform,
    };
