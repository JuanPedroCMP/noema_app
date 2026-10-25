//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_model_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AiModelOut {
  /// Returns a new [AiModelOut] instance.
  AiModelOut({

    required  this.id,

    required  this.idAiProvider,

    required  this.slug,

    required  this.displayName,

    required  this.contextWindow,

    required  this.inputTokenLimit,

    required  this.outputTokenLimit,

    required  this.supportsVision,

    required  this.isActive,

    required  this.createdAt,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'id_ai_provider',
    required: true,
    includeIfNull: false,
  )


  final String idAiProvider;



  @JsonKey(
    
    name: r'slug',
    required: true,
    includeIfNull: false,
  )


  final String slug;



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



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;



  @JsonKey(
    
    name: r'updated_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AiModelOut &&
      other.id == id &&
      other.idAiProvider == idAiProvider &&
      other.slug == slug &&
      other.displayName == displayName &&
      other.contextWindow == contextWindow &&
      other.inputTokenLimit == inputTokenLimit &&
      other.outputTokenLimit == outputTokenLimit &&
      other.supportsVision == supportsVision &&
      other.isActive == isActive &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idAiProvider.hashCode +
        slug.hashCode +
        displayName.hashCode +
        contextWindow.hashCode +
        inputTokenLimit.hashCode +
        outputTokenLimit.hashCode +
        (supportsVision == null ? 0 : supportsVision.hashCode) +
        (isActive == null ? 0 : isActive.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory AiModelOut.fromJson(Map<String, dynamic> json) => _$AiModelOutFromJson(json);

  Map<String, dynamic> toJson() => _$AiModelOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

