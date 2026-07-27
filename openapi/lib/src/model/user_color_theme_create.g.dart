// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_color_theme_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserColorThemeCreate extends UserColorThemeCreate {
  @override
  final String idUser;
  @override
  final String name;
  @override
  final int seedColor;
  @override
  final String overrideJson;

  factory _$UserColorThemeCreate(
          [void Function(UserColorThemeCreateBuilder)? updates]) =>
      (UserColorThemeCreateBuilder()..update(updates))._build();

  _$UserColorThemeCreate._(
      {required this.idUser,
      required this.name,
      required this.seedColor,
      required this.overrideJson})
      : super._();
  @override
  UserColorThemeCreate rebuild(
          void Function(UserColorThemeCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserColorThemeCreateBuilder toBuilder() =>
      UserColorThemeCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserColorThemeCreate &&
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
    return (newBuiltValueToStringHelper(r'UserColorThemeCreate')
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('seedColor', seedColor)
          ..add('overrideJson', overrideJson))
        .toString();
  }
}

class UserColorThemeCreateBuilder
    implements Builder<UserColorThemeCreate, UserColorThemeCreateBuilder> {
  _$UserColorThemeCreate? _$v;

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

  UserColorThemeCreateBuilder() {
    UserColorThemeCreate._defaults(this);
  }

  UserColorThemeCreateBuilder get _$this {
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
  void replace(UserColorThemeCreate other) {
    _$v = other as _$UserColorThemeCreate;
  }

  @override
  void update(void Function(UserColorThemeCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserColorThemeCreate build() => _build();

  _$UserColorThemeCreate _build() {
    final _$result = _$v ??
        _$UserColorThemeCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'UserColorThemeCreate', 'idUser'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserColorThemeCreate', 'name'),
          seedColor: BuiltValueNullFieldError.checkNotNull(
              seedColor, r'UserColorThemeCreate', 'seedColor'),
          overrideJson: BuiltValueNullFieldError.checkNotNull(
              overrideJson, r'UserColorThemeCreate', 'overrideJson'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
