

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noema App"),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Home"),
              onTap: () => context.go("/"),
            ),
            ListTile(
              title: Text("Notas"),
              onTap: () => context.go("/notes")
            ),
            ListTile(
              title: Text("Sign Up"),
              onTap: () => context.go("/sign_up"),
            )
          ],
        ),
      ),

      body: child,
    );
  }
}