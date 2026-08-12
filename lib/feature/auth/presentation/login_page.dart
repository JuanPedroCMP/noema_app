import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/providers/login_form_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';

class LoginPage extends ConsumerWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final form = ref.watch(loginFormProvider);
    final formNotifier = ref.watch(loginFormProvider.notifier);


    return Center(
      child: Column(
      spacing: 15,
      children: [
        TextField(
          onChanged: formNotifier.userChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Usuário"
          ),
        ),

        TextField(
          onChanged: formNotifier.passwordChanged,
          obscureText: true,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Senha"
          ),
        ),

        ElevatedButton(
          onPressed: () async {
            final loginService = ref.read(loginServiceProvider);

            try {
              await loginService.login(user: form.user, password: form.password);
              
              ref.invalidate(authStateProvider);
              if(context.mounted) {
                context.go("/");
              }
            } catch (e) {
                //
            }
          },
          child: Text("Entrar")
        ),
        TextButton(
          onPressed: () {
            context.go("/sign_up");
          },
          child: Text("Cria Conta"),
        )
      ],
    ),);
  }
}