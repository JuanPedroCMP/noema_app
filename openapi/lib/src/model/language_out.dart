//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LanguageOut {
  /// Returns a new [LanguageOut] instance.
  LanguageOut({

    required  this.id,

    required  this.name,

    required  this.percentageTranslated,

    required  this.verifiedTranslation,

    required  this.automaticTranslation,

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
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'percentage_translated',
    required: true,
    includeIfNull: false,
  )


  final int percentageTranslated;



  @JsonKey(
    
    name: r'verified_translation',
    required: true,
    includeIfNull: false,
  )


  final bool verifiedTranslation;



  @JsonKey(
    
    name: r'automatic_translation',
    required: true,
    includeIfNull: false,
  )


  final bool automaticTranslation;



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
    bool operator ==(Object other) => identical(this, other) || other is LanguageOut &&
      other.id == id &&
      other.name == name &&
      other.percentageTranslated == percentageTranslated &&
      other.verifiedTranslation == verifiedTranslation &&
      other.automaticTranslation == automaticTranslation &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        percentageTranslated.hashCode +
        verifiedTranslation.hashCode +
        automaticTranslation.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory LanguageOut.fromJson(Map<String, dynamic> json) => _$LanguageOutFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

