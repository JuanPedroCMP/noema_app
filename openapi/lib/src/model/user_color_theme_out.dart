//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_color_theme_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserColorThemeOut {
  /// Returns a new [UserColorThemeOut] instance.
  UserColorThemeOut({

    required  this.id,

    required  this.idUser,

    required  this.name,

    required  this.seedColor,

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
    bool operator ==(Object other) => identical(this, other) || other is UserColorThemeOut &&
      other.id == id &&
      other.idUser == idUser &&
      other.name == name &&
      other.seedColor == seedColor &&
      other.overrideJson == overrideJson &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idUser.hashCode +
        name.hashCode +
        seedColor.hashCode +
        overrideJson.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory UserColorThemeOut.fromJson(Map<String, dynamic> json) => _$UserColorThemeOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserColorThemeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

