import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
