import 'package:flutter/material.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.trailing,
  });

  final String title;
  final String? description;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppLayoutTokens.sectionPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                if (description != null)
                  IconButton(
                    tooltip: 'Mais informações',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(title),
                        content: Text(description!),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const RuntimeLocalizedText('Entendi'),
                          ),
                        ],
                      ),
                    ),
                    icon: const Icon(Icons.info_outline, size: 20),
                  ),
                ?trailing,
              ],
            ),
            SizedBox(height: spacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
