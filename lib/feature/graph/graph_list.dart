import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';

class GraphList extends ConsumerStatefulWidget {
  const GraphList({super.key});

  @override
  ConsumerState<GraphList> createState() => _GraphListState();
}

class _GraphListState extends ConsumerState<GraphList> {
  AppUserData? _user;
  List<KnowledgeGraphData> _graphs = [];
  late KnowledgeGraphDao _dao;


  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final userNotifier = ref.read(userProvider.notifier);
    final user = await userNotifier.getUser();

    final db = ref.read(appDatabaseProvider);
    final dao = KnowledgeGraphDao(db);

    final graphs = await dao.getKnowledgeGraphsByUser(userId: user.id);

    if (!mounted) return;

    setState(() {
      _user = user;
      _graphs = graphs;
      _dao = dao;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_graphs.isEmpty) {
      return const Center(child: Text("Nenhum grafo encontrado."));
    }

    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            carregar();
          },
          child: Icon(Icons.replay_outlined),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _graphs.map((graph) {
                return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "ID: ${graph.id}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text("Título: ${graph.title}"),
                          const SizedBox(height: 8),
                          Text(
                            "Descrição: ${graph.description ?? 'Sem descrição'}",
                          ),
                          Row(
                            spacing: context.spacing.md,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: Text("Ir para grafo"),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  _dao.deleteKnowledgeGraph(id: graph.id);
                                  carregar();
                                },
                                child: Text("Deletar grafo"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
