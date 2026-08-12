import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/router/widgets/app_side_bar/provider/app_side_bar_state.dart';

class AppSideBarNotifier extends Notifier<AppSideBarState>{
  AppSideBarState build() {
    return const AppSideBarState();
  }

  void alternateIsOpen(bool value){
    state = state.copyWith(isOpen: !value);
  }

  void alternateIsFixed(bool value) {
    state = state.copyWith(isFixed: !value);
  }
}

final appSidebarProvider = NotifierProvider<AppSideBarNotifier, AppSideBarState>(AppSideBarNotifier.new);