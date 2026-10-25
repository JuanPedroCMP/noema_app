//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generic_log_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GenericLogCreate {
  /// Returns a new [GenericLogCreate] instance.
  GenericLogCreate({

    required  this.idUser,

    required  this.type,

    required  this.details,
  });

  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: true,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'details',
    required: true,
    includeIfNull: false,
  )


  final String details;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GenericLogCreate &&
      other.idUser == idUser &&
      other.type == type &&
      other.details == details;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        type.hashCode +
        details.hashCode;

  factory GenericLogCreate.fromJson(Map<String, dynamic> json) => _$GenericLogCreateFromJson(json);

  Map<String, dynamic> toJson() => _$GenericLogCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

