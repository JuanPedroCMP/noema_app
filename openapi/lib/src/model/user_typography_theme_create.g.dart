// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_typography_theme_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserTypographyThemeCreate extends UserTypographyThemeCreate {
  @override
  final String idUser;
  @override
  final String name;
  @override
  final String displayFont;
  @override
  final String bodyFont;
  @override
  final String monoFont;
  @override
  final String? overrideJson;

  factory _$UserTypographyThemeCreate(
          [void Function(UserTypographyThemeCreateBuilder)? updates]) =>
      (UserTypographyThemeCreateBuilder()..update(updates))._build();

  _$UserTypographyThemeCreate._(
      {required this.idUser,
      required this.name,
      required this.displayFont,
      required this.bodyFont,
      required this.monoFont,
      this.overrideJson})
      : super._();
  @override
  UserTypographyThemeCreate rebuild(
          void Function(UserTypographyThemeCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserTypographyThemeCreateBuilder toBuilder() =>
      UserTypographyThemeCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTypographyThemeCreate &&
        idUser == other.idUser &&
        name == other.name &&
        displayFont == other.displayFont &&
        bodyFont == other.bodyFont &&
        monoFont == other.monoFont &&
        overrideJson == other.overrideJson;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, displayFont.hashCode);
    _$hash = $jc(_$hash, bodyFont.hashCode);
    _$hash = $jc(_$hash, monoFont.hashCode);
    _$hash = $jc(_$hash, overrideJson.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserTypographyThemeCreate')
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('displayFont', displayFont)
          ..add('bodyFont', bodyFont)
          ..add('monoFont', monoFont)
          ..add('overrideJson', overrideJson))
        .toString();
  }
}

class UserTypographyThemeCreateBuilder
    implements
        Builder<UserTypographyThemeCreate, UserTypographyThemeCreateBuilder> {
  _$UserTypographyThemeCreate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _displayFont;
  String? get displayFont => _$this._displayFont;
  set displayFont(String? displayFont) => _$this._displayFont = displayFont;

  String? _bodyFont;
  String? get bodyFont => _$this._bodyFont;
  set bodyFont(String? bodyFont) => _$this._bodyFont = bodyFont;

  String? _monoFont;
  String? get monoFont => _$this._monoFont;
  set monoFont(String? monoFont) => _$this._monoFont = monoFont;

  String? _overrideJson;
  String? get overrideJson => _$this._overrideJson;
  set overrideJson(String? overrideJson) => _$this._overrideJson = overrideJson;

  UserTypographyThemeCreateBuilder() {
    UserTypographyThemeCreate._defaults(this);
  }

  UserTypographyThemeCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _name = $v.name;
      _displayFont = $v.displayFont;
      _bodyFont = $v.bodyFont;
      _monoFont = $v.monoFont;
      _overrideJson = $v.overrideJson;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserTypographyThemeCreate other) {
    _$v = other as _$UserTypographyThemeCreate;
  }

  @override
  void update(void Function(UserTypographyThemeCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserTypographyThemeCreate build() => _build();

  _$UserTypographyThemeCreate _build() {
    final _$result = _$v ??
        _$UserTypographyThemeCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'UserTypographyThemeCreate', 'idUser'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserTypographyThemeCreate', 'name'),
          displayFont: BuiltValueNullFieldError.checkNotNull(
              displayFont, r'UserTypographyThemeCreate', 'displayFont'),
          bodyFont: BuiltValueNullFieldError.checkNotNull(
              bodyFont, r'UserTypographyThemeCreate', 'bodyFont'),
          monoFont: BuiltValueNullFieldError.checkNotNull(
              monoFont, r'UserTypographyThemeCreate', 'monoFont'),
          overrideJson: overrideJson,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
