import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/teste_page.dart';

class FloatingCard extends ConsumerWidget {
  const FloatingCard({super.key, this.width, this.height, this.padding, required this.child,});

  final double? width;
  final double? height;
  final double? padding;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      height: height,

      child: Card(
        child: Padding(
          padding: EdgeInsets.all(padding ?? 16),
          child:  Align(
                alignment: Alignment.center,
                child: child,
          ),
        ),
      ),
    );
  }
}
