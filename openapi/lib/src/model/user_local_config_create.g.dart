// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_config_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserLocalConfigCreate extends UserLocalConfigCreate {
  @override
  final String idUser;
  @override
  final String? idDevice;
  @override
  final String idLanguage;
  @override
  final String idUserColorTheme;
  @override
  final String idUserTypographyTheme;
  @override
  final String preferences;

  factory _$UserLocalConfigCreate(
          [void Function(UserLocalConfigCreateBuilder)? updates]) =>
      (UserLocalConfigCreateBuilder()..update(updates))._build();

  _$UserLocalConfigCreate._(
      {required this.idUser,
      this.idDevice,
      required this.idLanguage,
      required this.idUserColorTheme,
      required this.idUserTypographyTheme,
      required this.preferences})
      : super._();
  @override
  UserLocalConfigCreate rebuild(
          void Function(UserLocalConfigCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserLocalConfigCreateBuilder toBuilder() =>
      UserLocalConfigCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserLocalConfigCreate &&
        idUser == other.idUser &&
        idDevice == other.idDevice &&
        idLanguage == other.idLanguage &&
        idUserColorTheme == other.idUserColorTheme &&
        idUserTypographyTheme == other.idUserTypographyTheme &&
        preferences == other.preferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, idLanguage.hashCode);
    _$hash = $jc(_$hash, idUserColorTheme.hashCode);
    _$hash = $jc(_$hash, idUserTypographyTheme.hashCode);
    _$hash = $jc(_$hash, preferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserLocalConfigCreate')
          ..add('idUser', idUser)
          ..add('idDevice', idDevice)
          ..add('idLanguage', idLanguage)
          ..add('idUserColorTheme', idUserColorTheme)
          ..add('idUserTypographyTheme', idUserTypographyTheme)
          ..add('preferences', preferences))
        .toString();
  }
}

class UserLocalConfigCreateBuilder
    implements Builder<UserLocalConfigCreate, UserLocalConfigCreateBuilder> {
  _$UserLocalConfigCreate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _idDevice;
  String? get idDevice => _$this._idDevice;
  set idDevice(String? idDevice) => _$this._idDevice = idDevice;

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

  UserLocalConfigCreateBuilder() {
    UserLocalConfigCreate._defaults(this);
  }

  UserLocalConfigCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _idDevice = $v.idDevice;
      _idLanguage = $v.idLanguage;
      _idUserColorTheme = $v.idUserColorTheme;
      _idUserTypographyTheme = $v.idUserTypographyTheme;
      _preferences = $v.preferences;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserLocalConfigCreate other) {
    _$v = other as _$UserLocalConfigCreate;
  }

  @override
  void update(void Function(UserLocalConfigCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserLocalConfigCreate build() => _build();

  _$UserLocalConfigCreate _build() {
    final _$result = _$v ??
        _$UserLocalConfigCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'UserLocalConfigCreate', 'idUser'),
          idDevice: idDevice,
          idLanguage: BuiltValueNullFieldError.checkNotNull(
              idLanguage, r'UserLocalConfigCreate', 'idLanguage'),
          idUserColorTheme: BuiltValueNullFieldError.checkNotNull(
              idUserColorTheme, r'UserLocalConfigCreate', 'idUserColorTheme'),
          idUserTypographyTheme: BuiltValueNullFieldError.checkNotNull(
              idUserTypographyTheme,
              r'UserLocalConfigCreate',
              'idUserTypographyTheme'),
          preferences: BuiltValueNullFieldError.checkNotNull(
              preferences, r'UserLocalConfigCreate', 'preferences'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
