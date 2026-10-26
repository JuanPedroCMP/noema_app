// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceCreate extends DeviceCreate {
  @override
  final String idUser;
  @override
  final String deviceName;
  @override
  final String deviceFingerprint;
  @override
  final String platform;

  factory _$DeviceCreate([void Function(DeviceCreateBuilder)? updates]) =>
      (DeviceCreateBuilder()..update(updates))._build();

  _$DeviceCreate._(
      {required this.idUser,
      required this.deviceName,
      required this.deviceFingerprint,
      required this.platform})
      : super._();
  @override
  DeviceCreate rebuild(void Function(DeviceCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceCreateBuilder toBuilder() => DeviceCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceCreate &&
        idUser == other.idUser &&
        deviceName == other.deviceName &&
        deviceFingerprint == other.deviceFingerprint &&
        platform == other.platform;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, deviceFingerprint.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceCreate')
          ..add('idUser', idUser)
          ..add('deviceName', deviceName)
          ..add('deviceFingerprint', deviceFingerprint)
          ..add('platform', platform))
        .toString();
  }
}

class DeviceCreateBuilder
    implements Builder<DeviceCreate, DeviceCreateBuilder> {
  _$DeviceCreate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  String? _deviceFingerprint;
  String? get deviceFingerprint => _$this._deviceFingerprint;
  set deviceFingerprint(String? deviceFingerprint) =>
      _$this._deviceFingerprint = deviceFingerprint;

  String? _platform;
  String? get platform => _$this._platform;
  set platform(String? platform) => _$this._platform = platform;

  DeviceCreateBuilder() {
    DeviceCreate._defaults(this);
  }

  DeviceCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _deviceName = $v.deviceName;
      _deviceFingerprint = $v.deviceFingerprint;
      _platform = $v.platform;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceCreate other) {
    _$v = other as _$DeviceCreate;
  }

  @override
  void update(void Function(DeviceCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceCreate build() => _build();

  _$DeviceCreate _build() {
    final _$result = _$v ??
        _$DeviceCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'DeviceCreate', 'idUser'),
          deviceName: BuiltValueNullFieldError.checkNotNull(
              deviceName, r'DeviceCreate', 'deviceName'),
          deviceFingerprint: BuiltValueNullFieldError.checkNotNull(
              deviceFingerprint, r'DeviceCreate', 'deviceFingerprint'),
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'DeviceCreate', 'platform'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
