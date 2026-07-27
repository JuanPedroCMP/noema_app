// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceOut extends DeviceOut {
  @override
  final String id;
  @override
  final String idUser;
  @override
  final String deviceName;
  @override
  final String deviceFingerprint;
  @override
  final String platform;
  @override
  final DateTime? lastSeenAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$DeviceOut([void Function(DeviceOutBuilder)? updates]) =>
      (DeviceOutBuilder()..update(updates))._build();

  _$DeviceOut._(
      {required this.id,
      required this.idUser,
      required this.deviceName,
      required this.deviceFingerprint,
      required this.platform,
      this.lastSeenAt,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  DeviceOut rebuild(void Function(DeviceOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceOutBuilder toBuilder() => DeviceOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceOut &&
        id == other.id &&
        idUser == other.idUser &&
        deviceName == other.deviceName &&
        deviceFingerprint == other.deviceFingerprint &&
        platform == other.platform &&
        lastSeenAt == other.lastSeenAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, deviceFingerprint.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceOut')
          ..add('id', id)
          ..add('idUser', idUser)
          ..add('deviceName', deviceName)
          ..add('deviceFingerprint', deviceFingerprint)
          ..add('platform', platform)
          ..add('lastSeenAt', lastSeenAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class DeviceOutBuilder implements Builder<DeviceOut, DeviceOutBuilder> {
  _$DeviceOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DeviceOutBuilder() {
    DeviceOut._defaults(this);
  }

  DeviceOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idUser = $v.idUser;
      _deviceName = $v.deviceName;
      _deviceFingerprint = $v.deviceFingerprint;
      _platform = $v.platform;
      _lastSeenAt = $v.lastSeenAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceOut other) {
    _$v = other as _$DeviceOut;
  }

  @override
  void update(void Function(DeviceOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceOut build() => _build();

  _$DeviceOut _build() {
    final _$result = _$v ??
        _$DeviceOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DeviceOut', 'id'),
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'DeviceOut', 'idUser'),
          deviceName: BuiltValueNullFieldError.checkNotNull(
              deviceName, r'DeviceOut', 'deviceName'),
          deviceFingerprint: BuiltValueNullFieldError.checkNotNull(
              deviceFingerprint, r'DeviceOut', 'deviceFingerprint'),
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'DeviceOut', 'platform'),
          lastSeenAt: lastSeenAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
