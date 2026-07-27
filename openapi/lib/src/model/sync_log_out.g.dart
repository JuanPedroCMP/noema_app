// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SyncLogOut extends SyncLogOut {
  @override
  final String id;
  @override
  final String idDevice;
  @override
  final String idBackupFile;
  @override
  final String event;
  @override
  final SyncDirection? derection;
  @override
  final SyncResult? result;
  @override
  final ConflictStrategy? conflictStrategy;
  @override
  final String errorDetails;
  @override
  final BuiltMap<String, JsonObject?> metadata;
  @override
  final DateTime? createdAt;

  factory _$SyncLogOut([void Function(SyncLogOutBuilder)? updates]) =>
      (SyncLogOutBuilder()..update(updates))._build();

  _$SyncLogOut._(
      {required this.id,
      required this.idDevice,
      required this.idBackupFile,
      required this.event,
      this.derection,
      this.result,
      this.conflictStrategy,
      required this.errorDetails,
      required this.metadata,
      this.createdAt})
      : super._();
  @override
  SyncLogOut rebuild(void Function(SyncLogOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncLogOutBuilder toBuilder() => SyncLogOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncLogOut &&
        id == other.id &&
        idDevice == other.idDevice &&
        idBackupFile == other.idBackupFile &&
        event == other.event &&
        derection == other.derection &&
        result == other.result &&
        conflictStrategy == other.conflictStrategy &&
        errorDetails == other.errorDetails &&
        metadata == other.metadata &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, idBackupFile.hashCode);
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, derection.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, conflictStrategy.hashCode);
    _$hash = $jc(_$hash, errorDetails.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncLogOut')
          ..add('id', id)
          ..add('idDevice', idDevice)
          ..add('idBackupFile', idBackupFile)
          ..add('event', event)
          ..add('derection', derection)
          ..add('result', result)
          ..add('conflictStrategy', conflictStrategy)
          ..add('errorDetails', errorDetails)
          ..add('metadata', metadata)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class SyncLogOutBuilder implements Builder<SyncLogOut, SyncLogOutBuilder> {
  _$SyncLogOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  MapBuilder<String, JsonObject?>? _metadata;
  MapBuilder<String, JsonObject?> get metadata =>
      _$this._metadata ??= MapBuilder<String, JsonObject?>();
  set metadata(MapBuilder<String, JsonObject?>? metadata) =>
      _$this._metadata = metadata;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  SyncLogOutBuilder() {
    SyncLogOut._defaults(this);
  }

  SyncLogOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idDevice = $v.idDevice;
      _idBackupFile = $v.idBackupFile;
      _event = $v.event;
      _derection = $v.derection;
      _result = $v.result;
      _conflictStrategy = $v.conflictStrategy;
      _errorDetails = $v.errorDetails;
      _metadata = $v.metadata.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncLogOut other) {
    _$v = other as _$SyncLogOut;
  }

  @override
  void update(void Function(SyncLogOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncLogOut build() => _build();

  _$SyncLogOut _build() {
    _$SyncLogOut _$result;
    try {
      _$result = _$v ??
          _$SyncLogOut._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'SyncLogOut', 'id'),
            idDevice: BuiltValueNullFieldError.checkNotNull(
                idDevice, r'SyncLogOut', 'idDevice'),
            idBackupFile: BuiltValueNullFieldError.checkNotNull(
                idBackupFile, r'SyncLogOut', 'idBackupFile'),
            event: BuiltValueNullFieldError.checkNotNull(
                event, r'SyncLogOut', 'event'),
            derection: derection,
            result: result,
            conflictStrategy: conflictStrategy,
            errorDetails: BuiltValueNullFieldError.checkNotNull(
                errorDetails, r'SyncLogOut', 'errorDetails'),
            metadata: metadata.build(),
            createdAt: createdAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metadata';
        metadata.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SyncLogOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
