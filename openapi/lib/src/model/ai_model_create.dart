//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_model_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AiModelCreate {
  /// Returns a new [AiModelCreate] instance.
  AiModelCreate({

    required  this.slug,

    required  this.idAiProvider,

    required  this.displayName,

    required  this.contextWindow,

    required  this.inputTokenLimit,

    required  this.outputTokenLimit,

    required  this.supportsVision,

    required  this.isActive,
  });

  @JsonKey(
    
    name: r'slug',
    required: true,
    includeIfNull: false,
  )


  final String slug;



  @JsonKey(
    
    name: r'id_ai_provider',
    required: true,
    includeIfNull: false,
  )


  final String idAiProvider;



  @JsonKey(
    
    name: r'display_name',
    required: true,
    includeIfNull: false,
  )


  final String displayName;



  @JsonKey(
    
    name: r'context_window',
    required: true,
    includeIfNull: false,
  )


  final int contextWindow;



  @JsonKey(
    
    name: r'input_token_limit',
    required: true,
    includeIfNull: false,
  )


  final int inputTokenLimit;



  @JsonKey(
    
    name: r'output_token_limit',
    required: true,
    includeIfNull: false,
  )


  final int outputTokenLimit;



  @JsonKey(
    
    name: r'supports_vision',
    required: true,
    includeIfNull: true,
  )


  final bool? supportsVision;



  @JsonKey(
    
    name: r'is_active',
    required: true,
    includeIfNull: true,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AiModelCreate &&
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
        slug.hashCode +
        idAiProvider.hashCode +
        displayName.hashCode +
        contextWindow.hashCode +
        inputTokenLimit.hashCode +
        outputTokenLimit.hashCode +
        (supportsVision == null ? 0 : supportsVision.hashCode) +
        (isActive == null ? 0 : isActive.hashCode);

  factory AiModelCreate.fromJson(Map<String, dynamic> json) => _$AiModelCreateFromJson(json);

  Map<String, dynamic> toJson() => _$AiModelCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

