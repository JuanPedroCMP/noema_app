// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceUpdate extends DeviceUpdate {
  @override
  final String? idUser;
  @override
  final String? deviceName;
  @override
  final String? deviceFingerprint;
  @override
  final String? platform;
  @override
  final DateTime? lastSeenAt;

  factory _$DeviceUpdate([void Function(DeviceUpdateBuilder)? updates]) =>
      (DeviceUpdateBuilder()..update(updates))._build();

  _$DeviceUpdate._(
      {this.idUser,
      this.deviceName,
      this.deviceFingerprint,
      this.platform,
      this.lastSeenAt})
      : super._();
  @override
  DeviceUpdate rebuild(void Function(DeviceUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceUpdateBuilder toBuilder() => DeviceUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceUpdate &&
        idUser == other.idUser &&
        deviceName == other.deviceName &&
        deviceFingerprint == other.deviceFingerprint &&
        platform == other.platform &&
        lastSeenAt == other.lastSeenAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, deviceFingerprint.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceUpdate')
          ..add('idUser', idUser)
          ..add('deviceName', deviceName)
          ..add('deviceFingerprint', deviceFingerprint)
          ..add('platform', platform)
          ..add('lastSeenAt', lastSeenAt))
        .toString();
  }
}

class DeviceUpdateBuilder
    implements Builder<DeviceUpdate, DeviceUpdateBuilder> {
  _$DeviceUpdate? _$v;

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

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  DeviceUpdateBuilder() {
    DeviceUpdate._defaults(this);
  }

  DeviceUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _deviceName = $v.deviceName;
      _deviceFingerprint = $v.deviceFingerprint;
      _platform = $v.platform;
      _lastSeenAt = $v.lastSeenAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceUpdate other) {
    _$v = other as _$DeviceUpdate;
  }

  @override
  void update(void Function(DeviceUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceUpdate build() => _build();

  _$DeviceUpdate _build() {
    final _$result = _$v ??
        _$DeviceUpdate._(
          idUser: idUser,
          deviceName: deviceName,
          deviceFingerprint: deviceFingerprint,
          platform: platform,
          lastSeenAt: lastSeenAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
