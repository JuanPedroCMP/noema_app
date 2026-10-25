//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_typography_theme_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserTypographyThemeCreate {
  /// Returns a new [UserTypographyThemeCreate] instance.
  UserTypographyThemeCreate({

    required  this.idUser,

    required  this.name,

    required  this.displayFont,

    required  this.bodyFont,

    required  this.monoFont,

    required  this.overrideJson,
  });

  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: false,
  )


  final String idUser;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'display_font',
    required: true,
    includeIfNull: false,
  )


  final String displayFont;



  @JsonKey(
    
    name: r'body_font',
    required: true,
    includeIfNull: false,
  )


  final String bodyFont;



  @JsonKey(
    
    name: r'mono_font',
    required: true,
    includeIfNull: false,
  )


  final String monoFont;



  @JsonKey(
    
    name: r'override_json',
    required: true,
    includeIfNull: true,
  )


  final String? overrideJson;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserTypographyThemeCreate &&
      other.idUser == idUser &&
      other.name == name &&
      other.displayFont == displayFont &&
      other.bodyFont == bodyFont &&
      other.monoFont == monoFont &&
      other.overrideJson == overrideJson;

    @override
    int get hashCode =>
        idUser.hashCode +
        name.hashCode +
        displayFont.hashCode +
        bodyFont.hashCode +
        monoFont.hashCode +
        (overrideJson == null ? 0 : overrideJson.hashCode);

  factory UserTypographyThemeCreate.fromJson(Map<String, dynamic> json) => _$UserTypographyThemeCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserTypographyThemeCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

