//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_global_config_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserGlobalConfigUpdate {
  /// Returns a new [UserGlobalConfigUpdate] instance.
  UserGlobalConfigUpdate({

     this.idUser,

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
    bool operator ==(Object other) => identical(this, other) || other is UserGlobalConfigUpdate &&
      other.idUser == idUser &&
      other.idLanguage == idLanguage &&
      other.idUserColorTheme == idUserColorTheme &&
      other.idUserTypographyTheme == idUserTypographyTheme &&
      other.preferences == preferences;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        (idLanguage == null ? 0 : idLanguage.hashCode) +
        (idUserColorTheme == null ? 0 : idUserColorTheme.hashCode) +
        (idUserTypographyTheme == null ? 0 : idUserTypographyTheme.hashCode) +
        (preferences == null ? 0 : preferences.hashCode);

  factory UserGlobalConfigUpdate.fromJson(Map<String, dynamic> json) => _$UserGlobalConfigUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserGlobalConfigUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

