//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_usage_log_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AiUsageLogCreate {
  /// Returns a new [AiUsageLogCreate] instance.
  AiUsageLogCreate({

    required  this.idUser,

    required  this.idAgentModel,

    required  this.usageDetails,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is AiUsageLogCreate &&
      other.idUser == idUser &&
      other.idAgentModel == idAgentModel &&
      other.usageDetails == usageDetails;

    @override
    int get hashCode =>
        idUser.hashCode +
        idAgentModel.hashCode +
        usageDetails.hashCode;

  factory AiUsageLogCreate.fromJson(Map<String, dynamic> json) => _$AiUsageLogCreateFromJson(json);

  Map<String, dynamic> toJson() => _$AiUsageLogCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

