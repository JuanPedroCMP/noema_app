//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_language_preference_order_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResponseLanguagePreferenceOrderUpdate {
  /// Returns a new [ResponseLanguagePreferenceOrderUpdate] instance.
  ResponseLanguagePreferenceOrderUpdate({

     this.id,

     this.preferenceOrder,

     this.idUser,

     this.idLanguage,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'preference_order',
    required: false,
    includeIfNull: false,
  )


  final int? preferenceOrder;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ResponseLanguagePreferenceOrderUpdate &&
      other.id == id &&
      other.preferenceOrder == preferenceOrder &&
      other.idUser == idUser &&
      other.idLanguage == idLanguage;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (preferenceOrder == null ? 0 : preferenceOrder.hashCode) +
        (idUser == null ? 0 : idUser.hashCode) +
        (idLanguage == null ? 0 : idLanguage.hashCode);

  factory ResponseLanguagePreferenceOrderUpdate.fromJson(Map<String, dynamic> json) => _$ResponseLanguagePreferenceOrderUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseLanguagePreferenceOrderUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

