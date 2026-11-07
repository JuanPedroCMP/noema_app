// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_filters.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SyncLogFilters extends SyncLogFilters {
  @override
  final String? id;
  @override
  final String? idDevice;
  @override
  final String? idBackupFile;
  @override
  final String? idGoogleAccount;
  @override
  final String? event;
  @override
  final SyncDirection? derection;
  @override
  final SyncResult? result;
  @override
  final ConflictStrategy? conflictStrategy;

  factory _$SyncLogFilters([void Function(SyncLogFiltersBuilder)? updates]) =>
      (SyncLogFiltersBuilder()..update(updates))._build();

  _$SyncLogFilters._(
      {this.id,
      this.idDevice,
      this.idBackupFile,
      this.idGoogleAccount,
      this.event,
      this.derection,
      this.result,
      this.conflictStrategy})
      : super._();
  @override
  SyncLogFilters rebuild(void Function(SyncLogFiltersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncLogFiltersBuilder toBuilder() => SyncLogFiltersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncLogFilters &&
        id == other.id &&
        idDevice == other.idDevice &&
        idBackupFile == other.idBackupFile &&
        idGoogleAccount == other.idGoogleAccount &&
        event == other.event &&
        derection == other.derection &&
        result == other.result &&
        conflictStrategy == other.conflictStrategy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, idBackupFile.hashCode);
    _$hash = $jc(_$hash, idGoogleAccount.hashCode);
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, derection.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, conflictStrategy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncLogFilters')
          ..add('id', id)
          ..add('idDevice', idDevice)
          ..add('idBackupFile', idBackupFile)
          ..add('idGoogleAccount', idGoogleAccount)
          ..add('event', event)
          ..add('derection', derection)
          ..add('result', result)
          ..add('conflictStrategy', conflictStrategy))
        .toString();
  }
}

class SyncLogFiltersBuilder
    implements Builder<SyncLogFilters, SyncLogFiltersBuilder> {
  _$SyncLogFilters? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idDevice;
  String? get idDevice => _$this._idDevice;
  set idDevice(String? idDevice) => _$this._idDevice = idDevice;

  String? _idBackupFile;
  String? get idBackupFile => _$this._idBackupFile;
  set idBackupFile(String? idBackupFile) => _$this._idBackupFile = idBackupFile;

  String? _idGoogleAccount;
  String? get idGoogleAccount => _$this._idGoogleAccount;
  set idGoogleAccount(String? idGoogleAccount) =>
      _$this._idGoogleAccount = idGoogleAccount;

  String? _event;
  String? get event => _$this._event;
  set event(String? event) => _$this._event = event;

  SyncDirection? _derection;
  SyncDirection? get derection => _$this._derection;
  set derection(SyncDirection? derection) => _$this._derection = derection;

  SyncResult? _result;
  SyncResult? get result => _$this._result;
  set result(SyncResult? result) => _$this._result = result;

  ConflictStrategy? _conflictStrategy;
  ConflictStrategy? get conflictStrategy => _$this._conflictStrategy;
  set conflictStrategy(ConflictStrategy? conflictStrategy) =>
      _$this._conflictStrategy = conflictStrategy;

  SyncLogFiltersBuilder() {
    SyncLogFilters._defaults(this);
  }

  SyncLogFiltersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idDevice = $v.idDevice;
      _idBackupFile = $v.idBackupFile;
      _idGoogleAccount = $v.idGoogleAccount;
      _event = $v.event;
      _derection = $v.derection;
      _result = $v.result;
      _conflictStrategy = $v.conflictStrategy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncLogFilters other) {
    _$v = other as _$SyncLogFilters;
  }

  @override
  void update(void Function(SyncLogFiltersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncLogFilters build() => _build();

  _$SyncLogFilters _build() {
    final _$result = _$v ??
        _$SyncLogFilters._(
          id: id,
          idDevice: idDevice,
          idBackupFile: idBackupFile,
          idGoogleAccount: idGoogleAccount,
          event: event,
          derection: derection,
          result: result,
          conflictStrategy: conflictStrategy,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
