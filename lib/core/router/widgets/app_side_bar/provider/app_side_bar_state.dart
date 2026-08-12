import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_side_bar_state.freezed.dart';

@freezed
sealed class AppSideBarState with _$AppSideBarState {
  const factory AppSideBarState({
    @Default(false) bool isOpen,
    @Default(false) bool isFixed,
  }) = _AppSideBarState;
}