import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/providers/login_form_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final formNotifier = ref.watch(loginFormProvider.notifier);

    final db = ref.read(appDatabaseProvider);

    return Center(
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: context.spacing.md,
          children: [
            TextField(
              onChanged: formNotifier.userChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Usuário",
              ),
            ),

            TextField(
              onChanged: formNotifier.passwordChanged,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Senha",
              ),
            ),

            OutlinedButton(
              onPressed: () async {
                final loginService = ref.read(loginServiceProvider);

                await loginService.login(
                  user: form.user,
                  password: form.password,
                );

                if (context.mounted) {
                  ref.invalidate(authStateProvider);
                  context.go("/");
                }
              },
              child: Text("Entrar"),
            ),
            OutlinedButton(
              onPressed: () async {
                db.deleteDatabase();
              },
              child: Text("Apagar DB"),
            ),
            TextButton(
              onPressed: () => context.go("/sign_up"),
              child: Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}
