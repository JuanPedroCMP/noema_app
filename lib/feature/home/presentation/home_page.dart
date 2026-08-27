import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.read(secureSorageProvider);
    final db = ref.read(appDatabaseProvider);
    final graph = KnowledgeGraphDao(db);
    final userNotifier = ref.watch(userProvider.notifier);

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

                OutlinedButton(
                  onPressed: () async {
                    await db.deleteDatabase();
                  },
                  child: Text("Apagar DB"),
                ),
                 OutlinedButton(
                  onPressed: () async {
                    var user = await userNotifier.getUser();
                    var graphs = graph.getKnowledgeGraphsByUser(
                      userId: user.id,
                    );
                    for (KnowledgeGraphData grph in await graphs) {
                      print(grph);
                      graph.deleteKnowledgeGraph(id: grph.id);
                    }
                  },
                  child: Text("Limpar KGraphs"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
