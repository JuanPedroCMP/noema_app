// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AiModelOutCWProxy {
  AiModelOut id(String id);

  AiModelOut idAiProvider(String idAiProvider);

  AiModelOut slug(String slug);

  AiModelOut displayName(String displayName);

  AiModelOut contextWindow(int contextWindow);

  AiModelOut inputTokenLimit(int inputTokenLimit);

  AiModelOut outputTokenLimit(int outputTokenLimit);

  AiModelOut supportsVision(bool? supportsVision);

  AiModelOut isActive(bool? isActive);

  AiModelOut createdAt(DateTime? createdAt);

  AiModelOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiModelOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiModelOut(...).copyWith(id: 12, name: "My name")
  /// ```
  AiModelOut call({
    String id,
    String idAiProvider,
    String slug,
    String displayName,
    int contextWindow,
    int inputTokenLimit,
    int outputTokenLimit,
    bool? supportsVision,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAiModelOut.copyWith(...)` or call `instanceOfAiModelOut.copyWith.fieldName(value)` for a single field.
class _$AiModelOutCWProxyImpl implements _$AiModelOutCWProxy {
  const _$AiModelOutCWProxyImpl(this._value);

  final AiModelOut _value;

  @override
  AiModelOut id(String id) => call(id: id);

  @override
  AiModelOut idAiProvider(String idAiProvider) =>
      call(idAiProvider: idAiProvider);

  @override
  AiModelOut slug(String slug) => call(slug: slug);

  @override
  AiModelOut displayName(String displayName) => call(displayName: displayName);

  @override
  AiModelOut contextWindow(int contextWindow) =>
      call(contextWindow: contextWindow);

  @override
  AiModelOut inputTokenLimit(int inputTokenLimit) =>
      call(inputTokenLimit: inputTokenLimit);

  @override
  AiModelOut outputTokenLimit(int outputTokenLimit) =>
      call(outputTokenLimit: outputTokenLimit);

  @override
  AiModelOut supportsVision(bool? supportsVision) =>
      call(supportsVision: supportsVision);

  @override
  AiModelOut isActive(bool? isActive) => call(isActive: isActive);

  @override
  AiModelOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  AiModelOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiModelOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiModelOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AiModelOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idAiProvider = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? contextWindow = const $CopyWithPlaceholder(),
    Object? inputTokenLimit = const $CopyWithPlaceholder(),
    Object? outputTokenLimit = const $CopyWithPlaceholder(),
    Object? supportsVision = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return AiModelOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idAiProvider:
          idAiProvider == const $CopyWithPlaceholder() || idAiProvider == null
          ? _value.idAiProvider
          // ignore: cast_nullable_to_non_nullable
          : idAiProvider as String,
      slug: slug == const $CopyWithPlaceholder() || slug == null
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String,
      displayName:
          displayName == const $CopyWithPlaceholder() || displayName == null
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String,
      contextWindow:
          contextWindow == const $CopyWithPlaceholder() || contextWindow == null
          ? _value.contextWindow
          // ignore: cast_nullable_to_non_nullable
          : contextWindow as int,
      inputTokenLimit:
          inputTokenLimit == const $CopyWithPlaceholder() ||
              inputTokenLimit == null
          ? _value.inputTokenLimit
          // ignore: cast_nullable_to_non_nullable
          : inputTokenLimit as int,
      outputTokenLimit:
          outputTokenLimit == const $CopyWithPlaceholder() ||
              outputTokenLimit == null
          ? _value.outputTokenLimit
          // ignore: cast_nullable_to_non_nullable
          : outputTokenLimit as int,
      supportsVision: supportsVision == const $CopyWithPlaceholder()
          ? _value.supportsVision
          // ignore: cast_nullable_to_non_nullable
          : supportsVision as bool?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $AiModelOutCopyWith on AiModelOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAiModelOut.copyWith(...)` or `instanceOfAiModelOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AiModelOutCWProxy get copyWith => _$AiModelOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiModelOut _$AiModelOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AiModelOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'id_ai_provider',
        'slug',
        'display_name',
        'context_window',
        'input_token_limit',
        'output_token_limit',
        'supports_vision',
        'is_active',
        'created_at',
        'updated_at',
      ],
    );
    final val = AiModelOut(
      id: $checkedConvert('id', (v) => v as String),
      idAiProvider: $checkedConvert('id_ai_provider', (v) => v as String),
      slug: $checkedConvert('slug', (v) => v as String),
      displayName: $checkedConvert('display_name', (v) => v as String),
      contextWindow: $checkedConvert(
        'context_window',
        (v) => (v as num).toInt(),
      ),
      inputTokenLimit: $checkedConvert(
        'input_token_limit',
        (v) => (v as num).toInt(),
      ),
      outputTokenLimit: $checkedConvert(
        'output_token_limit',
        (v) => (v as num).toInt(),
      ),
      supportsVision: $checkedConvert('supports_vision', (v) => v as bool?),
      isActive: $checkedConvert('is_active', (v) => v as bool?),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'idAiProvider': 'id_ai_provider',
    'displayName': 'display_name',
    'contextWindow': 'context_window',
    'inputTokenLimit': 'input_token_limit',
    'outputTokenLimit': 'output_token_limit',
    'supportsVision': 'supports_vision',
    'isActive': 'is_active',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$AiModelOutToJson(AiModelOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_ai_provider': instance.idAiProvider,
      'slug': instance.slug,
      'display_name': instance.displayName,
      'context_window': instance.contextWindow,
      'input_token_limit': instance.inputTokenLimit,
      'output_token_limit': instance.outputTokenLimit,
      'supports_vision': instance.supportsVision,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
