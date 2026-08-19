import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/widgets/app_side_bar/provider/app_side_bar_provider.dart';

class AppSideBar extends ConsumerWidget {
  const AppSideBar({
    super.key,
    required this.navigationWidgets,
    required this.bottonWidgets,
    required this.pageWidgets,
  });

  final List<Widget> navigationWidgets;
  final List<Widget> pageWidgets;
  final List<Widget> bottonWidgets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideBarProdiver = ref.watch(appSidebarProvider.notifier);
    final sideBar = ref.watch(appSidebarProvider);

    return TapRegion(
      onTapUpOutside: (event) {
        if (!sideBar.isFixed && sideBar.isOpen) {
          sideBarProdiver.alternateIsOpen(sideBar.isOpen);
        }
      },
      child: Row(
        spacing: context.spacing.sm,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.spacing.md,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  sideBarProdiver.alternateIsOpen(sideBar.isOpen);
                },
                child: Icon(Icons.view_sidebar_rounded),
              ),
              SizedBox(height: context.spacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: context.spacing.md,
                    children: [...navigationWidgets],
                  ),
                ),
              ),
              Spacer(),
              ...bottonWidgets,

              SizedBox(height: context.spacing.lg),
            ],
          ),

          SizedBox(child: sideBar.isOpen ? VerticalDivider(width: 1) : null),

          AnimatedSwitcher(
            duration: context.durations.instant,
            child: sideBar.isOpen
                ? SingleChildScrollView(
                  key: const ValueKey('sidebar-page'),
                  child: Column(
                    spacing: context.spacing.md,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          sideBarProdiver.alternateIsFixed(
                            sideBar.isFixed,
                          );
                        },
                        child: Icon(
                          sideBar.isFixed
                              ? Icons.lock_rounded
                              : Icons.lock_open_rounded,
                        ),
                      ),

                      ...pageWidgets,
                    ],
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
