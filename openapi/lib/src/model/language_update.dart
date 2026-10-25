//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LanguageUpdate {
  /// Returns a new [LanguageUpdate] instance.
  LanguageUpdate({

     this.name,

     this.percentageTranslated,

     this.verifiedTranslation,

     this.automaticTranslation,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'percentage_translated',
    required: false,
    includeIfNull: false,
  )


  final int? percentageTranslated;



  @JsonKey(
    
    name: r'verified_translation',
    required: false,
    includeIfNull: false,
  )


  final bool? verifiedTranslation;



  @JsonKey(
    
    name: r'automatic_translation',
    required: false,
    includeIfNull: false,
  )


  final bool? automaticTranslation;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LanguageUpdate &&
      other.name == name &&
      other.percentageTranslated == percentageTranslated &&
      other.verifiedTranslation == verifiedTranslation &&
      other.automaticTranslation == automaticTranslation;

    @override
    int get hashCode =>
        (name == null ? 0 : name.hashCode) +
        (percentageTranslated == null ? 0 : percentageTranslated.hashCode) +
        (verifiedTranslation == null ? 0 : verifiedTranslation.hashCode) +
        (automaticTranslation == null ? 0 : automaticTranslation.hashCode);

  factory LanguageUpdate.fromJson(Map<String, dynamic> json) => _$LanguageUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

