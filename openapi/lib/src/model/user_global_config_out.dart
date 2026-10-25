//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_global_config_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserGlobalConfigOut {
  /// Returns a new [UserGlobalConfigOut] instance.
  UserGlobalConfigOut({

    required  this.id,

    required  this.idUser,

    required  this.idLanguage,

    required  this.idUserColorTheme,

    required  this.idUserTypographyTheme,

    required  this.preferences,

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


  final Map<String, Object> preferences;



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
    bool operator ==(Object other) => identical(this, other) || other is UserGlobalConfigOut &&
      other.id == id &&
      other.idUser == idUser &&
      other.idLanguage == idLanguage &&
      other.idUserColorTheme == idUserColorTheme &&
      other.idUserTypographyTheme == idUserTypographyTheme &&
      other.preferences == preferences &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idUser.hashCode +
        idLanguage.hashCode +
        idUserColorTheme.hashCode +
        idUserTypographyTheme.hashCode +
        preferences.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory UserGlobalConfigOut.fromJson(Map<String, dynamic> json) => _$UserGlobalConfigOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserGlobalConfigOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

