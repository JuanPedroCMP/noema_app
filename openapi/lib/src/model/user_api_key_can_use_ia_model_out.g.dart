// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_can_use_ia_model_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserApiKeyCanUseIaModelOut extends UserApiKeyCanUseIaModelOut {
  @override
  final String id;
  @override
  final String idAiModel;
  @override
  final String idUserApiKey;
  @override
  final DateTime? createdAt;

  factory _$UserApiKeyCanUseIaModelOut(
          [void Function(UserApiKeyCanUseIaModelOutBuilder)? updates]) =>
      (UserApiKeyCanUseIaModelOutBuilder()..update(updates))._build();

  _$UserApiKeyCanUseIaModelOut._(
      {required this.id,
      required this.idAiModel,
      required this.idUserApiKey,
      this.createdAt})
      : super._();
  @override
  UserApiKeyCanUseIaModelOut rebuild(
          void Function(UserApiKeyCanUseIaModelOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserApiKeyCanUseIaModelOutBuilder toBuilder() =>
      UserApiKeyCanUseIaModelOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserApiKeyCanUseIaModelOut &&
        id == other.id &&
        idAiModel == other.idAiModel &&
        idUserApiKey == other.idUserApiKey &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idAiModel.hashCode);
    _$hash = $jc(_$hash, idUserApiKey.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserApiKeyCanUseIaModelOut')
          ..add('id', id)
          ..add('idAiModel', idAiModel)
          ..add('idUserApiKey', idUserApiKey)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class UserApiKeyCanUseIaModelOutBuilder
    implements
        Builder<UserApiKeyCanUseIaModelOut, UserApiKeyCanUseIaModelOutBuilder> {
  _$UserApiKeyCanUseIaModelOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idAiModel;
  String? get idAiModel => _$this._idAiModel;
  set idAiModel(String? idAiModel) => _$this._idAiModel = idAiModel;

  String? _idUserApiKey;
  String? get idUserApiKey => _$this._idUserApiKey;
  set idUserApiKey(String? idUserApiKey) => _$this._idUserApiKey = idUserApiKey;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserApiKeyCanUseIaModelOutBuilder() {
    UserApiKeyCanUseIaModelOut._defaults(this);
  }

  UserApiKeyCanUseIaModelOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idAiModel = $v.idAiModel;
      _idUserApiKey = $v.idUserApiKey;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserApiKeyCanUseIaModelOut other) {
    _$v = other as _$UserApiKeyCanUseIaModelOut;
  }

  @override
  void update(void Function(UserApiKeyCanUseIaModelOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserApiKeyCanUseIaModelOut build() => _build();

  _$UserApiKeyCanUseIaModelOut _build() {
    final _$result = _$v ??
        _$UserApiKeyCanUseIaModelOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'UserApiKeyCanUseIaModelOut', 'id'),
          idAiModel: BuiltValueNullFieldError.checkNotNull(
              idAiModel, r'UserApiKeyCanUseIaModelOut', 'idAiModel'),
          idUserApiKey: BuiltValueNullFieldError.checkNotNull(
              idUserApiKey, r'UserApiKeyCanUseIaModelOut', 'idUserApiKey'),
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
