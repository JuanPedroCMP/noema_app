//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generic_log_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GenericLogOut {
  /// Returns a new [GenericLogOut] instance.
  GenericLogOut({

    required  this.id,

    required  this.type,

    required  this.idUser,

    required  this.details,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: true,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'details',
    required: true,
    includeIfNull: true,
  )


  final Object? details;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GenericLogOut &&
      other.id == id &&
      other.type == type &&
      other.idUser == idUser &&
      other.details == details &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        (idUser == null ? 0 : idUser.hashCode) +
        (details == null ? 0 : details.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode);

  factory GenericLogOut.fromJson(Map<String, dynamic> json) => _$GenericLogOutFromJson(json);

  Map<String, dynamic> toJson() => _$GenericLogOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

