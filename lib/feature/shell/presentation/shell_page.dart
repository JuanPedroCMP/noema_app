import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/route_paths.dart';

class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Noema App")),

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Home"),
              onTap: () => context.go(RoutePaths.home),
            ),
            ListTile(
              title: Text("Notas"),
              onTap: () => context.go(RoutePaths.notes),
            ),
          ],
        ),
      ),

      body: child,
    );
  }
}

// TODO usar essa página ao invéz da base page, vai ficar maisorganizado
