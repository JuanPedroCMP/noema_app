import 'package:freezed_annotation/freezed_annotation.dart';

part 'graph_form_state.freezed.dart';

@freezed
sealed class GraphFormState with _$GraphFormState{ 
   const factory GraphFormState({ 
    @Default("") String userId,
    @Default("") String title,
    @Default("") String description,
    @Default(false) bool isArchived,
    @Default(false) bool synced,
}) = _GraphFormState;
}