// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserApiKeyOut extends UserApiKeyOut {
  @override
  final String id;
  @override
  final String idAiProvider;
  @override
  final String idUser;
  @override
  final String name;
  @override
  final String encryptedKey;
  @override
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$UserApiKeyOut([void Function(UserApiKeyOutBuilder)? updates]) =>
      (UserApiKeyOutBuilder()..update(updates))._build();

  _$UserApiKeyOut._(
      {required this.id,
      required this.idAiProvider,
      required this.idUser,
      required this.name,
      required this.encryptedKey,
      required this.isActive,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  UserApiKeyOut rebuild(void Function(UserApiKeyOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserApiKeyOutBuilder toBuilder() => UserApiKeyOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserApiKeyOut &&
        id == other.id &&
        idAiProvider == other.idAiProvider &&
        idUser == other.idUser &&
        name == other.name &&
        encryptedKey == other.encryptedKey &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idAiProvider.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, encryptedKey.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserApiKeyOut')
          ..add('id', id)
          ..add('idAiProvider', idAiProvider)
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('encryptedKey', encryptedKey)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserApiKeyOutBuilder
    implements Builder<UserApiKeyOut, UserApiKeyOutBuilder> {
  _$UserApiKeyOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idAiProvider;
  String? get idAiProvider => _$this._idAiProvider;
  set idAiProvider(String? idAiProvider) => _$this._idAiProvider = idAiProvider;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _encryptedKey;
  String? get encryptedKey => _$this._encryptedKey;
  set encryptedKey(String? encryptedKey) => _$this._encryptedKey = encryptedKey;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserApiKeyOutBuilder() {
    UserApiKeyOut._defaults(this);
  }

  UserApiKeyOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idAiProvider = $v.idAiProvider;
      _idUser = $v.idUser;
      _name = $v.name;
      _encryptedKey = $v.encryptedKey;
      _isActive = $v.isActive;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserApiKeyOut other) {
    _$v = other as _$UserApiKeyOut;
  }

  @override
  void update(void Function(UserApiKeyOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserApiKeyOut build() => _build();

  _$UserApiKeyOut _build() {
    final _$result = _$v ??
        _$UserApiKeyOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserApiKeyOut', 'id'),
          idAiProvider: BuiltValueNullFieldError.checkNotNull(
              idAiProvider, r'UserApiKeyOut', 'idAiProvider'),
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'UserApiKeyOut', 'idUser'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserApiKeyOut', 'name'),
          encryptedKey: BuiltValueNullFieldError.checkNotNull(
              encryptedKey, r'UserApiKeyOut', 'encryptedKey'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'UserApiKeyOut', 'isActive'),
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
