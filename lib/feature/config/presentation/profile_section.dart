import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/tokens/durations.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';
import 'package:noema/feature/config/providers/user_form_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/shared/editable_field/editable_field.dart';

class ProfileSection extends ConsumerStatefulWidget {
  const ProfileSection({super.key});

  @override
  ConsumerState<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<ProfileSection> {
  bool _syncing = false;
  String? _syncError;

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
    } catch (error) {
      if (mounted) {
        setState(() => _syncError = 'Não foi possível atualizar o perfil.');
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
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
                      spacing: 30,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: (value) {
                            formNotifier.passwordChanged(value);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Senha",
                          ),
                        ),
                        TextField(
                          onChanged: (value) {
                            formNotifier.passwordVerifyChanged(value);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Verifique sua senha",
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            if (form.password.isEmpty ||
                                form.password != form.passwordVerify) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("As senhas não coincidem."),
                                ),
                              );
                              return;
                            }
                            await userNotifier.updateUser(
                              password: form.password,
                            );
                            if (context.mounted) {
                              formNotifier.reset();
                            }
                          },
                          child: Text("Alterar"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            formNotifier.reset();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.cancel), Text("Cancelar")],
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
