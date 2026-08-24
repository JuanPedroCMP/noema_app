import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class GraphUtilsLayer extends ConsumerWidget {
  const GraphUtilsLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: context.spacing.lg,
      children: [
        OutlinedButton(
          onPressed: () {},
          child: Icon(Icons.add, size: context.iconSize.md),
        ),

        OutlinedButton(
          onPressed: () {},
          child: Icon(Icons.edit, size: context.iconSize.md),
        ),

        OutlinedButton(
          onPressed: () {},
          child: Icon(Icons.auto_awesome_mosaic, size: context.iconSize.md),
        ),
      ],
    );
  }
}
