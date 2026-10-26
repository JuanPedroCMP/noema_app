// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_typography_theme_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserTypographyThemeOut extends UserTypographyThemeOut {
  @override
  final String id;
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
  final BuiltMap<String, JsonObject?> overrideJson;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$UserTypographyThemeOut(
          [void Function(UserTypographyThemeOutBuilder)? updates]) =>
      (UserTypographyThemeOutBuilder()..update(updates))._build();

  _$UserTypographyThemeOut._(
      {required this.id,
      required this.idUser,
      required this.name,
      required this.displayFont,
      required this.bodyFont,
      required this.monoFont,
      required this.overrideJson,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  UserTypographyThemeOut rebuild(
          void Function(UserTypographyThemeOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserTypographyThemeOutBuilder toBuilder() =>
      UserTypographyThemeOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTypographyThemeOut &&
        id == other.id &&
        idUser == other.idUser &&
        name == other.name &&
        displayFont == other.displayFont &&
        bodyFont == other.bodyFont &&
        monoFont == other.monoFont &&
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
    _$hash = $jc(_$hash, displayFont.hashCode);
    _$hash = $jc(_$hash, bodyFont.hashCode);
    _$hash = $jc(_$hash, monoFont.hashCode);
    _$hash = $jc(_$hash, overrideJson.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserTypographyThemeOut')
          ..add('id', id)
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('displayFont', displayFont)
          ..add('bodyFont', bodyFont)
          ..add('monoFont', monoFont)
          ..add('overrideJson', overrideJson)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserTypographyThemeOutBuilder
    implements Builder<UserTypographyThemeOut, UserTypographyThemeOutBuilder> {
  _$UserTypographyThemeOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  UserTypographyThemeOutBuilder() {
    UserTypographyThemeOut._defaults(this);
  }

  UserTypographyThemeOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idUser = $v.idUser;
      _name = $v.name;
      _displayFont = $v.displayFont;
      _bodyFont = $v.bodyFont;
      _monoFont = $v.monoFont;
      _overrideJson = $v.overrideJson.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserTypographyThemeOut other) {
    _$v = other as _$UserTypographyThemeOut;
  }

  @override
  void update(void Function(UserTypographyThemeOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserTypographyThemeOut build() => _build();

  _$UserTypographyThemeOut _build() {
    _$UserTypographyThemeOut _$result;
    try {
      _$result = _$v ??
          _$UserTypographyThemeOut._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'UserTypographyThemeOut', 'id'),
            idUser: BuiltValueNullFieldError.checkNotNull(
                idUser, r'UserTypographyThemeOut', 'idUser'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'UserTypographyThemeOut', 'name'),
            displayFont: BuiltValueNullFieldError.checkNotNull(
                displayFont, r'UserTypographyThemeOut', 'displayFont'),
            bodyFont: BuiltValueNullFieldError.checkNotNull(
                bodyFont, r'UserTypographyThemeOut', 'bodyFont'),
            monoFont: BuiltValueNullFieldError.checkNotNull(
                monoFont, r'UserTypographyThemeOut', 'monoFont'),
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
            r'UserTypographyThemeOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
