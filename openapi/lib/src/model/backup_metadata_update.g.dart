// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_metadata_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupMetadataUpdate extends BackupMetadataUpdate {
  @override
  final String? expectedDriveVersion;
  @override
  final String? expectedContentHash;
  @override
  final String idempotencyKey;
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

  factory _$BackupMetadataUpdate(
          [void Function(BackupMetadataUpdateBuilder)? updates]) =>
      (BackupMetadataUpdateBuilder()..update(updates))._build();

  _$BackupMetadataUpdate._(
      {this.expectedDriveVersion,
      this.expectedContentHash,
      required this.idempotencyKey,
      required this.driveVersion,
      required this.snapshotVersion,
      required this.contentHash,
      required this.sizeBytes,
      required this.operationState,
      required this.manifest})
      : super._();
  @override
  BackupMetadataUpdate rebuild(
          void Function(BackupMetadataUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackupMetadataUpdateBuilder toBuilder() =>
      BackupMetadataUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupMetadataUpdate &&
        expectedDriveVersion == other.expectedDriveVersion &&
        expectedContentHash == other.expectedContentHash &&
        idempotencyKey == other.idempotencyKey &&
        driveVersion == other.driveVersion &&
        snapshotVersion == other.snapshotVersion &&
        contentHash == other.contentHash &&
        sizeBytes == other.sizeBytes &&
        operationState == other.operationState &&
        manifest == other.manifest;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedDriveVersion.hashCode);
    _$hash = $jc(_$hash, expectedContentHash.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jc(_$hash, driveVersion.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, operationState.hashCode);
    _$hash = $jc(_$hash, manifest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupMetadataUpdate')
          ..add('expectedDriveVersion', expectedDriveVersion)
          ..add('expectedContentHash', expectedContentHash)
          ..add('idempotencyKey', idempotencyKey)
          ..add('driveVersion', driveVersion)
          ..add('snapshotVersion', snapshotVersion)
          ..add('contentHash', contentHash)
          ..add('sizeBytes', sizeBytes)
          ..add('operationState', operationState)
          ..add('manifest', manifest))
        .toString();
  }
}

class BackupMetadataUpdateBuilder
    implements Builder<BackupMetadataUpdate, BackupMetadataUpdateBuilder> {
  _$BackupMetadataUpdate? _$v;

  String? _expectedDriveVersion;
  String? get expectedDriveVersion => _$this._expectedDriveVersion;
  set expectedDriveVersion(String? expectedDriveVersion) =>
      _$this._expectedDriveVersion = expectedDriveVersion;

  String? _expectedContentHash;
  String? get expectedContentHash => _$this._expectedContentHash;
  set expectedContentHash(String? expectedContentHash) =>
      _$this._expectedContentHash = expectedContentHash;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

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

  BackupMetadataUpdateBuilder() {
    BackupMetadataUpdate._defaults(this);
  }

  BackupMetadataUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedDriveVersion = $v.expectedDriveVersion;
      _expectedContentHash = $v.expectedContentHash;
      _idempotencyKey = $v.idempotencyKey;
      _driveVersion = $v.driveVersion;
      _snapshotVersion = $v.snapshotVersion;
      _contentHash = $v.contentHash;
      _sizeBytes = $v.sizeBytes;
      _operationState = $v.operationState;
      _manifest = $v.manifest.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupMetadataUpdate other) {
    _$v = other as _$BackupMetadataUpdate;
  }

  @override
  void update(void Function(BackupMetadataUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupMetadataUpdate build() => _build();

  _$BackupMetadataUpdate _build() {
    _$BackupMetadataUpdate _$result;
    try {
      _$result = _$v ??
          _$BackupMetadataUpdate._(
            expectedDriveVersion: expectedDriveVersion,
            expectedContentHash: expectedContentHash,
            idempotencyKey: BuiltValueNullFieldError.checkNotNull(
                idempotencyKey, r'BackupMetadataUpdate', 'idempotencyKey'),
            driveVersion: BuiltValueNullFieldError.checkNotNull(
                driveVersion, r'BackupMetadataUpdate', 'driveVersion'),
            snapshotVersion: BuiltValueNullFieldError.checkNotNull(
                snapshotVersion, r'BackupMetadataUpdate', 'snapshotVersion'),
            contentHash: BuiltValueNullFieldError.checkNotNull(
                contentHash, r'BackupMetadataUpdate', 'contentHash'),
            sizeBytes: BuiltValueNullFieldError.checkNotNull(
                sizeBytes, r'BackupMetadataUpdate', 'sizeBytes'),
            operationState: BuiltValueNullFieldError.checkNotNull(
                operationState, r'BackupMetadataUpdate', 'operationState'),
            manifest: manifest.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manifest';
        manifest.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackupMetadataUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
