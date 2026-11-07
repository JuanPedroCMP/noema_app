// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_file_filters.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupFileFilters extends BackupFileFilters {
  @override
  final String? id;
  @override
  final String? idGoogleAccount;
  @override
  final String? idDevice;
  @override
  final String? driveFileId;
  @override
  final String? localRef;
  @override
  final String? snapshotVersion;
  @override
  final BackupOperationState? operationState;

  factory _$BackupFileFilters(
          [void Function(BackupFileFiltersBuilder)? updates]) =>
      (BackupFileFiltersBuilder()..update(updates))._build();

  _$BackupFileFilters._(
      {this.id,
      this.idGoogleAccount,
      this.idDevice,
      this.driveFileId,
      this.localRef,
      this.snapshotVersion,
      this.operationState})
      : super._();
  @override
  BackupFileFilters rebuild(void Function(BackupFileFiltersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackupFileFiltersBuilder toBuilder() =>
      BackupFileFiltersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupFileFilters &&
        id == other.id &&
        idGoogleAccount == other.idGoogleAccount &&
        idDevice == other.idDevice &&
        driveFileId == other.driveFileId &&
        localRef == other.localRef &&
        snapshotVersion == other.snapshotVersion &&
        operationState == other.operationState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idGoogleAccount.hashCode);
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, driveFileId.hashCode);
    _$hash = $jc(_$hash, localRef.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, operationState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupFileFilters')
          ..add('id', id)
          ..add('idGoogleAccount', idGoogleAccount)
          ..add('idDevice', idDevice)
          ..add('driveFileId', driveFileId)
          ..add('localRef', localRef)
          ..add('snapshotVersion', snapshotVersion)
          ..add('operationState', operationState))
        .toString();
  }
}

class BackupFileFiltersBuilder
    implements Builder<BackupFileFilters, BackupFileFiltersBuilder> {
  _$BackupFileFilters? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idGoogleAccount;
  String? get idGoogleAccount => _$this._idGoogleAccount;
  set idGoogleAccount(String? idGoogleAccount) =>
      _$this._idGoogleAccount = idGoogleAccount;

  String? _idDevice;
  String? get idDevice => _$this._idDevice;
  set idDevice(String? idDevice) => _$this._idDevice = idDevice;

  String? _driveFileId;
  String? get driveFileId => _$this._driveFileId;
  set driveFileId(String? driveFileId) => _$this._driveFileId = driveFileId;

  String? _localRef;
  String? get localRef => _$this._localRef;
  set localRef(String? localRef) => _$this._localRef = localRef;

  String? _snapshotVersion;
  String? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(String? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  BackupOperationState? _operationState;
  BackupOperationState? get operationState => _$this._operationState;
  set operationState(BackupOperationState? operationState) =>
      _$this._operationState = operationState;

  BackupFileFiltersBuilder() {
    BackupFileFilters._defaults(this);
  }

  BackupFileFiltersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idGoogleAccount = $v.idGoogleAccount;
      _idDevice = $v.idDevice;
      _driveFileId = $v.driveFileId;
      _localRef = $v.localRef;
      _snapshotVersion = $v.snapshotVersion;
      _operationState = $v.operationState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupFileFilters other) {
    _$v = other as _$BackupFileFilters;
  }

  @override
  void update(void Function(BackupFileFiltersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupFileFilters build() => _build();

  _$BackupFileFilters _build() {
    final _$result = _$v ??
        _$BackupFileFilters._(
          id: id,
          idGoogleAccount: idGoogleAccount,
          idDevice: idDevice,
          driveFileId: driveFileId,
          localRef: localRef,
          snapshotVersion: snapshotVersion,
          operationState: operationState,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
