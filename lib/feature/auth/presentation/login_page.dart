import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/providers/login_form_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/shared/widgets/async_action_button.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);

    return AppResponsiveContent(
      maxWidth: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.spacing.md,
          children: [
            Text("Entrar", style: context.textTheme.headlineMedium),
            Text("Acesse sua conta para continuar seus estudos."),
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

            AsyncActionButton(
              loading: form.loading,
              label: "Entrar",
              onPressed: () async {
                if (form.user.trim().isEmpty || form.password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Informe usuário e senha.")),
                    );
                    return;
                }

                formNotifier.loadingChanged(true);

                try {
                    final loginService = ref.read(loginServiceProvider);

                    await loginService.login(
                      user: form.user.trim(),
                      password: form.password,
                    );

                    if (!context.mounted) return;
                    ref.invalidate(authStateProvider);
                    final authenticated = await ref.read(
                      authStateProvider.future,
                    );

                    if (!authenticated) {
                      throw StateError("Não foi possível validar a sessão.");
                    }

                    if (context.mounted) context.go("/");
                } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Não foi possível entrar. Verifique suas credenciais.",
                          ),
                        ),
                      );
                    }
                } finally {
                    formNotifier.loadingChanged(false);
                }
              },
            ),
            TextButton(
              onPressed: () => context.go(RoutePaths.signUp),
              child: const Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}
