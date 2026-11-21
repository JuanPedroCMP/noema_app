import 'package:flutter/material.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class AppResponsiveContent extends StatelessWidget {
  const AppResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = AppLayoutTokens.pageContentWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final compact = width < AppLayoutTokens.compactBreakpoint;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: compact
                        ? AppLayoutTokens.pageHorizontalPaddingCompact
                        : AppLayoutTokens.pageHorizontalPaddingRegular,
                    vertical: compact
                        ? AppLayoutTokens.pageVerticalPaddingCompact
                        : AppLayoutTokens.pageVerticalPaddingRegular,
                  ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth < AppLayoutTokens.compactHeaderBreakpoint;
        final textTheme = Theme.of(context).textTheme;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                style: compact
                    ? textTheme.headlineSmall
                    : textTheme.headlineMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: context.spacing.xs),
              Text(
                subtitle!,
                style: textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );
        if (actions.isEmpty) return heading;
        final actionWrap = Wrap(
          spacing: context.spacing.sm,
          runSpacing: context.spacing.sm,
          alignment: compact ? WrapAlignment.start : WrapAlignment.end,
          children: actions,
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading,
              SizedBox(height: context.spacing.md),
              actionWrap,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: heading),
            SizedBox(width: context.spacing.lg),
            Flexible(child: actionWrap),
          ],
        );
      },
    );
  }
}
