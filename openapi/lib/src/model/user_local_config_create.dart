//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_local_config_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserLocalConfigCreate {
  /// Returns a new [UserLocalConfigCreate] instance.
  UserLocalConfigCreate({

    required  this.idUser,

     this.idDevice,

    required  this.idLanguage,

    required  this.idUserColorTheme,

    required  this.idUserTypographyTheme,

    required  this.preferences,
  });

  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: false,
  )


  final String idUser;



  @JsonKey(
    
    name: r'id_device',
    required: false,
    includeIfNull: false,
  )


  final String? idDevice;



  @JsonKey(
    
    name: r'id_language',
    required: true,
    includeIfNull: false,
  )


  final String idLanguage;



  @JsonKey(
    
    name: r'id_user_color_theme',
    required: true,
    includeIfNull: false,
  )


  final String idUserColorTheme;



  @JsonKey(
    
    name: r'id_user_typography_theme',
    required: true,
    includeIfNull: false,
  )


  final String idUserTypographyTheme;



  @JsonKey(
    
    name: r'preferences',
    required: true,
    includeIfNull: false,
  )


  final String preferences;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserLocalConfigCreate &&
      other.idUser == idUser &&
      other.idDevice == idDevice &&
      other.idLanguage == idLanguage &&
      other.idUserColorTheme == idUserColorTheme &&
      other.idUserTypographyTheme == idUserTypographyTheme &&
      other.preferences == preferences;

    @override
    int get hashCode =>
        idUser.hashCode +
        (idDevice == null ? 0 : idDevice.hashCode) +
        idLanguage.hashCode +
        idUserColorTheme.hashCode +
        idUserTypographyTheme.hashCode +
        preferences.hashCode;

  factory UserLocalConfigCreate.fromJson(Map<String, dynamic> json) => _$UserLocalConfigCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocalConfigCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

