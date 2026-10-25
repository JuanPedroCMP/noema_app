//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'provider_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProviderOut {
  /// Returns a new [ProviderOut] instance.
  ProviderOut({

    required  this.id,

    required  this.slug,

    required  this.displayName,

    required  this.baseUrl,

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
    
    name: r'base_url',
    required: true,
    includeIfNull: false,
  )


  final String baseUrl;



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
    bool operator ==(Object other) => identical(this, other) || other is ProviderOut &&
      other.id == id &&
      other.slug == slug &&
      other.displayName == displayName &&
      other.baseUrl == baseUrl &&
      other.isActive == isActive &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        displayName.hashCode +
        baseUrl.hashCode +
        (isActive == null ? 0 : isActive.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory ProviderOut.fromJson(Map<String, dynamic> json) => _$ProviderOutFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

