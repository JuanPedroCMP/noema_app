// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AiModelOut extends AiModelOut {
  @override
  final String id;
  @override
  final String idAiProvider;
  @override
  final String slug;
  @override
  final String displayName;
  @override
  final int contextWindow;
  @override
  final int inputTokenLimit;
  @override
  final int outputTokenLimit;
  @override
  final bool? supportsVision;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$AiModelOut([void Function(AiModelOutBuilder)? updates]) =>
      (AiModelOutBuilder()..update(updates))._build();

  _$AiModelOut._(
      {required this.id,
      required this.idAiProvider,
      required this.slug,
      required this.displayName,
      required this.contextWindow,
      required this.inputTokenLimit,
      required this.outputTokenLimit,
      this.supportsVision,
      this.isActive,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  AiModelOut rebuild(void Function(AiModelOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiModelOutBuilder toBuilder() => AiModelOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiModelOut &&
        id == other.id &&
        idAiProvider == other.idAiProvider &&
        slug == other.slug &&
        displayName == other.displayName &&
        contextWindow == other.contextWindow &&
        inputTokenLimit == other.inputTokenLimit &&
        outputTokenLimit == other.outputTokenLimit &&
        supportsVision == other.supportsVision &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idAiProvider.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, contextWindow.hashCode);
    _$hash = $jc(_$hash, inputTokenLimit.hashCode);
    _$hash = $jc(_$hash, outputTokenLimit.hashCode);
    _$hash = $jc(_$hash, supportsVision.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiModelOut')
          ..add('id', id)
          ..add('idAiProvider', idAiProvider)
          ..add('slug', slug)
          ..add('displayName', displayName)
          ..add('contextWindow', contextWindow)
          ..add('inputTokenLimit', inputTokenLimit)
          ..add('outputTokenLimit', outputTokenLimit)
          ..add('supportsVision', supportsVision)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AiModelOutBuilder implements Builder<AiModelOut, AiModelOutBuilder> {
  _$AiModelOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idAiProvider;
  String? get idAiProvider => _$this._idAiProvider;
  set idAiProvider(String? idAiProvider) => _$this._idAiProvider = idAiProvider;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  int? _contextWindow;
  int? get contextWindow => _$this._contextWindow;
  set contextWindow(int? contextWindow) =>
      _$this._contextWindow = contextWindow;

  int? _inputTokenLimit;
  int? get inputTokenLimit => _$this._inputTokenLimit;
  set inputTokenLimit(int? inputTokenLimit) =>
      _$this._inputTokenLimit = inputTokenLimit;

  int? _outputTokenLimit;
  int? get outputTokenLimit => _$this._outputTokenLimit;
  set outputTokenLimit(int? outputTokenLimit) =>
      _$this._outputTokenLimit = outputTokenLimit;

  bool? _supportsVision;
  bool? get supportsVision => _$this._supportsVision;
  set supportsVision(bool? supportsVision) =>
      _$this._supportsVision = supportsVision;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AiModelOutBuilder() {
    AiModelOut._defaults(this);
  }

  AiModelOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idAiProvider = $v.idAiProvider;
      _slug = $v.slug;
      _displayName = $v.displayName;
      _contextWindow = $v.contextWindow;
      _inputTokenLimit = $v.inputTokenLimit;
      _outputTokenLimit = $v.outputTokenLimit;
      _supportsVision = $v.supportsVision;
      _isActive = $v.isActive;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiModelOut other) {
    _$v = other as _$AiModelOut;
  }

  @override
  void update(void Function(AiModelOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiModelOut build() => _build();

  _$AiModelOut _build() {
    final _$result = _$v ??
        _$AiModelOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AiModelOut', 'id'),
          idAiProvider: BuiltValueNullFieldError.checkNotNull(
              idAiProvider, r'AiModelOut', 'idAiProvider'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AiModelOut', 'slug'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'AiModelOut', 'displayName'),
          contextWindow: BuiltValueNullFieldError.checkNotNull(
              contextWindow, r'AiModelOut', 'contextWindow'),
          inputTokenLimit: BuiltValueNullFieldError.checkNotNull(
              inputTokenLimit, r'AiModelOut', 'inputTokenLimit'),
          outputTokenLimit: BuiltValueNullFieldError.checkNotNull(
              outputTokenLimit, r'AiModelOut', 'outputTokenLimit'),
          supportsVision: supportsVision,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
