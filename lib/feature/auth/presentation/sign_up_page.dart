import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/feature/auth/providers/sign_up_form_provider.dart';
import 'package:noema/feature/auth/providers/sign_up_provider.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.watch(signUpFormProvider.notifier);

    const double textFieldWidth = 1250;

    return Center(
      child: SizedBox(
        width: textFieldWidth,
        child: Column(
          spacing: 15,
          children: [
            TextField(
              onChanged: formNotifier.userNameChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nome de Usuário",
              ),
            ),
            TextField(
              onChanged: formNotifier.displayNameChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Como você gostaria de ser chamado",
              ),
            ),
            TextField(
              onChanged: formNotifier.emailChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "E-mail",
              ),
            ),
            TextField(
              onChanged: formNotifier.passwordChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Senha",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Confirme sua senha",
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(500, 55))
              ),
              onPressed: () async {
                await ref
                    .read(signUpControllerProvider.notifier)
                    .createUser(
                      displayName: form.displayName,
                      email: form.email,
                      password: form.password,
                      userName: form.userName,
                    );

                if (context.mounted) {
                  context.go("/login");
                }
              },
              child: Text("Criar User"),
            ),
          ],
        ),
      ),
    );
  }
}
