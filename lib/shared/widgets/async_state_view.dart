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
            SizedBox(height: spacing.md),
            Text(
              label!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Icon(
                    Icons.error_outline,
                    size: 32,
                    color: context.colors.onErrorContainer,
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: spacing.md),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Icon(
                    icon,
                    size: 32,
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              if (action != null) ...[SizedBox(height: spacing.md), action!],
            ],
          ),
        ),
      ),
    );
  }
}
