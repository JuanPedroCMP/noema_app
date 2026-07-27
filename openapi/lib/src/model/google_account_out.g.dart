// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleAccountOut extends GoogleAccountOut {
  @override
  final String id;
  @override
  final String idUser;
  @override
  final String? googleUserId;
  @override
  final String emailGoogle;
  @override
  final String? accessTokenEnc;
  @override
  final String? refreshTokenEnc;
  @override
  final String? grantedScopes;
  @override
  final bool isActive;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? lastRefreshAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? createdAt;

  factory _$GoogleAccountOut(
          [void Function(GoogleAccountOutBuilder)? updates]) =>
      (GoogleAccountOutBuilder()..update(updates))._build();

  _$GoogleAccountOut._(
      {required this.id,
      required this.idUser,
      this.googleUserId,
      required this.emailGoogle,
      this.accessTokenEnc,
      this.refreshTokenEnc,
      this.grantedScopes,
      required this.isActive,
      this.expiresAt,
      this.lastRefreshAt,
      this.updatedAt,
      this.createdAt})
      : super._();
  @override
  GoogleAccountOut rebuild(void Function(GoogleAccountOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAccountOutBuilder toBuilder() =>
      GoogleAccountOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAccountOut &&
        id == other.id &&
        idUser == other.idUser &&
        googleUserId == other.googleUserId &&
        emailGoogle == other.emailGoogle &&
        accessTokenEnc == other.accessTokenEnc &&
        refreshTokenEnc == other.refreshTokenEnc &&
        grantedScopes == other.grantedScopes &&
        isActive == other.isActive &&
        expiresAt == other.expiresAt &&
        lastRefreshAt == other.lastRefreshAt &&
        updatedAt == other.updatedAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, googleUserId.hashCode);
    _$hash = $jc(_$hash, emailGoogle.hashCode);
    _$hash = $jc(_$hash, accessTokenEnc.hashCode);
    _$hash = $jc(_$hash, refreshTokenEnc.hashCode);
    _$hash = $jc(_$hash, grantedScopes.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, lastRefreshAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAccountOut')
          ..add('id', id)
          ..add('idUser', idUser)
          ..add('googleUserId', googleUserId)
          ..add('emailGoogle', emailGoogle)
          ..add('accessTokenEnc', accessTokenEnc)
          ..add('refreshTokenEnc', refreshTokenEnc)
          ..add('grantedScopes', grantedScopes)
          ..add('isActive', isActive)
          ..add('expiresAt', expiresAt)
          ..add('lastRefreshAt', lastRefreshAt)
          ..add('updatedAt', updatedAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class GoogleAccountOutBuilder
    implements Builder<GoogleAccountOut, GoogleAccountOutBuilder> {
  _$GoogleAccountOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _googleUserId;
  String? get googleUserId => _$this._googleUserId;
  set googleUserId(String? googleUserId) => _$this._googleUserId = googleUserId;

  String? _emailGoogle;
  String? get emailGoogle => _$this._emailGoogle;
  set emailGoogle(String? emailGoogle) => _$this._emailGoogle = emailGoogle;

  String? _accessTokenEnc;
  String? get accessTokenEnc => _$this._accessTokenEnc;
  set accessTokenEnc(String? accessTokenEnc) =>
      _$this._accessTokenEnc = accessTokenEnc;

  String? _refreshTokenEnc;
  String? get refreshTokenEnc => _$this._refreshTokenEnc;
  set refreshTokenEnc(String? refreshTokenEnc) =>
      _$this._refreshTokenEnc = refreshTokenEnc;

  String? _grantedScopes;
  String? get grantedScopes => _$this._grantedScopes;
  set grantedScopes(String? grantedScopes) =>
      _$this._grantedScopes = grantedScopes;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _lastRefreshAt;
  DateTime? get lastRefreshAt => _$this._lastRefreshAt;
  set lastRefreshAt(DateTime? lastRefreshAt) =>
      _$this._lastRefreshAt = lastRefreshAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  GoogleAccountOutBuilder() {
    GoogleAccountOut._defaults(this);
  }

  GoogleAccountOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idUser = $v.idUser;
      _googleUserId = $v.googleUserId;
      _emailGoogle = $v.emailGoogle;
      _accessTokenEnc = $v.accessTokenEnc;
      _refreshTokenEnc = $v.refreshTokenEnc;
      _grantedScopes = $v.grantedScopes;
      _isActive = $v.isActive;
      _expiresAt = $v.expiresAt;
      _lastRefreshAt = $v.lastRefreshAt;
      _updatedAt = $v.updatedAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAccountOut other) {
    _$v = other as _$GoogleAccountOut;
  }

  @override
  void update(void Function(GoogleAccountOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAccountOut build() => _build();

  _$GoogleAccountOut _build() {
    final _$result = _$v ??
        _$GoogleAccountOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GoogleAccountOut', 'id'),
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'GoogleAccountOut', 'idUser'),
          googleUserId: googleUserId,
          emailGoogle: BuiltValueNullFieldError.checkNotNull(
              emailGoogle, r'GoogleAccountOut', 'emailGoogle'),
          accessTokenEnc: accessTokenEnc,
          refreshTokenEnc: refreshTokenEnc,
          grantedScopes: grantedScopes,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'GoogleAccountOut', 'isActive'),
          expiresAt: expiresAt,
          lastRefreshAt: lastRefreshAt,
          updatedAt: updatedAt,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
