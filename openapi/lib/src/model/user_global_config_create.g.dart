// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_config_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserGlobalConfigCreate extends UserGlobalConfigCreate {
  @override
  final String idUser;
  @override
  final String idLanguage;
  @override
  final String idUserColorTheme;
  @override
  final String idUserTypographyTheme;
  @override
  final String preferences;

  factory _$UserGlobalConfigCreate(
          [void Function(UserGlobalConfigCreateBuilder)? updates]) =>
      (UserGlobalConfigCreateBuilder()..update(updates))._build();

  _$UserGlobalConfigCreate._(
      {required this.idUser,
      required this.idLanguage,
      required this.idUserColorTheme,
      required this.idUserTypographyTheme,
      required this.preferences})
      : super._();
  @override
  UserGlobalConfigCreate rebuild(
          void Function(UserGlobalConfigCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserGlobalConfigCreateBuilder toBuilder() =>
      UserGlobalConfigCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserGlobalConfigCreate &&
        idUser == other.idUser &&
        idLanguage == other.idLanguage &&
        idUserColorTheme == other.idUserColorTheme &&
        idUserTypographyTheme == other.idUserTypographyTheme &&
        preferences == other.preferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idLanguage.hashCode);
    _$hash = $jc(_$hash, idUserColorTheme.hashCode);
    _$hash = $jc(_$hash, idUserTypographyTheme.hashCode);
    _$hash = $jc(_$hash, preferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserGlobalConfigCreate')
          ..add('idUser', idUser)
          ..add('idLanguage', idLanguage)
          ..add('idUserColorTheme', idUserColorTheme)
          ..add('idUserTypographyTheme', idUserTypographyTheme)
          ..add('preferences', preferences))
        .toString();
  }
}

class UserGlobalConfigCreateBuilder
    implements Builder<UserGlobalConfigCreate, UserGlobalConfigCreateBuilder> {
  _$UserGlobalConfigCreate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _idLanguage;
  String? get idLanguage => _$this._idLanguage;
  set idLanguage(String? idLanguage) => _$this._idLanguage = idLanguage;

  String? _idUserColorTheme;
  String? get idUserColorTheme => _$this._idUserColorTheme;
  set idUserColorTheme(String? idUserColorTheme) =>
      _$this._idUserColorTheme = idUserColorTheme;

  String? _idUserTypographyTheme;
  String? get idUserTypographyTheme => _$this._idUserTypographyTheme;
  set idUserTypographyTheme(String? idUserTypographyTheme) =>
      _$this._idUserTypographyTheme = idUserTypographyTheme;

  String? _preferences;
  String? get preferences => _$this._preferences;
  set preferences(String? preferences) => _$this._preferences = preferences;

  UserGlobalConfigCreateBuilder() {
    UserGlobalConfigCreate._defaults(this);
  }

  UserGlobalConfigCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _idLanguage = $v.idLanguage;
      _idUserColorTheme = $v.idUserColorTheme;
      _idUserTypographyTheme = $v.idUserTypographyTheme;
      _preferences = $v.preferences;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserGlobalConfigCreate other) {
    _$v = other as _$UserGlobalConfigCreate;
  }

  @override
  void update(void Function(UserGlobalConfigCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserGlobalConfigCreate build() => _build();

  _$UserGlobalConfigCreate _build() {
    final _$result = _$v ??
        _$UserGlobalConfigCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'UserGlobalConfigCreate', 'idUser'),
          idLanguage: BuiltValueNullFieldError.checkNotNull(
              idLanguage, r'UserGlobalConfigCreate', 'idLanguage'),
          idUserColorTheme: BuiltValueNullFieldError.checkNotNull(
              idUserColorTheme, r'UserGlobalConfigCreate', 'idUserColorTheme'),
          idUserTypographyTheme: BuiltValueNullFieldError.checkNotNull(
              idUserTypographyTheme,
              r'UserGlobalConfigCreate',
              'idUserTypographyTheme'),
          preferences: BuiltValueNullFieldError.checkNotNull(
              preferences, r'UserGlobalConfigCreate', 'preferences'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
