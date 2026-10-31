// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_file_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupFileOut extends BackupFileOut {
  @override
  final String id;
  @override
  final String idGoogleAccount;
  @override
  final String? idDevice;
  @override
  final String driveFileId;
  @override
  final String? localRef;
  @override
  final String? driveVersion;
  @override
  final String? snapshotVersion;
  @override
  final String? contentHash;
  @override
  final int? sizeBytes;
  @override
  final BackupOperationState operationState;
  @override
  final BuiltMap<String, JsonObject?>? manifest;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$BackupFileOut([void Function(BackupFileOutBuilder)? updates]) =>
      (BackupFileOutBuilder()..update(updates))._build();

  _$BackupFileOut._(
      {required this.id,
      required this.idGoogleAccount,
      this.idDevice,
      required this.driveFileId,
      this.localRef,
      this.driveVersion,
      this.snapshotVersion,
      this.contentHash,
      this.sizeBytes,
      required this.operationState,
      this.manifest,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  BackupFileOut rebuild(void Function(BackupFileOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackupFileOutBuilder toBuilder() => BackupFileOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupFileOut &&
        id == other.id &&
        idGoogleAccount == other.idGoogleAccount &&
        idDevice == other.idDevice &&
        driveFileId == other.driveFileId &&
        localRef == other.localRef &&
        driveVersion == other.driveVersion &&
        snapshotVersion == other.snapshotVersion &&
        contentHash == other.contentHash &&
        sizeBytes == other.sizeBytes &&
        operationState == other.operationState &&
        manifest == other.manifest &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idGoogleAccount.hashCode);
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, driveFileId.hashCode);
    _$hash = $jc(_$hash, localRef.hashCode);
    _$hash = $jc(_$hash, driveVersion.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, operationState.hashCode);
    _$hash = $jc(_$hash, manifest.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupFileOut')
          ..add('id', id)
          ..add('idGoogleAccount', idGoogleAccount)
          ..add('idDevice', idDevice)
          ..add('driveFileId', driveFileId)
          ..add('localRef', localRef)
          ..add('driveVersion', driveVersion)
          ..add('snapshotVersion', snapshotVersion)
          ..add('contentHash', contentHash)
          ..add('sizeBytes', sizeBytes)
          ..add('operationState', operationState)
          ..add('manifest', manifest)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class BackupFileOutBuilder
    implements Builder<BackupFileOut, BackupFileOutBuilder> {
  _$BackupFileOut? _$v;

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

  String? _driveVersion;
  String? get driveVersion => _$this._driveVersion;
  set driveVersion(String? driveVersion) => _$this._driveVersion = driveVersion;

  String? _snapshotVersion;
  String? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(String? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  BackupOperationState? _operationState;
  BackupOperationState? get operationState => _$this._operationState;
  set operationState(BackupOperationState? operationState) =>
      _$this._operationState = operationState;

  MapBuilder<String, JsonObject?>? _manifest;
  MapBuilder<String, JsonObject?> get manifest =>
      _$this._manifest ??= MapBuilder<String, JsonObject?>();
  set manifest(MapBuilder<String, JsonObject?>? manifest) =>
      _$this._manifest = manifest;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  BackupFileOutBuilder() {
    BackupFileOut._defaults(this);
  }

  BackupFileOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idGoogleAccount = $v.idGoogleAccount;
      _idDevice = $v.idDevice;
      _driveFileId = $v.driveFileId;
      _localRef = $v.localRef;
      _driveVersion = $v.driveVersion;
      _snapshotVersion = $v.snapshotVersion;
      _contentHash = $v.contentHash;
      _sizeBytes = $v.sizeBytes;
      _operationState = $v.operationState;
      _manifest = $v.manifest?.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupFileOut other) {
    _$v = other as _$BackupFileOut;
  }

  @override
  void update(void Function(BackupFileOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupFileOut build() => _build();

  _$BackupFileOut _build() {
    _$BackupFileOut _$result;
    try {
      _$result = _$v ??
          _$BackupFileOut._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'BackupFileOut', 'id'),
            idGoogleAccount: BuiltValueNullFieldError.checkNotNull(
                idGoogleAccount, r'BackupFileOut', 'idGoogleAccount'),
            idDevice: idDevice,
            driveFileId: BuiltValueNullFieldError.checkNotNull(
                driveFileId, r'BackupFileOut', 'driveFileId'),
            localRef: localRef,
            driveVersion: driveVersion,
            snapshotVersion: snapshotVersion,
            contentHash: contentHash,
            sizeBytes: sizeBytes,
            operationState: BuiltValueNullFieldError.checkNotNull(
                operationState, r'BackupFileOut', 'operationState'),
            manifest: _manifest?.build(),
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manifest';
        _manifest?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackupFileOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
