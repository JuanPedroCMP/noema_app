import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/feature/graph/provider/graph_form_provider.dart';
import 'package:noema/feature/graph/provider/temp_json_graph_provider.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';
import 'package:openapi/openapi.dart';

class CreateGraph extends ConsumerWidget {
  const CreateGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(graphFormProvider);
    final formProvider = ref.watch(graphFormProvider.notifier);

    final db = ref.watch(appDatabaseProvider);
    final kGraphDao = KnowledgeGraphDao(db);
    final userDao = AppUserDao(db);

    final jsonForm = ref.watch(tempJsonGraphProvider);
    final jsonFormNotifier = ref.watch(tempJsonGraphProvider.notifier);


    return Column(
      children: [
        TextField(
          onChanged: jsonFormNotifier.jsonChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Json do grafo",
          ),
        ),

        OutlinedButton(
          onPressed: () async {
            var response = await ref
                .read(userApiProvider)
                .currentUserApiV1UserGetGet();

            UserOut? remoteUser = response.data;

            AppUserData? user = await userDao.getUser(remoteId: remoteUser!.id);

            importGraphFromJson(db: db, userId: user!.id, jsonString: jsonForm);
          },
          child: Text("Criar Grafo Completo"),
        ),

        Divider(),

        TextField(
          onChanged: formProvider.titleChagend,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Título",
          ),
        ),

        TextField(
          onChanged: formProvider.descriptionChagend,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Descrição",
          ),
        ),

        OutlinedButton(
          onPressed: () async {
            var response = await ref
                .read(userApiProvider)
                .currentUserApiV1UserGetGet();

            UserOut? remoteUser = response.data;

            AppUserData? user = await userDao.getUser(remoteId: remoteUser!.id);

            await kGraphDao.insertKnowledgeGraph(
              userId: user!.id,
              title: form.title,
              description: form.description,
            );
          },
          child: Text("Criar"),
        ),
      ],
    );
  }
}
