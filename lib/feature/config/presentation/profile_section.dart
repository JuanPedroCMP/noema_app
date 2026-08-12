import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/tokens/durations.dart';
import 'package:noema/feature/config/providers/user_form_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/shared/editable_field/editable_field.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final form = ref.watch(userFormProvider);
    final formNotifier = ref.watch(userFormProvider.notifier);
    final userNotifier = ref.watch(userProvider.notifier);
    final durations = Theme.of(
      context,
    ).extension<AppDurationsTheme>()!.durations;

    return Column(
      children: [
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
                formNotifier.displayNameChanged(value);
              },
              onConfirm: () {
                userNotifier.updateUser(displayName: form.displayName);
              },
              displayLabel: Text("Nome de Display:"),
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
              onConfirm: () {
                userNotifier.updateUser(displayName: form.displayName);
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
              onConfirm: () {
                userNotifier.updateUser(primaryEmail: form.email);
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
                  ? Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          formNotifier.isEditingChanged(form.isEditing);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.edit), Text("Mudar senha")],
                        ),
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
                          onPressed: () {
                            userNotifier.updateUser(password: form.password);
                            formNotifier.isEditingChanged(form.isEditing);
                          },
                          child: Text("Alterar"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            formNotifier.isEditingChanged(form.isEditing);
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
