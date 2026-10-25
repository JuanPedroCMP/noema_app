//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_typography_theme_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserTypographyThemeUpdate {
  /// Returns a new [UserTypographyThemeUpdate] instance.
  UserTypographyThemeUpdate({

     this.idUser,

     this.name,

     this.displayFont,

     this.bodyFont,

     this.monoFont,

     this.overrideJson,
  });

  @JsonKey(
    
    name: r'id_user',
    required: false,
    includeIfNull: false,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'display_font',
    required: false,
    includeIfNull: false,
  )


  final String? displayFont;



  @JsonKey(
    
    name: r'body_font',
    required: false,
    includeIfNull: false,
  )


  final String? bodyFont;



  @JsonKey(
    
    name: r'mono_font',
    required: false,
    includeIfNull: false,
  )


  final String? monoFont;



  @JsonKey(
    
    name: r'override_json',
    required: false,
    includeIfNull: false,
  )


  final String? overrideJson;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserTypographyThemeUpdate &&
      other.idUser == idUser &&
      other.name == name &&
      other.displayFont == displayFont &&
      other.bodyFont == bodyFont &&
      other.monoFont == monoFont &&
      other.overrideJson == overrideJson;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        (name == null ? 0 : name.hashCode) +
        (displayFont == null ? 0 : displayFont.hashCode) +
        (bodyFont == null ? 0 : bodyFont.hashCode) +
        (monoFont == null ? 0 : monoFont.hashCode) +
        (overrideJson == null ? 0 : overrideJson.hashCode);

  factory UserTypographyThemeUpdate.fromJson(Map<String, dynamic> json) => _$UserTypographyThemeUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserTypographyThemeUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

