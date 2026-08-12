import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class ChromeNavigationTile extends StatelessWidget {
  const ChromeNavigationTile({
    super.key,
    this.icon,
    required this.onTap,
    required this.title,
  });

  final Function() onTap;
  final Widget title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [?icon, title],
          ),
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: context.colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
