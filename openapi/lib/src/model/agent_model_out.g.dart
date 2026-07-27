// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgentModelOut extends AgentModelOut {
  @override
  final String id;
  @override
  final String idAgent;
  @override
  final String idAiModel;
  @override
  final AgentModelQuality qualityExpected;
  @override
  final String customSystemPrompt;
  @override
  final num? customTemperature;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$AgentModelOut([void Function(AgentModelOutBuilder)? updates]) =>
      (AgentModelOutBuilder()..update(updates))._build();

  _$AgentModelOut._(
      {required this.id,
      required this.idAgent,
      required this.idAiModel,
      required this.qualityExpected,
      required this.customSystemPrompt,
      this.customTemperature,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  AgentModelOut rebuild(void Function(AgentModelOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgentModelOutBuilder toBuilder() => AgentModelOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgentModelOut &&
        id == other.id &&
        idAgent == other.idAgent &&
        idAiModel == other.idAiModel &&
        qualityExpected == other.qualityExpected &&
        customSystemPrompt == other.customSystemPrompt &&
        customTemperature == other.customTemperature &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idAgent.hashCode);
    _$hash = $jc(_$hash, idAiModel.hashCode);
    _$hash = $jc(_$hash, qualityExpected.hashCode);
    _$hash = $jc(_$hash, customSystemPrompt.hashCode);
    _$hash = $jc(_$hash, customTemperature.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgentModelOut')
          ..add('id', id)
          ..add('idAgent', idAgent)
          ..add('idAiModel', idAiModel)
          ..add('qualityExpected', qualityExpected)
          ..add('customSystemPrompt', customSystemPrompt)
          ..add('customTemperature', customTemperature)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AgentModelOutBuilder
    implements Builder<AgentModelOut, AgentModelOutBuilder> {
  _$AgentModelOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idAgent;
  String? get idAgent => _$this._idAgent;
  set idAgent(String? idAgent) => _$this._idAgent = idAgent;

  String? _idAiModel;
  String? get idAiModel => _$this._idAiModel;
  set idAiModel(String? idAiModel) => _$this._idAiModel = idAiModel;

  AgentModelQuality? _qualityExpected;
  AgentModelQuality? get qualityExpected => _$this._qualityExpected;
  set qualityExpected(AgentModelQuality? qualityExpected) =>
      _$this._qualityExpected = qualityExpected;

  String? _customSystemPrompt;
  String? get customSystemPrompt => _$this._customSystemPrompt;
  set customSystemPrompt(String? customSystemPrompt) =>
      _$this._customSystemPrompt = customSystemPrompt;

  num? _customTemperature;
  num? get customTemperature => _$this._customTemperature;
  set customTemperature(num? customTemperature) =>
      _$this._customTemperature = customTemperature;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AgentModelOutBuilder() {
    AgentModelOut._defaults(this);
  }

  AgentModelOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idAgent = $v.idAgent;
      _idAiModel = $v.idAiModel;
      _qualityExpected = $v.qualityExpected;
      _customSystemPrompt = $v.customSystemPrompt;
      _customTemperature = $v.customTemperature;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgentModelOut other) {
    _$v = other as _$AgentModelOut;
  }

  @override
  void update(void Function(AgentModelOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgentModelOut build() => _build();

  _$AgentModelOut _build() {
    final _$result = _$v ??
        _$AgentModelOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AgentModelOut', 'id'),
          idAgent: BuiltValueNullFieldError.checkNotNull(
              idAgent, r'AgentModelOut', 'idAgent'),
          idAiModel: BuiltValueNullFieldError.checkNotNull(
              idAiModel, r'AgentModelOut', 'idAiModel'),
          qualityExpected: BuiltValueNullFieldError.checkNotNull(
              qualityExpected, r'AgentModelOut', 'qualityExpected'),
          customSystemPrompt: BuiltValueNullFieldError.checkNotNull(
              customSystemPrompt, r'AgentModelOut', 'customSystemPrompt'),
          customTemperature: customTemperature,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
