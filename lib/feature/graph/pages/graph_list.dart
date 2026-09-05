import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/feature/graph/pages/create_blank_graph.dart';
import 'package:noema/feature/graph/pages/create_graph_with_ai.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';
import 'package:noema/feature/splash/presentation/splash_page.dart';
import 'package:noema/shared/floating_card/floating_card.dart';

class GraphList extends ConsumerStatefulWidget {
  const GraphList({super.key});

  @override
  ConsumerState<GraphList> createState() => _GraphListState();
}

class _GraphListState extends ConsumerState<GraphList> {
  AppUserData? _user;
  late KnowledgeGraphDao _dao;
  int opc = 0;

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

    if (!mounted) return;

    setState(() {
      _user = user;
      _dao = dao;
    });
  }

  void changeOpc(int value) {
    setState(() {
      opc = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final graphsAsync = ref.watch(knowledgeGraphsProvider);

    if (_user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return graphsAsync.when(
      data: (graphs) {
        if (graphs.isEmpty) {
          return Center(
            child: Column(
              children: [
                Text("Nenhum grafo encontrado, Crie seu primeiro grafo!"),
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 500,
                    height: 250,
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: context.spacing.md,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            spacing: context.spacing.md,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  if (opc != 2) {
                                    changeOpc(2);
                                  } else {
                                    changeOpc(0);
                                  }
                                },
                                child: Row(
                                  children: [Text("Criar Grafo Vazio")],
                                ),
                              ),
                              VerticalDivider(),
                              OutlinedButton(
                                onPressed: () {
                                  if (opc != 3) {
                                    changeOpc(3);
                                  } else {
                                    changeOpc(0);
                                  }
                                },
                                child: Row(
                                  children: [Text("Gerar Grafo Com IA")],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (opc == 2)
                  Align(
                    alignment: Alignment.center,
                    child: FloatingCard(
                      width: 600,
                      child: SingleChildScrollView(child: CreateBlankGraph()),
                    ),
                  ),
                if (opc == 3)
                  Align(
                    alignment: Alignment.center,
                    child: FloatingCard(
                      width: 600,
                      child: SingleChildScrollView(child: CreateGraphWithAi()),
                    ),
                  ),
              ],
            ),
          );
        }

        return Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: context.spacing.md,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (opc != 1) {
                        changeOpc(1);
                      } else {
                        changeOpc(0);
                      }
                    },
                    child: Row(
                      spacing: context.spacing.md,
                      children: [
                        Text("Criar Novo Grafo"),
                        Icon(Icons.add_rounded),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      carregar();
                    },
                    child: Icon(Icons.replay_outlined),
                  ),
                ],
              ),
              SizedBox(height: context.spacing.sm),
              Stack(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: context.spacing.sm,
                        runSpacing: context.spacing.sm,
                        children: graphs.map((graph) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "ID: ${graph.id}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                        onPressed: () {
                                          context.push("/graphs/${graph.id}");
                                          sugiyama(graph.id, ref);
                                        },
                                        child: Text("Ir para grafo"),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          context.push(
                                            "/graphs/edit/${graph.id}",
                                          );
                                        },
                                        child: Text("Editar grafo"),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          _dao.deleteKnowledgeGraph(
                                            id: graph.id,
                                          );
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
                  if (opc == 1)
                    Align(
                      alignment: Alignment.center,
                      child: FloatingCard(
                        width: 500,
                        height: 250,
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: context.spacing.md,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                spacing: context.spacing.md,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      if (opc != 2) {
                                        changeOpc(2);
                                      } else {
                                        changeOpc(0);
                                      }
                                    },
                                    child: Row(
                                      children: [Text("Criar Grafo Vazio")],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  OutlinedButton(
                                    onPressed: () {
                                      if (opc != 3) {
                                        changeOpc(3);
                                      } else {
                                        changeOpc(0);
                                      }
                                    },
                                    child: Row(
                                      children: [Text("Gerar Grafo Com IA")],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (opc == 2)
                    Align(
                      alignment: Alignment.center,
                      child: FloatingCard(
                        width: 600,
                        child: SingleChildScrollView(child: CreateBlankGraph()),
                      ),
                    ),
                  if (opc == 3)
                    Align(
                      alignment: Alignment.center,
                      child: FloatingCard(
                        width: 600,
                        child: SingleChildScrollView(
                          child: CreateGraphWithAi(),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      error: (err, stack) => Text("Erro"),
      loading: () => SplashPage(),
    );
  }
}
