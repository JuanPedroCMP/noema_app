import 'package:flutter/material.dart';
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
    final selected = navigationShell.currentIndex == index;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => navigationShell.goBranch(index),
          child: AnimatedContainer(
            duration: context.durations.fast,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? context.colors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: context.durations.fast,
                  width: 4,
                  height: selected ? 32 : 0,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: context.colors.primary,
                  ),
                ),
                icon,
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w600 : null,
                      color: selected ? context.colors.primary : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
