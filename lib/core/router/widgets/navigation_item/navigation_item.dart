import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    super.key,
    required this.index,
    required this.label,
    required this.navigationShell,
    required this.icon,
  });

  final int index;
  final String label;
  final StatefulNavigationShell navigationShell;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationShell.goBranch(index);
      },
      child: Row(
        children: [
          navigationShell.currentIndex == index
              ? Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: context.colors.error,
                ),
                
              )
              : SizedBox(width: 4),
              SizedBox(width: 4),
          Column(mainAxisSize: MainAxisSize.min, children: [icon, Text(label)]),
        ],
      ),
    );
  }
}
