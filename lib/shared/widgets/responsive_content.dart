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
    final width = MediaQuery.sizeOf(context).width;
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
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null) ...[
              SizedBox(height: context.spacing.xs + 2),
              Text(subtitle!),
            ],
          ],
        );
        if (actions.isEmpty) return heading;
        return Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment:
              compact ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: compact ? 0 : 1,
              child: heading,
            ),
            if (compact) SizedBox(height: context.spacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: compact ? WrapAlignment.start : WrapAlignment.end,
              children: actions,
            ),
          ],
        );
      },
    );
  }
}
