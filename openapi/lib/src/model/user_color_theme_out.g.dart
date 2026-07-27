// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_color_theme_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserColorThemeOut extends UserColorThemeOut {
  @override
  final String id;
  @override
  final String idUser;
  @override
  final String name;
  @override
  final int seedColor;
  @override
  final BuiltMap<String, JsonObject?> overrideJson;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$UserColorThemeOut(
          [void Function(UserColorThemeOutBuilder)? updates]) =>
      (UserColorThemeOutBuilder()..update(updates))._build();

  _$UserColorThemeOut._(
      {required this.id,
      required this.idUser,
      required this.name,
      required this.seedColor,
      required this.overrideJson,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  UserColorThemeOut rebuild(void Function(UserColorThemeOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserColorThemeOutBuilder toBuilder() =>
      UserColorThemeOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserColorThemeOut &&
        id == other.id &&
        idUser == other.idUser &&
        name == other.name &&
        seedColor == other.seedColor &&
        overrideJson == other.overrideJson &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, seedColor.hashCode);
    _$hash = $jc(_$hash, overrideJson.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserColorThemeOut')
          ..add('id', id)
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('seedColor', seedColor)
          ..add('overrideJson', overrideJson)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserColorThemeOutBuilder
    implements Builder<UserColorThemeOut, UserColorThemeOutBuilder> {
  _$UserColorThemeOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _seedColor;
  int? get seedColor => _$this._seedColor;
  set seedColor(int? seedColor) => _$this._seedColor = seedColor;

  MapBuilder<String, JsonObject?>? _overrideJson;
  MapBuilder<String, JsonObject?> get overrideJson =>
      _$this._overrideJson ??= MapBuilder<String, JsonObject?>();
  set overrideJson(MapBuilder<String, JsonObject?>? overrideJson) =>
      _$this._overrideJson = overrideJson;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserColorThemeOutBuilder() {
    UserColorThemeOut._defaults(this);
  }

  UserColorThemeOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idUser = $v.idUser;
      _name = $v.name;
      _seedColor = $v.seedColor;
      _overrideJson = $v.overrideJson.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserColorThemeOut other) {
    _$v = other as _$UserColorThemeOut;
  }

  @override
  void update(void Function(UserColorThemeOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserColorThemeOut build() => _build();

  _$UserColorThemeOut _build() {
    _$UserColorThemeOut _$result;
    try {
      _$result = _$v ??
          _$UserColorThemeOut._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'UserColorThemeOut', 'id'),
            idUser: BuiltValueNullFieldError.checkNotNull(
                idUser, r'UserColorThemeOut', 'idUser'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'UserColorThemeOut', 'name'),
            seedColor: BuiltValueNullFieldError.checkNotNull(
                seedColor, r'UserColorThemeOut', 'seedColor'),
            overrideJson: overrideJson.build(),
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'overrideJson';
        overrideJson.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserColorThemeOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
