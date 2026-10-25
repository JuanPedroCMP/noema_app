//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_typography_theme_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserTypographyThemeOut {
  /// Returns a new [UserTypographyThemeOut] instance.
  UserTypographyThemeOut({

    required  this.id,

    required  this.idUser,

    required  this.name,

    required  this.displayFont,

    required  this.bodyFont,

    required  this.monoFont,

    required  this.overrideJson,

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
    includeIfNull: false,
  )


  final Map<String, Object> overrideJson;



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
    bool operator ==(Object other) => identical(this, other) || other is UserTypographyThemeOut &&
      other.id == id &&
      other.idUser == idUser &&
      other.name == name &&
      other.displayFont == displayFont &&
      other.bodyFont == bodyFont &&
      other.monoFont == monoFont &&
      other.overrideJson == overrideJson &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idUser.hashCode +
        name.hashCode +
        displayFont.hashCode +
        bodyFont.hashCode +
        monoFont.hashCode +
        overrideJson.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory UserTypographyThemeOut.fromJson(Map<String, dynamic> json) => _$UserTypographyThemeOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserTypographyThemeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

