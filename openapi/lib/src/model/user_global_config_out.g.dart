// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_config_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserGlobalConfigOut extends UserGlobalConfigOut {
  @override
  final String id;
  @override
  final String idUser;
  @override
  final String idLanguage;
  @override
  final String idUserColorTheme;
  @override
  final String idUserTypographyTheme;
  @override
  final BuiltMap<String, JsonObject?> preferences;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$UserGlobalConfigOut(
          [void Function(UserGlobalConfigOutBuilder)? updates]) =>
      (UserGlobalConfigOutBuilder()..update(updates))._build();

  _$UserGlobalConfigOut._(
      {required this.id,
      required this.idUser,
      required this.idLanguage,
      required this.idUserColorTheme,
      required this.idUserTypographyTheme,
      required this.preferences,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  UserGlobalConfigOut rebuild(
          void Function(UserGlobalConfigOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserGlobalConfigOutBuilder toBuilder() =>
      UserGlobalConfigOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserGlobalConfigOut &&
        id == other.id &&
        idUser == other.idUser &&
        idLanguage == other.idLanguage &&
        idUserColorTheme == other.idUserColorTheme &&
        idUserTypographyTheme == other.idUserTypographyTheme &&
        preferences == other.preferences &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idLanguage.hashCode);
    _$hash = $jc(_$hash, idUserColorTheme.hashCode);
    _$hash = $jc(_$hash, idUserTypographyTheme.hashCode);
    _$hash = $jc(_$hash, preferences.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserGlobalConfigOut')
          ..add('id', id)
          ..add('idUser', idUser)
          ..add('idLanguage', idLanguage)
          ..add('idUserColorTheme', idUserColorTheme)
          ..add('idUserTypographyTheme', idUserTypographyTheme)
          ..add('preferences', preferences)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserGlobalConfigOutBuilder
    implements Builder<UserGlobalConfigOut, UserGlobalConfigOutBuilder> {
  _$UserGlobalConfigOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  MapBuilder<String, JsonObject?>? _preferences;
  MapBuilder<String, JsonObject?> get preferences =>
      _$this._preferences ??= MapBuilder<String, JsonObject?>();
  set preferences(MapBuilder<String, JsonObject?>? preferences) =>
      _$this._preferences = preferences;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserGlobalConfigOutBuilder() {
    UserGlobalConfigOut._defaults(this);
  }

  UserGlobalConfigOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idUser = $v.idUser;
      _idLanguage = $v.idLanguage;
      _idUserColorTheme = $v.idUserColorTheme;
      _idUserTypographyTheme = $v.idUserTypographyTheme;
      _preferences = $v.preferences.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserGlobalConfigOut other) {
    _$v = other as _$UserGlobalConfigOut;
  }

  @override
  void update(void Function(UserGlobalConfigOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserGlobalConfigOut build() => _build();

  _$UserGlobalConfigOut _build() {
    _$UserGlobalConfigOut _$result;
    try {
      _$result = _$v ??
          _$UserGlobalConfigOut._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'UserGlobalConfigOut', 'id'),
            idUser: BuiltValueNullFieldError.checkNotNull(
                idUser, r'UserGlobalConfigOut', 'idUser'),
            idLanguage: BuiltValueNullFieldError.checkNotNull(
                idLanguage, r'UserGlobalConfigOut', 'idLanguage'),
            idUserColorTheme: BuiltValueNullFieldError.checkNotNull(
                idUserColorTheme, r'UserGlobalConfigOut', 'idUserColorTheme'),
            idUserTypographyTheme: BuiltValueNullFieldError.checkNotNull(
                idUserTypographyTheme,
                r'UserGlobalConfigOut',
                'idUserTypographyTheme'),
            preferences: preferences.build(),
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'preferences';
        preferences.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserGlobalConfigOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
