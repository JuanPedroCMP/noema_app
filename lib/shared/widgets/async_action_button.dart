import 'package:flutter/material.dart';

class AsyncActionButton extends StatelessWidget {
  const AsyncActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.loading = false,
    this.outlined = false,
  });

  final Future<void> Function()? onPressed;
  final String label;
  final IconData? icon;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (icon != null)
          Icon(icon),
        if (loading || icon != null) const SizedBox(width: 8),
        Text(loading ? 'Aguarde...' : label),
      ],
    );
    return outlined
        ? OutlinedButton(onPressed: loading ? null : onPressed, child: child)
        : FilledButton(onPressed: loading ? null : onPressed, child: child);
  }
}
