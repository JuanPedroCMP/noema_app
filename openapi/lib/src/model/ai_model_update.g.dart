// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AiModelUpdateCWProxy {
  AiModelUpdate slug(String? slug);

  AiModelUpdate idAiProvider(String? idAiProvider);

  AiModelUpdate displayName(String? displayName);

  AiModelUpdate contextWindow(int? contextWindow);

  AiModelUpdate inputTokenLimit(int? inputTokenLimit);

  AiModelUpdate outputTokenLimit(int? outputTokenLimit);

  AiModelUpdate supportsVision(bool? supportsVision);

  AiModelUpdate isActive(bool? isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiModelUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiModelUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  AiModelUpdate call({
    String? slug,
    String? idAiProvider,
    String? displayName,
    int? contextWindow,
    int? inputTokenLimit,
    int? outputTokenLimit,
    bool? supportsVision,
    bool? isActive,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAiModelUpdate.copyWith(...)` or call `instanceOfAiModelUpdate.copyWith.fieldName(value)` for a single field.
class _$AiModelUpdateCWProxyImpl implements _$AiModelUpdateCWProxy {
  const _$AiModelUpdateCWProxyImpl(this._value);

  final AiModelUpdate _value;

  @override
  AiModelUpdate slug(String? slug) => call(slug: slug);

  @override
  AiModelUpdate idAiProvider(String? idAiProvider) =>
      call(idAiProvider: idAiProvider);

  @override
  AiModelUpdate displayName(String? displayName) =>
      call(displayName: displayName);

  @override
  AiModelUpdate contextWindow(int? contextWindow) =>
      call(contextWindow: contextWindow);

  @override
  AiModelUpdate inputTokenLimit(int? inputTokenLimit) =>
      call(inputTokenLimit: inputTokenLimit);

  @override
  AiModelUpdate outputTokenLimit(int? outputTokenLimit) =>
      call(outputTokenLimit: outputTokenLimit);

  @override
  AiModelUpdate supportsVision(bool? supportsVision) =>
      call(supportsVision: supportsVision);

  @override
  AiModelUpdate isActive(bool? isActive) => call(isActive: isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiModelUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiModelUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AiModelUpdate call({
    Object? slug = const $CopyWithPlaceholder(),
    Object? idAiProvider = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? contextWindow = const $CopyWithPlaceholder(),
    Object? inputTokenLimit = const $CopyWithPlaceholder(),
    Object? outputTokenLimit = const $CopyWithPlaceholder(),
    Object? supportsVision = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return AiModelUpdate(
      slug: slug == const $CopyWithPlaceholder()
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String?,
      idAiProvider: idAiProvider == const $CopyWithPlaceholder()
          ? _value.idAiProvider
          // ignore: cast_nullable_to_non_nullable
          : idAiProvider as String?,
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String?,
      contextWindow: contextWindow == const $CopyWithPlaceholder()
          ? _value.contextWindow
          // ignore: cast_nullable_to_non_nullable
          : contextWindow as int?,
      inputTokenLimit: inputTokenLimit == const $CopyWithPlaceholder()
          ? _value.inputTokenLimit
          // ignore: cast_nullable_to_non_nullable
          : inputTokenLimit as int?,
      outputTokenLimit: outputTokenLimit == const $CopyWithPlaceholder()
          ? _value.outputTokenLimit
          // ignore: cast_nullable_to_non_nullable
          : outputTokenLimit as int?,
      supportsVision: supportsVision == const $CopyWithPlaceholder()
          ? _value.supportsVision
          // ignore: cast_nullable_to_non_nullable
          : supportsVision as bool?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $AiModelUpdateCopyWith on AiModelUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAiModelUpdate.copyWith(...)` or `instanceOfAiModelUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AiModelUpdateCWProxy get copyWith => _$AiModelUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiModelUpdate _$AiModelUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AiModelUpdate',
      json,
      ($checkedConvert) {
        final val = AiModelUpdate(
          slug: $checkedConvert('slug', (v) => v as String?),
          idAiProvider: $checkedConvert('id_ai_provider', (v) => v as String?),
          displayName: $checkedConvert('display_name', (v) => v as String?),
          contextWindow: $checkedConvert(
            'context_window',
            (v) => (v as num?)?.toInt(),
          ),
          inputTokenLimit: $checkedConvert(
            'input_token_limit',
            (v) => (v as num?)?.toInt(),
          ),
          outputTokenLimit: $checkedConvert(
            'output_token_limit',
            (v) => (v as num?)?.toInt(),
          ),
          supportsVision: $checkedConvert('supports_vision', (v) => v as bool?),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
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
      },
    );

Map<String, dynamic> _$AiModelUpdateToJson(AiModelUpdate instance) =>
    <String, dynamic>{
      'slug': ?instance.slug,
      'id_ai_provider': ?instance.idAiProvider,
      'display_name': ?instance.displayName,
      'context_window': ?instance.contextWindow,
      'input_token_limit': ?instance.inputTokenLimit,
      'output_token_limit': ?instance.outputTokenLimit,
      'supports_vision': ?instance.supportsVision,
      'is_active': ?instance.isActive,
    };
