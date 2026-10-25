//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'provider_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProviderCreate {
  /// Returns a new [ProviderCreate] instance.
  ProviderCreate({

    required  this.slug,

    required  this.displayName,

    required  this.baseUrl,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProviderCreate &&
      other.slug == slug &&
      other.displayName == displayName &&
      other.baseUrl == baseUrl;

    @override
    int get hashCode =>
        slug.hashCode +
        displayName.hashCode +
        baseUrl.hashCode;

  factory ProviderCreate.fromJson(Map<String, dynamic> json) => _$ProviderCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

