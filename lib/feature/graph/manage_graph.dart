import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';

enum NodeType { AREA, TOPIC, CONCEPT, SUBCONCEPT }

class ManageGraph extends ConsumerWidget {
  ManageGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    final kGraphDao = KnowledgeGraphDao(db);
    final userDao = AppUserDao(db);

    return Column(
      children: [
        // TextField(
        //   onChanged: formProvider.titleChagend,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(),
        //     labelText: "Título",
        //   ),
        // ),

        // TextField(
        //   onChanged: formProvider.descriptionChagend,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(),
        //     labelText: "Descrição",
        //   ),
        // ),

        // OutlinedButton(
        //   onPressed: () async {
        //     var response = await ref
        //         .read(userApiProvider)
        //         .currentUserApiV1UserGetGet();

        //     UserOut? remoteUser = response.data;

        //     AppUserData? user = await userDao.getUser(remoteId: remoteUser!.id);

        //     await kGraphDao.insertKnowledgeGraph(
        //       userId: user!.id,
        //       title: form.title,
        //       description: form.description,
        //     );
        //   },
        //   child: Text("Criar"),
        // ),
      ],
    );
  }
}
