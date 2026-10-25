// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AiModelCreateCWProxy {
  AiModelCreate slug(String slug);

  AiModelCreate idAiProvider(String idAiProvider);

  AiModelCreate displayName(String displayName);

  AiModelCreate contextWindow(int contextWindow);

  AiModelCreate inputTokenLimit(int inputTokenLimit);

  AiModelCreate outputTokenLimit(int outputTokenLimit);

  AiModelCreate supportsVision(bool? supportsVision);

  AiModelCreate isActive(bool? isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiModelCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiModelCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  AiModelCreate call({
    String slug,
    String idAiProvider,
    String displayName,
    int contextWindow,
    int inputTokenLimit,
    int outputTokenLimit,
    bool? supportsVision,
    bool? isActive,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAiModelCreate.copyWith(...)` or call `instanceOfAiModelCreate.copyWith.fieldName(value)` for a single field.
class _$AiModelCreateCWProxyImpl implements _$AiModelCreateCWProxy {
  const _$AiModelCreateCWProxyImpl(this._value);

  final AiModelCreate _value;

  @override
  AiModelCreate slug(String slug) => call(slug: slug);

  @override
  AiModelCreate idAiProvider(String idAiProvider) =>
      call(idAiProvider: idAiProvider);

  @override
  AiModelCreate displayName(String displayName) =>
      call(displayName: displayName);

  @override
  AiModelCreate contextWindow(int contextWindow) =>
      call(contextWindow: contextWindow);

  @override
  AiModelCreate inputTokenLimit(int inputTokenLimit) =>
      call(inputTokenLimit: inputTokenLimit);

  @override
  AiModelCreate outputTokenLimit(int outputTokenLimit) =>
      call(outputTokenLimit: outputTokenLimit);

  @override
  AiModelCreate supportsVision(bool? supportsVision) =>
      call(supportsVision: supportsVision);

  @override
  AiModelCreate isActive(bool? isActive) => call(isActive: isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiModelCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiModelCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AiModelCreate call({
    Object? slug = const $CopyWithPlaceholder(),
    Object? idAiProvider = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? contextWindow = const $CopyWithPlaceholder(),
    Object? inputTokenLimit = const $CopyWithPlaceholder(),
    Object? outputTokenLimit = const $CopyWithPlaceholder(),
    Object? supportsVision = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return AiModelCreate(
      slug: slug == const $CopyWithPlaceholder() || slug == null
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String,
      idAiProvider:
          idAiProvider == const $CopyWithPlaceholder() || idAiProvider == null
          ? _value.idAiProvider
          // ignore: cast_nullable_to_non_nullable
          : idAiProvider as String,
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
    );
  }
}

extension $AiModelCreateCopyWith on AiModelCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAiModelCreate.copyWith(...)` or `instanceOfAiModelCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AiModelCreateCWProxy get copyWith => _$AiModelCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiModelCreate _$AiModelCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AiModelCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'slug',
            'id_ai_provider',
            'display_name',
            'context_window',
            'input_token_limit',
            'output_token_limit',
            'supports_vision',
            'is_active',
          ],
        );
        final val = AiModelCreate(
          slug: $checkedConvert('slug', (v) => v as String),
          idAiProvider: $checkedConvert('id_ai_provider', (v) => v as String),
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

Map<String, dynamic> _$AiModelCreateToJson(AiModelCreate instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'id_ai_provider': instance.idAiProvider,
      'display_name': instance.displayName,
      'context_window': instance.contextWindow,
      'input_token_limit': instance.inputTokenLimit,
      'output_token_limit': instance.outputTokenLimit,
      'supports_vision': instance.supportsVision,
      'is_active': instance.isActive,
    };
