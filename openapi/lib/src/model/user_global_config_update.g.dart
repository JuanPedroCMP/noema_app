// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_config_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserGlobalConfigUpdate extends UserGlobalConfigUpdate {
  @override
  final String? idUser;
  @override
  final String? idLanguage;
  @override
  final String? idUserColorTheme;
  @override
  final String? idUserTypographyTheme;
  @override
  final String? preferences;

  factory _$UserGlobalConfigUpdate(
          [void Function(UserGlobalConfigUpdateBuilder)? updates]) =>
      (UserGlobalConfigUpdateBuilder()..update(updates))._build();

  _$UserGlobalConfigUpdate._(
      {this.idUser,
      this.idLanguage,
      this.idUserColorTheme,
      this.idUserTypographyTheme,
      this.preferences})
      : super._();
  @override
  UserGlobalConfigUpdate rebuild(
          void Function(UserGlobalConfigUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserGlobalConfigUpdateBuilder toBuilder() =>
      UserGlobalConfigUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserGlobalConfigUpdate &&
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
    return (newBuiltValueToStringHelper(r'UserGlobalConfigUpdate')
          ..add('idUser', idUser)
          ..add('idLanguage', idLanguage)
          ..add('idUserColorTheme', idUserColorTheme)
          ..add('idUserTypographyTheme', idUserTypographyTheme)
          ..add('preferences', preferences))
        .toString();
  }
}

class UserGlobalConfigUpdateBuilder
    implements Builder<UserGlobalConfigUpdate, UserGlobalConfigUpdateBuilder> {
  _$UserGlobalConfigUpdate? _$v;

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

  UserGlobalConfigUpdateBuilder() {
    UserGlobalConfigUpdate._defaults(this);
  }

  UserGlobalConfigUpdateBuilder get _$this {
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
  void replace(UserGlobalConfigUpdate other) {
    _$v = other as _$UserGlobalConfigUpdate;
  }

  @override
  void update(void Function(UserGlobalConfigUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserGlobalConfigUpdate build() => _build();

  _$UserGlobalConfigUpdate _build() {
    final _$result = _$v ??
        _$UserGlobalConfigUpdate._(
          idUser: idUser,
          idLanguage: idLanguage,
          idUserColorTheme: idUserColorTheme,
          idUserTypographyTheme: idUserTypographyTheme,
          preferences: preferences,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
