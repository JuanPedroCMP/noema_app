import 'package:flutter/material.dart';

class FloatingCard extends StatelessWidget {
  const FloatingCard({
    super.key,
    this.width,
    this.height,
    this.padding,
    required this.child,
  });

  final double? width;
  final double? height;
  final double? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,

      child: Card(
        child: Padding(
          padding: EdgeInsets.all(padding ?? 16),
          child: Align(alignment: Alignment.center, child: child),
        ),
      ),
    );
  }
}
