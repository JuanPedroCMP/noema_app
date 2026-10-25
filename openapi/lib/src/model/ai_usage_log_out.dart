//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_usage_log_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AiUsageLogOut {
  /// Returns a new [AiUsageLogOut] instance.
  AiUsageLogOut({

    required  this.id,

    required  this.idUser,

    required  this.idAgentModel,

    required  this.usageDetails,

    required  this.createdAt,
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
    
    name: r'id_agent_model',
    required: true,
    includeIfNull: false,
  )


  final String idAgentModel;



  @JsonKey(
    
    name: r'usage_details',
    required: true,
    includeIfNull: false,
  )


  final Map<String, Object> usageDetails;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AiUsageLogOut &&
      other.id == id &&
      other.idUser == idUser &&
      other.idAgentModel == idAgentModel &&
      other.usageDetails == usageDetails &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        idUser.hashCode +
        idAgentModel.hashCode +
        usageDetails.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode);

  factory AiUsageLogOut.fromJson(Map<String, dynamic> json) => _$AiUsageLogOutFromJson(json);

  Map<String, dynamic> toJson() => _$AiUsageLogOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

