import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';

Future<void> showPasswordResetDialog(
  BuildContext context, {
  String initialIdentificator = '',
}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _PasswordResetDialog(initialIdentificator: initialIdentificator),
  );
}

class _PasswordResetDialog extends ConsumerStatefulWidget {
  const _PasswordResetDialog({required this.initialIdentificator});

  final String initialIdentificator;

  @override
  ConsumerState<_PasswordResetDialog> createState() =>
      _PasswordResetDialogState();
}

class _PasswordResetDialogState extends ConsumerState<_PasswordResetDialog> {
  late final TextEditingController _identificatorController;
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _codeRequested = false;
  bool _sendingCode = false;
  bool _resettingPassword = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  String? _error;

  bool get _busy => _sendingCode || _resettingPassword;

  @override
  void initState() {
    super.initState();
    _identificatorController = TextEditingController(
      text: widget.initialIdentificator,
    );
  }

  @override
  void dispose() {
    _identificatorController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    if (!_codeRequested && _identificatorController.text.trim().isEmpty) {
      _formKey.currentState!.validate();
      return;
    }
    setState(() {
      _sendingCode = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.dio.post<Object?>(
        '/api/v1/auth/call_password_rest',
        queryParameters: {
          'identificator': _identificatorController.text.trim(),
        },
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 45),
        ),
      );
      if (!mounted) return;
      setState(() => _codeRequested = true);
    } on DioException catch (error) {
      if (mounted) setState(() => _error = _requestErrorMessage(error));
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Não foi possível solicitar o código. Tente novamente.';
        });
      }
    } finally {
      if (mounted) setState(() => _sendingCode = false);
    }
  }

  Future<void> _confirmReset() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmationController.text) {
      setState(() => _error = 'As senhas não coincidem.');
      return;
    }

    setState(() {
      _resettingPassword = true;
      _error = null;
    });

    try {
      await ref
          .read(apiClientProvider)
          .getAuthenticationApi()
          .confirmPwdResetApiV1AuthConfirmPasswordRestPost(
            identificator: _identificatorController.text.trim(),
            newPassword: _passwordController.text,
            code: _codeController.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Senha alterada. Entre com sua nova senha.'),
          ),
        );
    } on DioException catch (error) {
      if (mounted) setState(() => _error = _confirmErrorMessage(error));
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Não foi possível alterar a senha. Tente novamente.';
        });
      }
    } finally {
      if (mounted) setState(() => _resettingPassword = false);
    }
  }

  String _requestErrorMessage(DioException error) {
    if (error.type == DioExceptionType.receiveTimeout) {
      return 'A solicitação demorou mais que o esperado. Confira sua caixa de '
          'entrada e o spam antes de pedir outro código.';
    }
    if (error.response == null) {
      return 'Sem conexão com o servidor. Verifique a internet e tente novamente.';
    }
    if (error.response?.statusCode == 404) {
      return 'Não encontramos uma conta com esse usuário ou e-mail. '
          'Confira os dados e tente novamente.';
    }
    if (error.response?.statusCode == 429) {
      return 'Muitas tentativas em pouco tempo. Aguarde um pouco antes de tentar.';
    }
    if ((error.response?.statusCode ?? 0) >= 500) {
      return 'O servidor está indisponível no momento. Tente novamente mais tarde.';
    }
    return 'Não foi possível solicitar o código. Confira o usuário ou e-mail '
        'e tente novamente.';
  }

  String _confirmErrorMessage(DioException error) {
    if (error.response == null) {
      return 'Sem conexão com o servidor. Verifique a internet e tente novamente.';
    }
    if (error.response?.statusCode == 400 ||
        error.response?.statusCode == 404 ||
        error.response?.statusCode == 422) {
      return 'Código inválido ou expirado. Confira o código ou solicite outro.';
    }
    if (error.response?.statusCode == 429) {
      return 'Muitas tentativas em pouco tempo. Aguarde um pouco antes de tentar.';
    }
    if ((error.response?.statusCode ?? 0) >= 500) {
      return 'O servidor está indisponível no momento. Tente novamente mais tarde.';
    }
    return 'Não foi possível alterar a senha. Confira os dados e tente novamente.';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_codeRequested ? 'Criar nova senha' : 'Recuperar senha'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(value: _codeRequested ? 1 : 0.5),
                const SizedBox(height: 20),
                if (!_codeRequested) ...[
                  const Text(
                    'Informe seu usuário ou e-mail. Se houver uma conta '
                    'correspondente, enviaremos um código de recuperação.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _identificatorController,
                    autofocus: true,
                    enabled: !_busy,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _requestCode(),
                    decoration: const InputDecoration(
                      labelText: 'Usuário ou e-mail',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Informe seu usuário ou e-mail.'
                        : null,
                  ),
                ] else ...[
                  Text(
                    'Digite o código enviado para a conta associada a '
                    '${_identificatorController.text.trim()}.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    enabled: !_busy,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: const InputDecoration(
                      labelText: 'Código de recuperação',
                      prefixIcon: Icon(Icons.mark_email_read_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Informe o código recebido.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_busy,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Nova senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Mostrar senha'
                            : 'Ocultar senha',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a nova senha.';
                      }
                      if (value.length < 6) {
                        return 'Use pelo menos 6 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmationController,
                    enabled: !_busy,
                    obscureText: _obscureConfirmation,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _confirmReset(),
                    decoration: InputDecoration(
                      labelText: 'Confirme a nova senha',
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscureConfirmation
                            ? 'Mostrar senha'
                            : 'Ocultar senha',
                        onPressed: () => setState(
                          () => _obscureConfirmation = !_obscureConfirmation,
                        ),
                        icon: Icon(
                          _obscureConfirmation
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Confirme a nova senha.'
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _busy
                          ? null
                          : () {
                              setState(() {
                                _codeRequested = false;
                                _error = null;
                              });
                            },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Alterar usuário ou e-mail'),
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_codeRequested)
          TextButton(
            onPressed: _busy ? null : _requestCode,
            child: const Text('Reenviar código'),
          ),
        FilledButton.icon(
          onPressed: _busy
              ? null
              : _codeRequested
              ? _confirmReset
              : _requestCode,
          icon: _busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(_codeRequested ? Icons.check : Icons.send_outlined),
          label: Text(
            _sendingCode
                ? 'Enviando…'
                : _resettingPassword
                ? 'Salvando…'
                : _codeRequested
                ? 'Alterar senha'
                : 'Enviar código',
          ),
        ),
      ],
    );
  }
}
