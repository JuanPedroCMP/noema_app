//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_model_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AiModelUpdate {
  /// Returns a new [AiModelUpdate] instance.
  AiModelUpdate({

     this.slug,

     this.idAiProvider,

     this.displayName,

     this.contextWindow,

     this.inputTokenLimit,

     this.outputTokenLimit,

     this.supportsVision,

     this.isActive,
  });

  @JsonKey(
    
    name: r'slug',
    required: false,
    includeIfNull: false,
  )


  final String? slug;



  @JsonKey(
    
    name: r'id_ai_provider',
    required: false,
    includeIfNull: false,
  )


  final String? idAiProvider;



  @JsonKey(
    
    name: r'display_name',
    required: false,
    includeIfNull: false,
  )


  final String? displayName;



  @JsonKey(
    
    name: r'context_window',
    required: false,
    includeIfNull: false,
  )


  final int? contextWindow;



  @JsonKey(
    
    name: r'input_token_limit',
    required: false,
    includeIfNull: false,
  )


  final int? inputTokenLimit;



  @JsonKey(
    
    name: r'output_token_limit',
    required: false,
    includeIfNull: false,
  )


  final int? outputTokenLimit;



  @JsonKey(
    
    name: r'supports_vision',
    required: false,
    includeIfNull: false,
  )


  final bool? supportsVision;



  @JsonKey(
    
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AiModelUpdate &&
      other.slug == slug &&
      other.idAiProvider == idAiProvider &&
      other.displayName == displayName &&
      other.contextWindow == contextWindow &&
      other.inputTokenLimit == inputTokenLimit &&
      other.outputTokenLimit == outputTokenLimit &&
      other.supportsVision == supportsVision &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        (slug == null ? 0 : slug.hashCode) +
        (idAiProvider == null ? 0 : idAiProvider.hashCode) +
        (displayName == null ? 0 : displayName.hashCode) +
        (contextWindow == null ? 0 : contextWindow.hashCode) +
        (inputTokenLimit == null ? 0 : inputTokenLimit.hashCode) +
        (outputTokenLimit == null ? 0 : outputTokenLimit.hashCode) +
        (supportsVision == null ? 0 : supportsVision.hashCode) +
        (isActive == null ? 0 : isActive.hashCode);

  factory AiModelUpdate.fromJson(Map<String, dynamic> json) => _$AiModelUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$AiModelUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

