import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/auth/providers/sign_up_form_provider.dart';
import 'package:noema/feature/auth/providers/sign_up_provider.dart';
import 'package:noema/feature/auth/services/password_policy.dart';
import 'package:noema/shared/widgets/async_action_button.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmationVisible = false;
  bool _showValidation = false;

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return 'Informe um nome de usuário.';
    if (username.length < 3 || username.length > 32) {
      return 'Use entre 3 e 32 caracteres.';
    }
    if (!RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(username)) {
      return 'Use apenas letras, números, ponto, hífen ou sublinhado.';
    }
    return null;
  }

  String? _validateDisplayName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Informe como devemos chamar você.';
    if (name.length < 2 || name.length > 60) {
      return 'Use entre 2 e 60 caracteres.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Informe seu e-mail.';
    if (email.length > 254 ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Digite um endereço de e-mail válido.';
    }
    return null;
  }

  String? _validateConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirme sua senha.';
    if (value != password) return 'As senhas não coincidem.';
    return null;
  }

  String _createAccountError(Object? error) {
    if (error is DioException) {
      if (error.response == null) {
        return 'Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente.';
      }
      return switch (error.response?.statusCode) {
        409 =>
          'Este usuário ou e-mail já está cadastrado. Tente entrar ou use outros dados.',
        422 =>
          'Alguns dados não foram aceitos. Revise os campos e tente novamente.',
        429 => 'Muitas tentativas em pouco tempo. Aguarde e tente novamente.',
        final status? when status >= 500 =>
          'O serviço está indisponível no momento. Tente novamente mais tarde.',
        _ =>
          'Não foi possível criar a conta. Revise os dados e tente novamente.',
      };
    }
    return 'Não foi possível criar a conta. Tente novamente.';
  }

  Future<void> _submit() async {
    setState(() => _showValidation = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final form = ref.read(signUpFormProvider);
    await ref
        .read(signUpControllerProvider.notifier)
        .createUser(
          displayName: form.displayName.trim(),
          email: form.email.trim(),
          password: form.password,
          userName: form.userName.trim(),
        );

    if (!mounted) return;
    final result = ref.read(signUpControllerProvider);
    if (result.hasError) return;

    ref.read(signUpFormProvider.notifier).reset();
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    context.go(RoutePaths.withReturnPath(RoutePaths.login, from));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conta criada. Entre com seu usuário e senha.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.read(signUpFormProvider.notifier);
    final signUpState = ref.watch(signUpControllerProvider);
    final loginPath = RoutePaths.withReturnPath(
      RoutePaths.login,
      GoRouterState.of(context).uri.queryParameters['from'],
    );

    return AppResponsiveContent(
      maxWidth: AppLayoutTokens.formContentWidth,
      child: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(context.spacing.lg),
            child: Form(
              key: _formKey,
              autovalidateMode: _showValidation
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: context.spacing.md,
                children: [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 40,
                    color: context.colors.primary,
                  ),
                  Text(
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium,
                  ),
                  Text(
                    'Seus estudos e progresso ficam organizados em um só lugar.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium,
                  ),
                  const Divider(),
                  Text('Seus dados', style: context.textTheme.titleMedium),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.username],
                    onChanged: formNotifier.userNameChanged,
                    validator: _validateUsername,
                    decoration: const InputDecoration(
                      labelText: 'Nome de usuário',
                      hintText: 'ex.: maria.silva',
                      prefixIcon: Icon(Icons.alternate_email),
                      helperText:
                          'De 3 a 32 caracteres; pode ser alterado depois.',
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onChanged: formNotifier.displayNameChanged,
                    validator: _validateDisplayName,
                    decoration: const InputDecoration(
                      labelText: 'Nome de exibição',
                      hintText: 'Como gostaria de ser chamada(o)',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.email],
                    onChanged: formNotifier.emailChanged,
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const Divider(),
                  Text('Crie uma senha', style: context.textTheme.titleMedium),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    obscureText: !_passwordVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: formNotifier.passwordChanged,
                    validator: PasswordPolicy.validate,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _passwordVisible
                            ? 'Ocultar senha'
                            : 'Mostrar senha',
                        onPressed: () => setState(
                          () => _passwordVisible = !_passwordVisible,
                        ),
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  _PasswordGuidance(password: form.password),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    obscureText: !_confirmationVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (_) => setState(() {}),
                    validator: (value) =>
                        _validateConfirmation(value, form.password),
                    onFieldSubmitted: (_) =>
                        signUpState.isLoading ? null : _submit(),
                    decoration: InputDecoration(
                      labelText: 'Confirme a senha',
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      suffixIcon: IconButton(
                        tooltip: _confirmationVisible
                            ? 'Ocultar confirmação'
                            : 'Mostrar confirmação',
                        onPressed: () => setState(
                          () => _confirmationVisible = !_confirmationVisible,
                        ),
                        icon: Icon(
                          _confirmationVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  if (signUpState.hasError)
                    _SignUpError(
                      message: _createAccountError(signUpState.error),
                    ),
                  AsyncActionButton(
                    loading: signUpState.isLoading,
                    label: 'Criar conta',
                    icon: Icons.check_circle_outline,
                    onPressed: signUpState.isLoading ? null : _submit,
                  ),
                  TextButton(
                    onPressed: signUpState.isLoading
                        ? null
                        : () => context.go(loginPath),
                    child: const Text('Já tenho uma conta · Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordGuidance extends StatelessWidget {
  const _PasswordGuidance({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final requirements = [
      (PasswordPolicy.hasMinimumLength(password), 'Pelo menos 8 caracteres'),
      (PasswordPolicy.hasLetter(password), 'Uma letra'),
      (PasswordPolicy.hasNumber(password), 'Um número'),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        for (final (valid, label) in requirements)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                valid ? Icons.check_circle : Icons.circle_outlined,
                size: 15,
                color: valid
                    ? context.colors.primary
                    : context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(label, style: context.textTheme.bodySmall),
            ],
          ),
      ],
    );
  }
}

class _SignUpError extends StatelessWidget {
  const _SignUpError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(context.spacing.sm),
    decoration: BoxDecoration(
      color: context.colors.errorContainer,
      borderRadius: BorderRadius.circular(context.radius.md),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, color: context.colors.onErrorContainer),
        SizedBox(width: context.spacing.sm),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: context.colors.onErrorContainer),
          ),
        ),
      ],
    ),
  );
}
