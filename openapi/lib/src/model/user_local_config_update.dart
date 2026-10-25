//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_local_config_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserLocalConfigUpdate {
  /// Returns a new [UserLocalConfigUpdate] instance.
  UserLocalConfigUpdate({

     this.idUser,

     this.idDevice,

     this.idLanguage,

     this.idUserColorTheme,

     this.idUserTypographyTheme,

     this.preferences,
  });

  @JsonKey(
    
    name: r'id_user',
    required: false,
    includeIfNull: false,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'id_device',
    required: false,
    includeIfNull: false,
  )


  final String? idDevice;



  @JsonKey(
    
    name: r'id_language',
    required: false,
    includeIfNull: false,
  )


  final String? idLanguage;



  @JsonKey(
    
    name: r'id_user_color_theme',
    required: false,
    includeIfNull: false,
  )


  final String? idUserColorTheme;



  @JsonKey(
    
    name: r'id_user_typography_theme',
    required: false,
    includeIfNull: false,
  )


  final String? idUserTypographyTheme;



  @JsonKey(
    
    name: r'preferences',
    required: false,
    includeIfNull: false,
  )


  final String? preferences;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserLocalConfigUpdate &&
      other.idUser == idUser &&
      other.idDevice == idDevice &&
      other.idLanguage == idLanguage &&
      other.idUserColorTheme == idUserColorTheme &&
      other.idUserTypographyTheme == idUserTypographyTheme &&
      other.preferences == preferences;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        (idDevice == null ? 0 : idDevice.hashCode) +
        (idLanguage == null ? 0 : idLanguage.hashCode) +
        (idUserColorTheme == null ? 0 : idUserColorTheme.hashCode) +
        (idUserTypographyTheme == null ? 0 : idUserTypographyTheme.hashCode) +
        (preferences == null ? 0 : preferences.hashCode);

  factory UserLocalConfigUpdate.fromJson(Map<String, dynamic> json) => _$UserLocalConfigUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocalConfigUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

