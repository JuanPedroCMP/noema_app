// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_can_use_ia_model_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserApiKeyCanUseIaModelCreate extends UserApiKeyCanUseIaModelCreate {
  @override
  final String idAiModel;
  @override
  final String idUserApiKey;

  factory _$UserApiKeyCanUseIaModelCreate(
          [void Function(UserApiKeyCanUseIaModelCreateBuilder)? updates]) =>
      (UserApiKeyCanUseIaModelCreateBuilder()..update(updates))._build();

  _$UserApiKeyCanUseIaModelCreate._(
      {required this.idAiModel, required this.idUserApiKey})
      : super._();
  @override
  UserApiKeyCanUseIaModelCreate rebuild(
          void Function(UserApiKeyCanUseIaModelCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserApiKeyCanUseIaModelCreateBuilder toBuilder() =>
      UserApiKeyCanUseIaModelCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserApiKeyCanUseIaModelCreate &&
        idAiModel == other.idAiModel &&
        idUserApiKey == other.idUserApiKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idAiModel.hashCode);
    _$hash = $jc(_$hash, idUserApiKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserApiKeyCanUseIaModelCreate')
          ..add('idAiModel', idAiModel)
          ..add('idUserApiKey', idUserApiKey))
        .toString();
  }
}

class UserApiKeyCanUseIaModelCreateBuilder
    implements
        Builder<UserApiKeyCanUseIaModelCreate,
            UserApiKeyCanUseIaModelCreateBuilder> {
  _$UserApiKeyCanUseIaModelCreate? _$v;

  String? _idAiModel;
  String? get idAiModel => _$this._idAiModel;
  set idAiModel(String? idAiModel) => _$this._idAiModel = idAiModel;

  String? _idUserApiKey;
  String? get idUserApiKey => _$this._idUserApiKey;
  set idUserApiKey(String? idUserApiKey) => _$this._idUserApiKey = idUserApiKey;

  UserApiKeyCanUseIaModelCreateBuilder() {
    UserApiKeyCanUseIaModelCreate._defaults(this);
  }

  UserApiKeyCanUseIaModelCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idAiModel = $v.idAiModel;
      _idUserApiKey = $v.idUserApiKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserApiKeyCanUseIaModelCreate other) {
    _$v = other as _$UserApiKeyCanUseIaModelCreate;
  }

  @override
  void update(void Function(UserApiKeyCanUseIaModelCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserApiKeyCanUseIaModelCreate build() => _build();

  _$UserApiKeyCanUseIaModelCreate _build() {
    final _$result = _$v ??
        _$UserApiKeyCanUseIaModelCreate._(
          idAiModel: BuiltValueNullFieldError.checkNotNull(
              idAiModel, r'UserApiKeyCanUseIaModelCreate', 'idAiModel'),
          idUserApiKey: BuiltValueNullFieldError.checkNotNull(
              idUserApiKey, r'UserApiKeyCanUseIaModelCreate', 'idUserApiKey'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
