// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_metadata_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupMetadataCreate extends BackupMetadataCreate {
  @override
  final String idGoogleAccount;
  @override
  final String idDevice;
  @override
  final String driveFileId;
  @override
  final String? localRef;
  @override
  final String driveVersion;
  @override
  final String snapshotVersion;
  @override
  final String contentHash;
  @override
  final int sizeBytes;
  @override
  final BackupOperationState operationState;
  @override
  final SnapshotManifest manifest;
  @override
  final String idempotencyKey;

  factory _$BackupMetadataCreate(
          [void Function(BackupMetadataCreateBuilder)? updates]) =>
      (BackupMetadataCreateBuilder()..update(updates))._build();

  _$BackupMetadataCreate._(
      {required this.idGoogleAccount,
      required this.idDevice,
      required this.driveFileId,
      this.localRef,
      required this.driveVersion,
      required this.snapshotVersion,
      required this.contentHash,
      required this.sizeBytes,
      required this.operationState,
      required this.manifest,
      required this.idempotencyKey})
      : super._();
  @override
  BackupMetadataCreate rebuild(
          void Function(BackupMetadataCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackupMetadataCreateBuilder toBuilder() =>
      BackupMetadataCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupMetadataCreate &&
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
        idempotencyKey == other.idempotencyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupMetadataCreate')
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
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class BackupMetadataCreateBuilder
    implements Builder<BackupMetadataCreate, BackupMetadataCreateBuilder> {
  _$BackupMetadataCreate? _$v;

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

  SnapshotManifestBuilder? _manifest;
  SnapshotManifestBuilder get manifest =>
      _$this._manifest ??= SnapshotManifestBuilder();
  set manifest(SnapshotManifestBuilder? manifest) =>
      _$this._manifest = manifest;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

  BackupMetadataCreateBuilder() {
    BackupMetadataCreate._defaults(this);
  }

  BackupMetadataCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idGoogleAccount = $v.idGoogleAccount;
      _idDevice = $v.idDevice;
      _driveFileId = $v.driveFileId;
      _localRef = $v.localRef;
      _driveVersion = $v.driveVersion;
      _snapshotVersion = $v.snapshotVersion;
      _contentHash = $v.contentHash;
      _sizeBytes = $v.sizeBytes;
      _operationState = $v.operationState;
      _manifest = $v.manifest.toBuilder();
      _idempotencyKey = $v.idempotencyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupMetadataCreate other) {
    _$v = other as _$BackupMetadataCreate;
  }

  @override
  void update(void Function(BackupMetadataCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupMetadataCreate build() => _build();

  _$BackupMetadataCreate _build() {
    _$BackupMetadataCreate _$result;
    try {
      _$result = _$v ??
          _$BackupMetadataCreate._(
            idGoogleAccount: BuiltValueNullFieldError.checkNotNull(
                idGoogleAccount, r'BackupMetadataCreate', 'idGoogleAccount'),
            idDevice: BuiltValueNullFieldError.checkNotNull(
                idDevice, r'BackupMetadataCreate', 'idDevice'),
            driveFileId: BuiltValueNullFieldError.checkNotNull(
                driveFileId, r'BackupMetadataCreate', 'driveFileId'),
            localRef: localRef,
            driveVersion: BuiltValueNullFieldError.checkNotNull(
                driveVersion, r'BackupMetadataCreate', 'driveVersion'),
            snapshotVersion: BuiltValueNullFieldError.checkNotNull(
                snapshotVersion, r'BackupMetadataCreate', 'snapshotVersion'),
            contentHash: BuiltValueNullFieldError.checkNotNull(
                contentHash, r'BackupMetadataCreate', 'contentHash'),
            sizeBytes: BuiltValueNullFieldError.checkNotNull(
                sizeBytes, r'BackupMetadataCreate', 'sizeBytes'),
            operationState: BuiltValueNullFieldError.checkNotNull(
                operationState, r'BackupMetadataCreate', 'operationState'),
            manifest: manifest.build(),
            idempotencyKey: BuiltValueNullFieldError.checkNotNull(
                idempotencyKey, r'BackupMetadataCreate', 'idempotencyKey'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manifest';
        manifest.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackupMetadataCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
