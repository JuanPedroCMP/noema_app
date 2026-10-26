// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_color_theme_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserColorThemeUpdate extends UserColorThemeUpdate {
  @override
  final String? idUser;
  @override
  final String? name;
  @override
  final int? seedColor;
  @override
  final String? overrideJson;

  factory _$UserColorThemeUpdate(
          [void Function(UserColorThemeUpdateBuilder)? updates]) =>
      (UserColorThemeUpdateBuilder()..update(updates))._build();

  _$UserColorThemeUpdate._(
      {this.idUser, this.name, this.seedColor, this.overrideJson})
      : super._();
  @override
  UserColorThemeUpdate rebuild(
          void Function(UserColorThemeUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserColorThemeUpdateBuilder toBuilder() =>
      UserColorThemeUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserColorThemeUpdate &&
        idUser == other.idUser &&
        name == other.name &&
        seedColor == other.seedColor &&
        overrideJson == other.overrideJson;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, seedColor.hashCode);
    _$hash = $jc(_$hash, overrideJson.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserColorThemeUpdate')
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('seedColor', seedColor)
          ..add('overrideJson', overrideJson))
        .toString();
  }
}

class UserColorThemeUpdateBuilder
    implements Builder<UserColorThemeUpdate, UserColorThemeUpdateBuilder> {
  _$UserColorThemeUpdate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _seedColor;
  int? get seedColor => _$this._seedColor;
  set seedColor(int? seedColor) => _$this._seedColor = seedColor;

  String? _overrideJson;
  String? get overrideJson => _$this._overrideJson;
  set overrideJson(String? overrideJson) => _$this._overrideJson = overrideJson;

  UserColorThemeUpdateBuilder() {
    UserColorThemeUpdate._defaults(this);
  }

  UserColorThemeUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _name = $v.name;
      _seedColor = $v.seedColor;
      _overrideJson = $v.overrideJson;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserColorThemeUpdate other) {
    _$v = other as _$UserColorThemeUpdate;
  }

  @override
  void update(void Function(UserColorThemeUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserColorThemeUpdate build() => _build();

  _$UserColorThemeUpdate _build() {
    final _$result = _$v ??
        _$UserColorThemeUpdate._(
          idUser: idUser,
          name: name,
          seedColor: seedColor,
          overrideJson: overrideJson,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
