// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserApiKeyUpdate extends UserApiKeyUpdate {
  @override
  final String? idAiProvider;
  @override
  final String? idUser;
  @override
  final String? name;
  @override
  final String? apiKey;
  @override
  final bool? isActive;

  factory _$UserApiKeyUpdate(
          [void Function(UserApiKeyUpdateBuilder)? updates]) =>
      (UserApiKeyUpdateBuilder()..update(updates))._build();

  _$UserApiKeyUpdate._(
      {this.idAiProvider, this.idUser, this.name, this.apiKey, this.isActive})
      : super._();
  @override
  UserApiKeyUpdate rebuild(void Function(UserApiKeyUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserApiKeyUpdateBuilder toBuilder() =>
      UserApiKeyUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserApiKeyUpdate &&
        idAiProvider == other.idAiProvider &&
        idUser == other.idUser &&
        name == other.name &&
        apiKey == other.apiKey &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idAiProvider.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, apiKey.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserApiKeyUpdate')
          ..add('idAiProvider', idAiProvider)
          ..add('idUser', idUser)
          ..add('name', name)
          ..add('apiKey', apiKey)
          ..add('isActive', isActive))
        .toString();
  }
}

class UserApiKeyUpdateBuilder
    implements Builder<UserApiKeyUpdate, UserApiKeyUpdateBuilder> {
  _$UserApiKeyUpdate? _$v;

  String? _idAiProvider;
  String? get idAiProvider => _$this._idAiProvider;
  set idAiProvider(String? idAiProvider) => _$this._idAiProvider = idAiProvider;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _apiKey;
  String? get apiKey => _$this._apiKey;
  set apiKey(String? apiKey) => _$this._apiKey = apiKey;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UserApiKeyUpdateBuilder() {
    UserApiKeyUpdate._defaults(this);
  }

  UserApiKeyUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idAiProvider = $v.idAiProvider;
      _idUser = $v.idUser;
      _name = $v.name;
      _apiKey = $v.apiKey;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserApiKeyUpdate other) {
    _$v = other as _$UserApiKeyUpdate;
  }

  @override
  void update(void Function(UserApiKeyUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserApiKeyUpdate build() => _build();

  _$UserApiKeyUpdate _build() {
    final _$result = _$v ??
        _$UserApiKeyUpdate._(
          idAiProvider: idAiProvider,
          idUser: idUser,
          name: name,
          apiKey: apiKey,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
