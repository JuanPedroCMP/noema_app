// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleAccountUpdate extends GoogleAccountUpdate {
  @override
  final String? idUser;
  @override
  final String? googleUserId;
  @override
  final String? emailGoogle;
  @override
  final String? accessTokenEnc;
  @override
  final String? refreshTokenEnc;
  @override
  final String? grantedScopes;
  @override
  final bool? isActive;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? lastRefreshAt;

  factory _$GoogleAccountUpdate(
          [void Function(GoogleAccountUpdateBuilder)? updates]) =>
      (GoogleAccountUpdateBuilder()..update(updates))._build();

  _$GoogleAccountUpdate._(
      {this.idUser,
      this.googleUserId,
      this.emailGoogle,
      this.accessTokenEnc,
      this.refreshTokenEnc,
      this.grantedScopes,
      this.isActive,
      this.expiresAt,
      this.lastRefreshAt})
      : super._();
  @override
  GoogleAccountUpdate rebuild(
          void Function(GoogleAccountUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAccountUpdateBuilder toBuilder() =>
      GoogleAccountUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAccountUpdate &&
        idUser == other.idUser &&
        googleUserId == other.googleUserId &&
        emailGoogle == other.emailGoogle &&
        accessTokenEnc == other.accessTokenEnc &&
        refreshTokenEnc == other.refreshTokenEnc &&
        grantedScopes == other.grantedScopes &&
        isActive == other.isActive &&
        expiresAt == other.expiresAt &&
        lastRefreshAt == other.lastRefreshAt;
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
    _$hash = $jc(_$hash, lastRefreshAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAccountUpdate')
          ..add('idUser', idUser)
          ..add('googleUserId', googleUserId)
          ..add('emailGoogle', emailGoogle)
          ..add('accessTokenEnc', accessTokenEnc)
          ..add('refreshTokenEnc', refreshTokenEnc)
          ..add('grantedScopes', grantedScopes)
          ..add('isActive', isActive)
          ..add('expiresAt', expiresAt)
          ..add('lastRefreshAt', lastRefreshAt))
        .toString();
  }
}

class GoogleAccountUpdateBuilder
    implements Builder<GoogleAccountUpdate, GoogleAccountUpdateBuilder> {
  _$GoogleAccountUpdate? _$v;

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

  GoogleAccountUpdateBuilder() {
    GoogleAccountUpdate._defaults(this);
  }

  GoogleAccountUpdateBuilder get _$this {
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
      _lastRefreshAt = $v.lastRefreshAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAccountUpdate other) {
    _$v = other as _$GoogleAccountUpdate;
  }

  @override
  void update(void Function(GoogleAccountUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAccountUpdate build() => _build();

  _$GoogleAccountUpdate _build() {
    final _$result = _$v ??
        _$GoogleAccountUpdate._(
          idUser: idUser,
          googleUserId: googleUserId,
          emailGoogle: emailGoogle,
          accessTokenEnc: accessTokenEnc,
          refreshTokenEnc: refreshTokenEnc,
          grantedScopes: grantedScopes,
          isActive: isActive,
          expiresAt: expiresAt,
          lastRefreshAt: lastRefreshAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
