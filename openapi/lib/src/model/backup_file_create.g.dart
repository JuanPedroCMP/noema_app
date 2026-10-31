// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_file_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupFileCreate extends BackupFileCreate {
  @override
  final String idGoogleAccount;
  @override
  final String driveFileId;
  @override
  final String? localRef;
  @override
  final String driveVersion;
  @override
  final String contentHash;
  @override
  final String? snapshotVersion;
  @override
  final String? idDevice;
  @override
  final int? sizeBytes;
  @override
  final BackupOperationState? operationState;
  @override
  final SnapshotManifest? manifest;
  @override
  final String? idempotencyKey;

  factory _$BackupFileCreate(
          [void Function(BackupFileCreateBuilder)? updates]) =>
      (BackupFileCreateBuilder()..update(updates))._build();

  _$BackupFileCreate._(
      {required this.idGoogleAccount,
      required this.driveFileId,
      this.localRef,
      required this.driveVersion,
      required this.contentHash,
      this.snapshotVersion,
      this.idDevice,
      this.sizeBytes,
      this.operationState,
      this.manifest,
      this.idempotencyKey})
      : super._();
  @override
  BackupFileCreate rebuild(void Function(BackupFileCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackupFileCreateBuilder toBuilder() =>
      BackupFileCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupFileCreate &&
        idGoogleAccount == other.idGoogleAccount &&
        driveFileId == other.driveFileId &&
        localRef == other.localRef &&
        driveVersion == other.driveVersion &&
        contentHash == other.contentHash &&
        snapshotVersion == other.snapshotVersion &&
        idDevice == other.idDevice &&
        sizeBytes == other.sizeBytes &&
        operationState == other.operationState &&
        manifest == other.manifest &&
        idempotencyKey == other.idempotencyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idGoogleAccount.hashCode);
    _$hash = $jc(_$hash, driveFileId.hashCode);
    _$hash = $jc(_$hash, localRef.hashCode);
    _$hash = $jc(_$hash, driveVersion.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, operationState.hashCode);
    _$hash = $jc(_$hash, manifest.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupFileCreate')
          ..add('idGoogleAccount', idGoogleAccount)
          ..add('driveFileId', driveFileId)
          ..add('localRef', localRef)
          ..add('driveVersion', driveVersion)
          ..add('contentHash', contentHash)
          ..add('snapshotVersion', snapshotVersion)
          ..add('idDevice', idDevice)
          ..add('sizeBytes', sizeBytes)
          ..add('operationState', operationState)
          ..add('manifest', manifest)
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class BackupFileCreateBuilder
    implements Builder<BackupFileCreate, BackupFileCreateBuilder> {
  _$BackupFileCreate? _$v;

  String? _idGoogleAccount;
  String? get idGoogleAccount => _$this._idGoogleAccount;
  set idGoogleAccount(String? idGoogleAccount) =>
      _$this._idGoogleAccount = idGoogleAccount;

  String? _driveFileId;
  String? get driveFileId => _$this._driveFileId;
  set driveFileId(String? driveFileId) => _$this._driveFileId = driveFileId;

  String? _localRef;
  String? get localRef => _$this._localRef;
  set localRef(String? localRef) => _$this._localRef = localRef;

  String? _driveVersion;
  String? get driveVersion => _$this._driveVersion;
  set driveVersion(String? driveVersion) => _$this._driveVersion = driveVersion;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  String? _snapshotVersion;
  String? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(String? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  String? _idDevice;
  String? get idDevice => _$this._idDevice;
  set idDevice(String? idDevice) => _$this._idDevice = idDevice;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  BackupOperationState? _operationState;
  BackupOperationState? get operationState => _$this._operationState;
  set operationState(BackupOperationState? operationState) =>
      _$this._operationState = operationState;

  SnapshotManifestBuilder? _manifest;
  SnapshotManifestBuilder get manifest =>
      _$this._manifest ??= SnapshotManifestBuilder();
  set manifest(SnapshotManifestBuilder? manifest) =>
      _$this._manifest = manifest;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

  BackupFileCreateBuilder() {
    BackupFileCreate._defaults(this);
  }

  BackupFileCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idGoogleAccount = $v.idGoogleAccount;
      _driveFileId = $v.driveFileId;
      _localRef = $v.localRef;
      _driveVersion = $v.driveVersion;
      _contentHash = $v.contentHash;
      _snapshotVersion = $v.snapshotVersion;
      _idDevice = $v.idDevice;
      _sizeBytes = $v.sizeBytes;
      _operationState = $v.operationState;
      _manifest = $v.manifest?.toBuilder();
      _idempotencyKey = $v.idempotencyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupFileCreate other) {
    _$v = other as _$BackupFileCreate;
  }

  @override
  void update(void Function(BackupFileCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupFileCreate build() => _build();

  _$BackupFileCreate _build() {
    _$BackupFileCreate _$result;
    try {
      _$result = _$v ??
          _$BackupFileCreate._(
            idGoogleAccount: BuiltValueNullFieldError.checkNotNull(
                idGoogleAccount, r'BackupFileCreate', 'idGoogleAccount'),
            driveFileId: BuiltValueNullFieldError.checkNotNull(
                driveFileId, r'BackupFileCreate', 'driveFileId'),
            localRef: localRef,
            driveVersion: BuiltValueNullFieldError.checkNotNull(
                driveVersion, r'BackupFileCreate', 'driveVersion'),
            contentHash: BuiltValueNullFieldError.checkNotNull(
                contentHash, r'BackupFileCreate', 'contentHash'),
            snapshotVersion: snapshotVersion,
            idDevice: idDevice,
            sizeBytes: sizeBytes,
            operationState: operationState,
            manifest: _manifest?.build(),
            idempotencyKey: idempotencyKey,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manifest';
        _manifest?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackupFileCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
