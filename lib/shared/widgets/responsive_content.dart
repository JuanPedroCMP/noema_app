import 'package:flutter/material.dart';

class AppResponsiveContent extends StatelessWidget {
  const AppResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 1000,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: compact ? 16 : 32,
                vertical: compact ? 20 : 32,
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
        final compact = constraints.maxWidth < 560;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
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
            if (compact) const SizedBox(height: 16),
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
