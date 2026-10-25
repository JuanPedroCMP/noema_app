//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_color_theme_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserColorThemeCreate {
  /// Returns a new [UserColorThemeCreate] instance.
  UserColorThemeCreate({

    required  this.idUser,

    required  this.name,

    required  this.seedColor,

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
    
    name: r'seed_color',
    required: true,
    includeIfNull: false,
  )


  final int seedColor;



  @JsonKey(
    
    name: r'override_json',
    required: true,
    includeIfNull: false,
  )


  final String overrideJson;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserColorThemeCreate &&
      other.idUser == idUser &&
      other.name == name &&
      other.seedColor == seedColor &&
      other.overrideJson == overrideJson;

    @override
    int get hashCode =>
        idUser.hashCode +
        name.hashCode +
        seedColor.hashCode +
        overrideJson.hashCode;

  factory UserColorThemeCreate.fromJson(Map<String, dynamic> json) => _$UserColorThemeCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserColorThemeCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

