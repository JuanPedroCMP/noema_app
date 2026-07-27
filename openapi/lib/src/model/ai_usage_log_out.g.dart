// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage_log_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AiUsageLogOut extends AiUsageLogOut {
  @override
  final String id;
  @override
  final String idUser;
  @override
  final String idAgentModel;
  @override
  final JsonObject? usageDatails;
  @override
  final DateTime? createdAt;

  factory _$AiUsageLogOut([void Function(AiUsageLogOutBuilder)? updates]) =>
      (AiUsageLogOutBuilder()..update(updates))._build();

  _$AiUsageLogOut._(
      {required this.id,
      required this.idUser,
      required this.idAgentModel,
      this.usageDatails,
      this.createdAt})
      : super._();
  @override
  AiUsageLogOut rebuild(void Function(AiUsageLogOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiUsageLogOutBuilder toBuilder() => AiUsageLogOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiUsageLogOut &&
        id == other.id &&
        idUser == other.idUser &&
        idAgentModel == other.idAgentModel &&
        usageDatails == other.usageDatails &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idAgentModel.hashCode);
    _$hash = $jc(_$hash, usageDatails.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiUsageLogOut')
          ..add('id', id)
          ..add('idUser', idUser)
          ..add('idAgentModel', idAgentModel)
          ..add('usageDatails', usageDatails)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AiUsageLogOutBuilder
    implements Builder<AiUsageLogOut, AiUsageLogOutBuilder> {
  _$AiUsageLogOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _idAgentModel;
  String? get idAgentModel => _$this._idAgentModel;
  set idAgentModel(String? idAgentModel) => _$this._idAgentModel = idAgentModel;

  JsonObject? _usageDatails;
  JsonObject? get usageDatails => _$this._usageDatails;
  set usageDatails(JsonObject? usageDatails) =>
      _$this._usageDatails = usageDatails;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AiUsageLogOutBuilder() {
    AiUsageLogOut._defaults(this);
  }

  AiUsageLogOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idUser = $v.idUser;
      _idAgentModel = $v.idAgentModel;
      _usageDatails = $v.usageDatails;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiUsageLogOut other) {
    _$v = other as _$AiUsageLogOut;
  }

  @override
  void update(void Function(AiUsageLogOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiUsageLogOut build() => _build();

  _$AiUsageLogOut _build() {
    final _$result = _$v ??
        _$AiUsageLogOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AiUsageLogOut', 'id'),
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'AiUsageLogOut', 'idUser'),
          idAgentModel: BuiltValueNullFieldError.checkNotNull(
              idAgentModel, r'AiUsageLogOut', 'idAgentModel'),
          usageDatails: usageDatails,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
