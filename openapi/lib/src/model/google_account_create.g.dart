// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleAccountCreate extends GoogleAccountCreate {
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

  factory _$GoogleAccountCreate(
          [void Function(GoogleAccountCreateBuilder)? updates]) =>
      (GoogleAccountCreateBuilder()..update(updates))._build();

  _$GoogleAccountCreate._(
      {required this.idUser,
      this.googleUserId,
      required this.emailGoogle,
      this.accessTokenEnc,
      this.refreshTokenEnc,
      this.grantedScopes,
      required this.isActive,
      this.expiresAt})
      : super._();
  @override
  GoogleAccountCreate rebuild(
          void Function(GoogleAccountCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAccountCreateBuilder toBuilder() =>
      GoogleAccountCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAccountCreate &&
        idUser == other.idUser &&
        googleUserId == other.googleUserId &&
        emailGoogle == other.emailGoogle &&
        accessTokenEnc == other.accessTokenEnc &&
        refreshTokenEnc == other.refreshTokenEnc &&
        grantedScopes == other.grantedScopes &&
        isActive == other.isActive &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, googleUserId.hashCode);
    _$hash = $jc(_$hash, emailGoogle.hashCode);
    _$hash = $jc(_$hash, accessTokenEnc.hashCode);
    _$hash = $jc(_$hash, refreshTokenEnc.hashCode);
    _$hash = $jc(_$hash, grantedScopes.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAccountCreate')
          ..add('idUser', idUser)
          ..add('googleUserId', googleUserId)
          ..add('emailGoogle', emailGoogle)
          ..add('accessTokenEnc', accessTokenEnc)
          ..add('refreshTokenEnc', refreshTokenEnc)
          ..add('grantedScopes', grantedScopes)
          ..add('isActive', isActive)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class GoogleAccountCreateBuilder
    implements Builder<GoogleAccountCreate, GoogleAccountCreateBuilder> {
  _$GoogleAccountCreate? _$v;

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

  GoogleAccountCreateBuilder() {
    GoogleAccountCreate._defaults(this);
  }

  GoogleAccountCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _googleUserId = $v.googleUserId;
      _emailGoogle = $v.emailGoogle;
      _accessTokenEnc = $v.accessTokenEnc;
      _refreshTokenEnc = $v.refreshTokenEnc;
      _grantedScopes = $v.grantedScopes;
      _isActive = $v.isActive;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAccountCreate other) {
    _$v = other as _$GoogleAccountCreate;
  }

  @override
  void update(void Function(GoogleAccountCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAccountCreate build() => _build();

  _$GoogleAccountCreate _build() {
    final _$result = _$v ??
        _$GoogleAccountCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'GoogleAccountCreate', 'idUser'),
          googleUserId: googleUserId,
          emailGoogle: BuiltValueNullFieldError.checkNotNull(
              emailGoogle, r'GoogleAccountCreate', 'emailGoogle'),
          accessTokenEnc: accessTokenEnc,
          refreshTokenEnc: refreshTokenEnc,
          grantedScopes: grantedScopes,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'GoogleAccountCreate', 'isActive'),
          expiresAt: expiresAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
