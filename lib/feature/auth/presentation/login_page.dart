import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/auth/presentation/password_reset_dialog.dart';
import 'package:noema/feature/auth/providers/account_state.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/providers/login_form_provider.dart';
import 'package:noema/feature/auth/providers/login_form_state.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/shared/widgets/async_action_button.dart';
import 'package:noema/shared/widgets/noema_logo.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _passwordVisible = false;

  Future<void> _submit() async {
    final form = ref.read(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    if (form.user.trim().isEmpty || form.password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: RuntimeLocalizedText('Informe usuário e senha.'),
        ),
      );
      return;
    }

    formNotifier.loadingChanged(true);
    try {
      await ref
          .read(loginServiceProvider)
          .login(user: form.user.trim(), password: form.password);

      if (!mounted) return;
      ref.invalidate(authStateProvider);
      final authenticated = await ref.read(authStateProvider.future);
      if (!authenticated) {
        throw StateError('Não foi possível validar a sessão.');
      }

      resetAccountScopedState(ref);
      if (!mounted) return;
      final returnPath = RoutePaths.safeReturnPath(
        GoRouterState.of(context).uri.queryParameters['from'],
      );
      context.go(returnPath ?? RoutePaths.home);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: RuntimeLocalizedText(
            'Não foi possível entrar. Verifique suas credenciais.',
          ),
        ),
      );
    } finally {
      formNotifier.loadingChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    final returnPath = GoRouterState.of(context).uri.queryParameters['from'];

    return AppResponsiveContent(
      maxWidth: AppLayoutTokens.widePageContentWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _BrandPanel(
                    onCreateAccount: () => context.go(
                      RoutePaths.withReturnPath(RoutePaths.signUp, returnPath),
                    ),
                  ),
                ),
                SizedBox(width: context.spacing.xl),
                Expanded(
                  child: _loginCard(
                    context,
                    form,
                    formNotifier,
                    showCreateAccount: false,
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NoemaLogo(markSize: 46, wordmarkSize: 42),
                SizedBox(height: context.spacing.lg),
                _loginCard(
                  context,
                  form,
                  formNotifier,
                  showCreateAccount: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loginCard(
    BuildContext context,
    LoginFormState form,
    LoginFormNotifier formNotifier, {
    required bool showCreateAccount,
  }) {
    final returnPath = GoRouterState.of(context).uri.queryParameters['from'];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.spacing.md,
          children: [
            RuntimeLocalizedText(
              'Seja bem-vindo',
              style: context.textTheme.headlineMedium,
            ),
            Text(
              'Entre na sua conta para continuar de onde parou.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: context.spacing.xs),
            TextField(
              onChanged: formNotifier.userChanged,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofillHints: const [AutofillHints.username],
              decoration: const InputDecoration(
                labelText: 'Usuário',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            TextField(
              onChanged: formNotifier.passwordChanged,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              autofillHints: const [AutofillHints.password],
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: _passwordVisible ? 'Ocultar senha' : 'Mostrar senha',
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                  icon: Icon(
                    _passwordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
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
                child: const RuntimeLocalizedText('Esqueceu a senha?'),
              ),
            ),
            AsyncActionButton(
              loading: form.loading,
              label: 'Entrar',
              icon: Icons.login_rounded,
              onPressed: form.loading ? null : _submit,
            ),
            if (showCreateAccount) ...[
              const Divider(),
              TextButton(
                onPressed: form.loading
                    ? null
                    : () => context.go(
                        RoutePaths.withReturnPath(
                          RoutePaths.signUp,
                          returnPath,
                        ),
                      ),
                child: const RuntimeLocalizedText(
                  'Ainda não tem uma conta? Cadastre-se',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final brandSurface = darkMode
        ? colors.surfaceContainerHigh
        : colors.inverseSurface;
    final foreground = darkMode ? colors.onSurface : colors.onInverseSurface;
    final brandAccent = darkMode ? colors.primary : colors.inversePrimary;

    return Container(
      padding: EdgeInsets.all(context.spacing.xl),
      decoration: BoxDecoration(
        color: brandSurface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoemaLogo(
                markSize: 156,
                wordmarkSize: 66,
                stacked: true,
                inkColor: foreground,
                accentColor: brandAccent,
              ),
              SizedBox(height: context.spacing.lg),
              Text(
                'Aprenda conectando ideias.',
                style: context.textTheme.titleLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.spacing.xs),
              Text(
                'Seu grafo de conhecimento personalizado para organizar o que você aprende.',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: foreground.withValues(alpha: .76),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ainda não tem uma conta?',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: foreground.withValues(alpha: .82),
                ),
              ),
              SizedBox(height: context.spacing.sm),
              OutlinedButton(
                onPressed: onCreateAccount,
                style: OutlinedButton.styleFrom(
                  foregroundColor: foreground,
                  side: BorderSide(color: foreground.withValues(alpha: .4)),
                ),
                child: const RuntimeLocalizedText('Cadastre-se'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
