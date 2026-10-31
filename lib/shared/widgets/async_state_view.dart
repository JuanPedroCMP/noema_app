import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.label});
  final String? label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (label != null) ...[
            SizedBox(height: spacing.md - spacing.xs),
            Text(label!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            SizedBox(height: spacing.md - spacing.xs),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: spacing.md),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: spacing.md),
            Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            SizedBox(height: spacing.sm),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[
              SizedBox(height: spacing.lg - spacing.xs),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
