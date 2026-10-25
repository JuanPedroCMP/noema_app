//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'provider_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProviderUpdate {
  /// Returns a new [ProviderUpdate] instance.
  ProviderUpdate({

     this.slug,

     this.displayName,

     this.baseUrl,

     this.isActive,
  });

  @JsonKey(
    
    name: r'slug',
    required: false,
    includeIfNull: false,
  )


  final String? slug;



  @JsonKey(
    
    name: r'display_name',
    required: false,
    includeIfNull: false,
  )


  final String? displayName;



  @JsonKey(
    
    name: r'base_url',
    required: false,
    includeIfNull: false,
  )


  final String? baseUrl;



  @JsonKey(
    
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProviderUpdate &&
      other.slug == slug &&
      other.displayName == displayName &&
      other.baseUrl == baseUrl &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        (slug == null ? 0 : slug.hashCode) +
        (displayName == null ? 0 : displayName.hashCode) +
        (baseUrl == null ? 0 : baseUrl.hashCode) +
        (isActive == null ? 0 : isActive.hashCode);

  factory ProviderUpdate.fromJson(Map<String, dynamic> json) => _$ProviderUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

