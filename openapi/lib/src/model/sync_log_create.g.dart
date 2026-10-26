// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SyncLogCreate extends SyncLogCreate {
  @override
  final String idDevice;
  @override
  final String idBackupFile;
  @override
  final String event;
  @override
  final SyncDirection derection;
  @override
  final SyncResult result;
  @override
  final ConflictStrategy conflictStrategy;
  @override
  final String errorDetails;
  @override
  final String metadata;

  factory _$SyncLogCreate([void Function(SyncLogCreateBuilder)? updates]) =>
      (SyncLogCreateBuilder()..update(updates))._build();

  _$SyncLogCreate._(
      {required this.idDevice,
      required this.idBackupFile,
      required this.event,
      required this.derection,
      required this.result,
      required this.conflictStrategy,
      required this.errorDetails,
      required this.metadata})
      : super._();
  @override
  SyncLogCreate rebuild(void Function(SyncLogCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncLogCreateBuilder toBuilder() => SyncLogCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncLogCreate &&
        idDevice == other.idDevice &&
        idBackupFile == other.idBackupFile &&
        event == other.event &&
        derection == other.derection &&
        result == other.result &&
        conflictStrategy == other.conflictStrategy &&
        errorDetails == other.errorDetails &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, idBackupFile.hashCode);
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, derection.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, conflictStrategy.hashCode);
    _$hash = $jc(_$hash, errorDetails.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncLogCreate')
          ..add('idDevice', idDevice)
          ..add('idBackupFile', idBackupFile)
          ..add('event', event)
          ..add('derection', derection)
          ..add('result', result)
          ..add('conflictStrategy', conflictStrategy)
          ..add('errorDetails', errorDetails)
          ..add('metadata', metadata))
        .toString();
  }
}

class SyncLogCreateBuilder
    implements Builder<SyncLogCreate, SyncLogCreateBuilder> {
  _$SyncLogCreate? _$v;

  String? _idDevice;
  String? get idDevice => _$this._idDevice;
  set idDevice(String? idDevice) => _$this._idDevice = idDevice;

  String? _idBackupFile;
  String? get idBackupFile => _$this._idBackupFile;
  set idBackupFile(String? idBackupFile) => _$this._idBackupFile = idBackupFile;

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

  String? _errorDetails;
  String? get errorDetails => _$this._errorDetails;
  set errorDetails(String? errorDetails) => _$this._errorDetails = errorDetails;

  String? _metadata;
  String? get metadata => _$this._metadata;
  set metadata(String? metadata) => _$this._metadata = metadata;

  SyncLogCreateBuilder() {
    SyncLogCreate._defaults(this);
  }

  SyncLogCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idDevice = $v.idDevice;
      _idBackupFile = $v.idBackupFile;
      _event = $v.event;
      _derection = $v.derection;
      _result = $v.result;
      _conflictStrategy = $v.conflictStrategy;
      _errorDetails = $v.errorDetails;
      _metadata = $v.metadata;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncLogCreate other) {
    _$v = other as _$SyncLogCreate;
  }

  @override
  void update(void Function(SyncLogCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncLogCreate build() => _build();

  _$SyncLogCreate _build() {
    final _$result = _$v ??
        _$SyncLogCreate._(
          idDevice: BuiltValueNullFieldError.checkNotNull(
              idDevice, r'SyncLogCreate', 'idDevice'),
          idBackupFile: BuiltValueNullFieldError.checkNotNull(
              idBackupFile, r'SyncLogCreate', 'idBackupFile'),
          event: BuiltValueNullFieldError.checkNotNull(
              event, r'SyncLogCreate', 'event'),
          derection: BuiltValueNullFieldError.checkNotNull(
              derection, r'SyncLogCreate', 'derection'),
          result: BuiltValueNullFieldError.checkNotNull(
              result, r'SyncLogCreate', 'result'),
          conflictStrategy: BuiltValueNullFieldError.checkNotNull(
              conflictStrategy, r'SyncLogCreate', 'conflictStrategy'),
          errorDetails: BuiltValueNullFieldError.checkNotNull(
              errorDetails, r'SyncLogCreate', 'errorDetails'),
          metadata: BuiltValueNullFieldError.checkNotNull(
              metadata, r'SyncLogCreate', 'metadata'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
