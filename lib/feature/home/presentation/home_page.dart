import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/l10n/app_localizations.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.read(secureSorageProvider);

    return Center(
      child: SizedBox(
        width: 1000,
        child: Column(
          spacing: 15,
          children: [
            Row(
              spacing: 15,
              children: [
                Text(
                  AppLocalizations.of(context)!.helloWorld,
                ), // Recurso de tradução... Aplicar no restante do app
                OutlinedButton(
                  onPressed: () async {
                    await storage.delete(key: "access_token");
                    ref.invalidate(authStateProvider);
                  },
                  child: Text("Sair"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
