
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/auth/providers/sign_up_form_provider.dart';
import 'package:noema/feature/auth/providers/sign_up_provider.dart';
import 'package:noema/shared/widgets/async_action_button.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  String _passwordConfirmation = '';

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.read(signUpFormProvider.notifier);
    final signUpState = ref.watch(signUpControllerProvider);

    return AppResponsiveContent(
      maxWidth: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.spacing.md,
          children: [
            Text("Criar conta", style: context.textTheme.headlineMedium),
            Text("Preencha seus dados para começar."),
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
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Senha",
              ),
            ),
            TextField(
              obscureText: true,
              onChanged: (value) =>
                  setState(() => _passwordConfirmation = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Confirme sua senha",
              ),
            ),
            AsyncActionButton(
              loading: signUpState.isLoading,
              label: "Criar conta",
              onPressed: () async {
                if (form.userName.trim().isEmpty ||
                    form.displayName.trim().isEmpty ||
                    form.email.trim().isEmpty ||
                    form.password.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Preencha os campos e use uma senha com pelo menos 6 caracteres.",
                      ),
                    ),
                  );
                  return;
                }
                if (form.password != _passwordConfirmation) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("As senhas não coincidem."),
                    ),
                  );
                  return;
                }

                try {
                  await ref
                      .read(signUpControllerProvider.notifier)
                      .createUser(
                        displayName: form.displayName.trim(),
                        email: form.email.trim(),
                        password: form.password,
                        userName: form.userName.trim(),
                      );

                  if (ref.read(signUpControllerProvider).hasError) {
                    throw StateError("Falha ao criar conta");
                  }

                  if (context.mounted) context.go(RoutePaths.login);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Não foi possível criar a conta."),
                      ),
                    );
                  }
                }
              },
            ),
            TextButton(
              onPressed: () {
                context.go(RoutePaths.login);
              },
              child: Text("Cancelar"),
            ),
          ],
        ),
      ),
    );
  }
}
