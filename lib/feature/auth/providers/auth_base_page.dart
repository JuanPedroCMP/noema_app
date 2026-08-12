import 'package:flutter/material.dart';

class AuthBasePage extends StatelessWidget {
  final Widget child;

  const AuthBasePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: child,
    );
  }
}