import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/enums.dart';

class Section extends StatelessWidget {
  const Section({super.key, required this.section, required this.sectionTitle});

  final Widget section;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle, style: context.textTheme.titleLarge),
        Card.outlined(
          child: Padding(
            padding: EdgeInsetsGeometry.all(context.spacing.lg),
            child: section,
          ),
        ),
      ],
    );
  }
}
