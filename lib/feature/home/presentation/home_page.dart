import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.read(secureSorageProvider);
    return AppResponsiveContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          AppPageHeader(
            title: AppLocalizations.of(context)!.helloWorld,
            subtitle: "Organize seus estudos e continue de onde parou.",
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 420;
                  final message = const Text(
                    "Sua área de estudos está pronta para você.",
                  );
                  final logout = OutlinedButton.icon(
                    onPressed: () async {
                      await storage.delete(key: "access_token");
                      ref.invalidate(authStateProvider);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Sair"),
                  );
                  return compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: [message, logout],
                        )
                      : Row(
                          children: [
                            Expanded(child: message),
                            logout,
                          ],
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
