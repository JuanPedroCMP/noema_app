import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/providers/account_state.dart';
import 'package:noema/feature/auth/providers/login_form_provider.dart';
import 'package:noema/feature/auth/presentation/password_reset_dialog.dart';
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: form.loading
                    ? null
                    : () => showPasswordResetDialog(
                        context,
                        initialIdentificator: form.user,
                      ),
                child: const Text('Esqueceu a senha?'),
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

                  resetAccountScopedState(ref);
                  if (context.mounted) {
                    final returnPath = RoutePaths.safeReturnPath(
                      GoRouterState.of(context).uri.queryParameters['from'],
                    );
                    context.go(returnPath ?? RoutePaths.home);
                  }
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
              onPressed: () => context.go(
                RoutePaths.withReturnPath(
                  RoutePaths.signUp,
                  GoRouterState.of(context).uri.queryParameters['from'],
                ),
              ),
              child: const Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}
