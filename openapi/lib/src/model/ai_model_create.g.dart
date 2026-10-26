// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AiModelCreate extends AiModelCreate {
  @override
  final String slug;
  @override
  final String idAiProvider;
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

  factory _$AiModelCreate([void Function(AiModelCreateBuilder)? updates]) =>
      (AiModelCreateBuilder()..update(updates))._build();

  _$AiModelCreate._(
      {required this.slug,
      required this.idAiProvider,
      required this.displayName,
      required this.contextWindow,
      required this.inputTokenLimit,
      required this.outputTokenLimit,
      this.supportsVision,
      this.isActive})
      : super._();
  @override
  AiModelCreate rebuild(void Function(AiModelCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiModelCreateBuilder toBuilder() => AiModelCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiModelCreate &&
        slug == other.slug &&
        idAiProvider == other.idAiProvider &&
        displayName == other.displayName &&
        contextWindow == other.contextWindow &&
        inputTokenLimit == other.inputTokenLimit &&
        outputTokenLimit == other.outputTokenLimit &&
        supportsVision == other.supportsVision &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, idAiProvider.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, contextWindow.hashCode);
    _$hash = $jc(_$hash, inputTokenLimit.hashCode);
    _$hash = $jc(_$hash, outputTokenLimit.hashCode);
    _$hash = $jc(_$hash, supportsVision.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiModelCreate')
          ..add('slug', slug)
          ..add('idAiProvider', idAiProvider)
          ..add('displayName', displayName)
          ..add('contextWindow', contextWindow)
          ..add('inputTokenLimit', inputTokenLimit)
          ..add('outputTokenLimit', outputTokenLimit)
          ..add('supportsVision', supportsVision)
          ..add('isActive', isActive))
        .toString();
  }
}

class AiModelCreateBuilder
    implements Builder<AiModelCreate, AiModelCreateBuilder> {
  _$AiModelCreate? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _idAiProvider;
  String? get idAiProvider => _$this._idAiProvider;
  set idAiProvider(String? idAiProvider) => _$this._idAiProvider = idAiProvider;

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

  AiModelCreateBuilder() {
    AiModelCreate._defaults(this);
  }

  AiModelCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _idAiProvider = $v.idAiProvider;
      _displayName = $v.displayName;
      _contextWindow = $v.contextWindow;
      _inputTokenLimit = $v.inputTokenLimit;
      _outputTokenLimit = $v.outputTokenLimit;
      _supportsVision = $v.supportsVision;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiModelCreate other) {
    _$v = other as _$AiModelCreate;
  }

  @override
  void update(void Function(AiModelCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiModelCreate build() => _build();

  _$AiModelCreate _build() {
    final _$result = _$v ??
        _$AiModelCreate._(
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AiModelCreate', 'slug'),
          idAiProvider: BuiltValueNullFieldError.checkNotNull(
              idAiProvider, r'AiModelCreate', 'idAiProvider'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'AiModelCreate', 'displayName'),
          contextWindow: BuiltValueNullFieldError.checkNotNull(
              contextWindow, r'AiModelCreate', 'contextWindow'),
          inputTokenLimit: BuiltValueNullFieldError.checkNotNull(
              inputTokenLimit, r'AiModelCreate', 'inputTokenLimit'),
          outputTokenLimit: BuiltValueNullFieldError.checkNotNull(
              outputTokenLimit, r'AiModelCreate', 'outputTokenLimit'),
          supportsVision: supportsVision,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
