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
  final String driveFileId;
  @override
  final String localRef;
  @override
  final String driveVersion;
  @override
  final String contentHash;
  @override
  final DateTime? createdAt;

  factory _$BackupFileOut([void Function(BackupFileOutBuilder)? updates]) =>
      (BackupFileOutBuilder()..update(updates))._build();

  _$BackupFileOut._(
      {required this.id,
      required this.idGoogleAccount,
      required this.driveFileId,
      required this.localRef,
      required this.driveVersion,
      required this.contentHash,
      this.createdAt})
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
        driveFileId == other.driveFileId &&
        localRef == other.localRef &&
        driveVersion == other.driveVersion &&
        contentHash == other.contentHash &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idGoogleAccount.hashCode);
    _$hash = $jc(_$hash, driveFileId.hashCode);
    _$hash = $jc(_$hash, localRef.hashCode);
    _$hash = $jc(_$hash, driveVersion.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupFileOut')
          ..add('id', id)
          ..add('idGoogleAccount', idGoogleAccount)
          ..add('driveFileId', driveFileId)
          ..add('localRef', localRef)
          ..add('driveVersion', driveVersion)
          ..add('contentHash', contentHash)
          ..add('createdAt', createdAt))
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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  BackupFileOutBuilder() {
    BackupFileOut._defaults(this);
  }

  BackupFileOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idGoogleAccount = $v.idGoogleAccount;
      _driveFileId = $v.driveFileId;
      _localRef = $v.localRef;
      _driveVersion = $v.driveVersion;
      _contentHash = $v.contentHash;
      _createdAt = $v.createdAt;
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
    final _$result = _$v ??
        _$BackupFileOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'BackupFileOut', 'id'),
          idGoogleAccount: BuiltValueNullFieldError.checkNotNull(
              idGoogleAccount, r'BackupFileOut', 'idGoogleAccount'),
          driveFileId: BuiltValueNullFieldError.checkNotNull(
              driveFileId, r'BackupFileOut', 'driveFileId'),
          localRef: BuiltValueNullFieldError.checkNotNull(
              localRef, r'BackupFileOut', 'localRef'),
          driveVersion: BuiltValueNullFieldError.checkNotNull(
              driveVersion, r'BackupFileOut', 'driveVersion'),
          contentHash: BuiltValueNullFieldError.checkNotNull(
              contentHash, r'BackupFileOut', 'contentHash'),
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
