// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage_log_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AiUsageLogCreate extends AiUsageLogCreate {
  @override
  final String idUser;
  @override
  final String idAgentModel;
  @override
  final String usageDatails;

  factory _$AiUsageLogCreate(
          [void Function(AiUsageLogCreateBuilder)? updates]) =>
      (AiUsageLogCreateBuilder()..update(updates))._build();

  _$AiUsageLogCreate._(
      {required this.idUser,
      required this.idAgentModel,
      required this.usageDatails})
      : super._();
  @override
  AiUsageLogCreate rebuild(void Function(AiUsageLogCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiUsageLogCreateBuilder toBuilder() =>
      AiUsageLogCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiUsageLogCreate &&
        idUser == other.idUser &&
        idAgentModel == other.idAgentModel &&
        usageDatails == other.usageDatails;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idAgentModel.hashCode);
    _$hash = $jc(_$hash, usageDatails.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiUsageLogCreate')
          ..add('idUser', idUser)
          ..add('idAgentModel', idAgentModel)
          ..add('usageDatails', usageDatails))
        .toString();
  }
}

class AiUsageLogCreateBuilder
    implements Builder<AiUsageLogCreate, AiUsageLogCreateBuilder> {
  _$AiUsageLogCreate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _idAgentModel;
  String? get idAgentModel => _$this._idAgentModel;
  set idAgentModel(String? idAgentModel) => _$this._idAgentModel = idAgentModel;

  String? _usageDatails;
  String? get usageDatails => _$this._usageDatails;
  set usageDatails(String? usageDatails) => _$this._usageDatails = usageDatails;

  AiUsageLogCreateBuilder() {
    AiUsageLogCreate._defaults(this);
  }

  AiUsageLogCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _idAgentModel = $v.idAgentModel;
      _usageDatails = $v.usageDatails;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiUsageLogCreate other) {
    _$v = other as _$AiUsageLogCreate;
  }

  @override
  void update(void Function(AiUsageLogCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiUsageLogCreate build() => _build();

  _$AiUsageLogCreate _build() {
    final _$result = _$v ??
        _$AiUsageLogCreate._(
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'AiUsageLogCreate', 'idUser'),
          idAgentModel: BuiltValueNullFieldError.checkNotNull(
              idAgentModel, r'AiUsageLogCreate', 'idAgentModel'),
          usageDatails: BuiltValueNullFieldError.checkNotNull(
              usageDatails, r'AiUsageLogCreate', 'usageDatails'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
