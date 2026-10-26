// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserApiKeyCreate extends UserApiKeyCreate {
  @override
  final String idAiProvider;
  @override
  final String name;
  @override
  final String apiKey;
  @override
  final bool? isActive;

  factory _$UserApiKeyCreate(
          [void Function(UserApiKeyCreateBuilder)? updates]) =>
      (UserApiKeyCreateBuilder()..update(updates))._build();

  _$UserApiKeyCreate._(
      {required this.idAiProvider,
      required this.name,
      required this.apiKey,
      this.isActive})
      : super._();
  @override
  UserApiKeyCreate rebuild(void Function(UserApiKeyCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserApiKeyCreateBuilder toBuilder() =>
      UserApiKeyCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserApiKeyCreate &&
        idAiProvider == other.idAiProvider &&
        name == other.name &&
        apiKey == other.apiKey &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idAiProvider.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, apiKey.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserApiKeyCreate')
          ..add('idAiProvider', idAiProvider)
          ..add('name', name)
          ..add('apiKey', apiKey)
          ..add('isActive', isActive))
        .toString();
  }
}

class UserApiKeyCreateBuilder
    implements Builder<UserApiKeyCreate, UserApiKeyCreateBuilder> {
  _$UserApiKeyCreate? _$v;

  String? _idAiProvider;
  String? get idAiProvider => _$this._idAiProvider;
  set idAiProvider(String? idAiProvider) => _$this._idAiProvider = idAiProvider;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _apiKey;
  String? get apiKey => _$this._apiKey;
  set apiKey(String? apiKey) => _$this._apiKey = apiKey;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UserApiKeyCreateBuilder() {
    UserApiKeyCreate._defaults(this);
  }

  UserApiKeyCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idAiProvider = $v.idAiProvider;
      _name = $v.name;
      _apiKey = $v.apiKey;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserApiKeyCreate other) {
    _$v = other as _$UserApiKeyCreate;
  }

  @override
  void update(void Function(UserApiKeyCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserApiKeyCreate build() => _build();

  _$UserApiKeyCreate _build() {
    final _$result = _$v ??
        _$UserApiKeyCreate._(
          idAiProvider: BuiltValueNullFieldError.checkNotNull(
              idAiProvider, r'UserApiKeyCreate', 'idAiProvider'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserApiKeyCreate', 'name'),
          apiKey: BuiltValueNullFieldError.checkNotNull(
              apiKey, r'UserApiKeyCreate', 'apiKey'),
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
