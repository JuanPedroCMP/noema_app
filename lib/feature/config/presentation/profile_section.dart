import 'package:dio/dio.dart';
import 'package:dicebear_core/dicebear_core.dart';
import 'package:dicebear_styles/pixelbot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noema/core/design/tokens/durations.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';
import 'package:noema/feature/config/providers/user_form_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/auth/services/password_policy.dart';
import 'package:noema/shared/widgets/async_action_button.dart';
import 'package:noema/shared/editable_field/editable_field.dart';

final _pixelbotStyle = Style.parse(pixelbot);

class ProfileSection extends ConsumerStatefulWidget {
  const ProfileSection({super.key});

  @override
  ConsumerState<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<ProfileSection> {
  bool _syncing = false;
  bool _savingPassword = false;
  bool _passwordVisible = false;
  bool _passwordConfirmationVisible = false;
  final _passwordFormKey = GlobalKey<FormState>();
  String? _syncError;
  String? _googleAvatarUrl;

  String _passwordUpdateError(Object error) {
    if (error is DioException) {
      if (error.response == null) {
        return 'Sem conexão com o servidor. Verifique a internet e tente novamente.';
      }
      return switch (error.response?.statusCode) {
        401 => 'Sua sessão expirou. Entre novamente para alterar a senha.',
        422 =>
          'A senha não foi aceita pelo servidor. Confira os requisitos e tente outra.',
        429 =>
          'Muitas tentativas em pouco tempo. Aguarde antes de tentar novamente.',
        final status? when status >= 500 =>
          'O serviço está indisponível. Tente novamente mais tarde.',
        _ => 'Não foi possível alterar a senha. Tente novamente.',
      };
    }
    return 'Não foi possível alterar a senha. Tente novamente.';
  }

  Future<void> _submitPassword({
    required UserNotifier userNotifier,
    required UserFormNotifier formNotifier,
    required String password,
  }) async {
    if (!(_passwordFormKey.currentState?.validate() ?? false)) return;
    setState(() => _savingPassword = true);
    try {
      await userNotifier.updateUser(password: password);
      if (!mounted) return;
      formNotifier.reset();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso.')),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_passwordUpdateError(error))));
    } finally {
      if (mounted) setState(() => _savingPassword = false);
    }
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(configRefreshProvider, (previous, next) {
      if (previous != next) _refreshFromServer();
    });
    ref.listenManual(serverConnectionChecker, (previous, next) {
      if (next.value == true && previous?.value != true) {
        _refreshFromServer();
      }
    });
    _refreshFromServer();
  }

  Future<void> _refreshFromServer() async {
    final isConnected =
        (ref.read(serverConnectionChecker).value ??
            await ref.read(serverConnectionChecker.future)) ==
        true;
    if (!isConnected || !mounted) return;

    setState(() {
      _syncing = true;
      _syncError = null;
    });
    try {
      await ref.read(userProvider.notifier).refreshFromServer();
      final user = await ref.read(userProvider.future);
      await _loadGoogleAvatar(user.remoteId);
    } catch (error) {
      if (mounted) {
        setState(() => _syncError = 'Não foi possível atualizar o perfil.');
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _loadGoogleAvatar(String remoteUserId) async {
    try {
      final response = await ref
          .read(apiClientProvider)
          .getAuthenticationApi()
          .getGoogleAccountApiV1AuthGoogleGetIdentificatorGet(
            identificator: remoteUserId,
          );
      final account = response.data;
      if (account == null || account.idUser != remoteUserId) {
        throw StateError('A conta Google retornada não pertence ao usuário.');
      }
      final googleIdentity = account.googleUserId?.trim().isNotEmpty == true
          ? account.googleUserId!.trim()
          : account.emailGoogle.trim();
      if (googleIdentity.isEmpty) return;
      final avatarUri = Uri.https(
        'www.google.com',
        '/s2/photos/profile/$googleIdentity',
        {'sz': '160'},
      );
      if (mounted) setState(() => _googleAvatarUrl = avatarUri.toString());
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) {
        debugPrint('Não foi possível carregar o avatar Google: $error');
      }
      if (mounted) setState(() => _googleAvatarUrl = null);
    } catch (error) {
      debugPrint('Não foi possível carregar o avatar Google: $error');
      if (mounted) setState(() => _googleAvatarUrl = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final user = ref.watch(userProvider);
    final form = ref.watch(userFormProvider);
    final formNotifier = ref.watch(userFormProvider.notifier);
    final userNotifier = ref.watch(userProvider.notifier);
    final durations = Theme.of(
      context,
    ).extension<AppDurationsTheme>()!.durations;

    return Column(
      children: [
        if (_syncing || _syncError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _syncing ? 'Atualizando perfil do servidor…' : _syncError!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        user.when(
          data: (profile) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _ProfileAvatar(
                    imageUrl: _googleAvatarUrl,
                    seed: profile.remoteId,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.displayName.trim().isEmpty
                              ? profile.userName
                              : profile.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${profile.userName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.primaryEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, _) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        Column(
          key: const ValueKey("View"),
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            EditableField(
              display: user.when(
                data: (user) => Text(user.userName),
                error: (e, _) => const Text("Ocorreu um erro"),
                loading: () => const Text("Carregando..."),
              ),
              inputLabel: "User Name:",
              onCancel: () {},
              onChanged: (value) {
                formNotifier.userNameChanged(value);
              },
              onConfirm: () async {
                await userNotifier.updateUser(userName: form.userName);
              },
              displayLabel: const Text("Nome de usuário:"),
            ),
            EditableField(
              display: user.when(
                data: (user) => Text(user.displayName),
                error: (e, _) => const Text("Ocorreu um erro"),
                loading: () => const Text("Carregando..."),
              ),
              inputLabel: "Display name:",
              onCancel: () {},
              onChanged: (value) {
                formNotifier.displayNameChanged(value);
              },
              onConfirm: () async {
                await userNotifier.updateUser(displayName: form.displayName);
              },
              displayLabel: Text("Nome de Display: "),
            ),
            EditableField(
              display: user.when(
                data: (user) => Text(user.primaryEmail),
                error: (e, _) => const Text("Ocorreu um erro"),
                loading: () => const Text("Carregando..."),
              ),
              inputLabel: "Email",
              onCancel: () {},
              onChanged: (value) {
                formNotifier.emailChanged(value);
              },
              onConfirm: () async {
                await userNotifier.updateUser(primaryEmail: form.email);
              },
              displayLabel: Text("Email: "),
            ),

            AnimatedSwitcher(
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              duration: durations.fast,
              child: !form.isEditing
                  ? OutlinedButton(
                      onPressed: () {
                        formNotifier.isEditingChanged(true);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.edit), Text("Mudar senha")],
                      ),
                    )
                  : Column(
                      key: const ValueKey("Edit"),
                      children: [
                        Form(
                          key: _passwordFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: context.spacing.md,
                            children: [
                              Text(
                                'Escolha uma senha forte para proteger sua conta.',
                                style: context.textTheme.bodyMedium,
                              ),
                              TextFormField(
                                onChanged: formNotifier.passwordChanged,
                                obscureText: !_passwordVisible,
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: PasswordPolicy.validate,
                                decoration: InputDecoration(
                                  labelText: 'Nova senha',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    tooltip: _passwordVisible
                                        ? 'Ocultar senha'
                                        : 'Mostrar senha',
                                    onPressed: () => setState(
                                      () =>
                                          _passwordVisible = !_passwordVisible,
                                    ),
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              _PasswordRequirements(password: form.password),
                              TextFormField(
                                onChanged: formNotifier.passwordVerifyChanged,
                                obscureText: !_passwordConfirmationVisible,
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirme a nova senha.';
                                  }
                                  if (value != form.password) {
                                    return 'As senhas não coincidem.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Confirme a nova senha',
                                  prefixIcon: const Icon(Icons.lock_reset),
                                  suffixIcon: IconButton(
                                    tooltip: _passwordConfirmationVisible
                                        ? 'Ocultar confirmação'
                                        : 'Mostrar confirmação',
                                    onPressed: () => setState(
                                      () => _passwordConfirmationVisible =
                                          !_passwordConfirmationVisible,
                                    ),
                                    icon: Icon(
                                      _passwordConfirmationVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              AsyncActionButton(
                                loading: _savingPassword,
                                label: 'Atualizar senha',
                                icon: Icons.check,
                                onPressed: _savingPassword
                                    ? null
                                    : () => _submitPassword(
                                        userNotifier: userNotifier,
                                        formNotifier: formNotifier,
                                        password: form.password,
                                      ),
                              ),
                              OutlinedButton.icon(
                                onPressed: _savingPassword
                                    ? null
                                    : () {
                                        formNotifier.reset();
                                        _passwordFormKey.currentState?.reset();
                                      },
                                icon: const Icon(Icons.close),
                                label: const Text('Cancelar'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 4,
    children: [
      _PasswordRequirement(
        valid: PasswordPolicy.hasMinimumLength(password),
        label: '8 caracteres',
      ),
      _PasswordRequirement(
        valid: PasswordPolicy.hasLetter(password),
        label: 'Uma letra',
      ),
      _PasswordRequirement(
        valid: PasswordPolicy.hasNumber(password),
        label: 'Um número',
      ),
    ],
  );
}

class _PasswordRequirement extends StatelessWidget {
  const _PasswordRequirement({required this.valid, required this.label});

  final bool valid;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        valid ? Icons.check_circle : Icons.circle_outlined,
        size: 15,
        color: valid
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      const SizedBox(width: 4),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl, required this.seed});

  final String? imageUrl;
  final String seed;

  @override
  Widget build(BuildContext context) {
    final fallback = SvgPicture.string(
      Avatar(_pixelbotStyle, {
        'tags': ['animation'],
        'seed': seed,
      }).svg,
      fit: BoxFit.cover,
      semanticsLabel: 'Avatar ilustrado',
    );

    return Semantics(
      image: true,
      label: 'Foto de perfil',
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ClipOval(
          child: imageUrl == null
              ? fallback
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : fallback,
                  errorBuilder: (context, error, stackTrace) => fallback,
                ),
        ),
      ),
    );
  }
}
