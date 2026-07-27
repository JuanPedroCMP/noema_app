// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_typography_theme_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserTypographyThemeUpdate extends UserTypographyThemeUpdate {
  @override
  final String? idUser;
  @override
  final String? name;
  @override
  final String? displayFont;
  @override
  final String? bodyFont;
  @override
  final String? monoFont;
  @override
  final String? overrideJson;

  factory _$UserTypographyThemeUpdate(
          [void Function(UserTypographyThemeUpdateBuilder)? updates]) =>
      (UserTypographyThemeUpdateBuilder()..update(updates))._build();

  _$UserTypographyThemeUpdate._(
      {this.idUser,
      this.name,
      this.displayFont,
      this.bodyFont,
      this.monoFont,
      this.overrideJson})
      : super._();
  @override
  UserTypographyThemeUpdate rebuild(
          void Function(UserTypographyThemeUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserTypographyThemeUpdateBuilder toBuilder() =>
      UserTypographyThemeUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTypographyThemeUpdate &&
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
    return (newBuiltValueToStringHelper(r'UserTypographyThemeUpdate')
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('displayFont', displayFont)
          ..add('bodyFont', bodyFont)
          ..add('monoFont', monoFont)
          ..add('overrideJson', overrideJson))
        .toString();
  }
}

class UserTypographyThemeUpdateBuilder
    implements
        Builder<UserTypographyThemeUpdate, UserTypographyThemeUpdateBuilder> {
  _$UserTypographyThemeUpdate? _$v;

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

  UserTypographyThemeUpdateBuilder() {
    UserTypographyThemeUpdate._defaults(this);
  }

  UserTypographyThemeUpdateBuilder get _$this {
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
  void replace(UserTypographyThemeUpdate other) {
    _$v = other as _$UserTypographyThemeUpdate;
  }

  @override
  void update(void Function(UserTypographyThemeUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserTypographyThemeUpdate build() => _build();

  _$UserTypographyThemeUpdate _build() {
    final _$result = _$v ??
        _$UserTypographyThemeUpdate._(
          idUser: idUser,
          name: name,
          displayFont: displayFont,
          bodyFont: bodyFont,
          monoFont: monoFont,
          overrideJson: overrideJson,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
