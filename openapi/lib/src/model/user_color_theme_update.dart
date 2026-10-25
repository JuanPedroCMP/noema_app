//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_color_theme_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserColorThemeUpdate {
  /// Returns a new [UserColorThemeUpdate] instance.
  UserColorThemeUpdate({

     this.idUser,

     this.name,

     this.seedColor,

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
    
    name: r'seed_color',
    required: false,
    includeIfNull: false,
  )


  final int? seedColor;



  @JsonKey(
    
    name: r'override_json',
    required: false,
    includeIfNull: false,
  )


  final String? overrideJson;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserColorThemeUpdate &&
      other.idUser == idUser &&
      other.name == name &&
      other.seedColor == seedColor &&
      other.overrideJson == overrideJson;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        (name == null ? 0 : name.hashCode) +
        (seedColor == null ? 0 : seedColor.hashCode) +
        (overrideJson == null ? 0 : overrideJson.hashCode);

  factory UserColorThemeUpdate.fromJson(Map<String, dynamic> json) => _$UserColorThemeUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserColorThemeUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

