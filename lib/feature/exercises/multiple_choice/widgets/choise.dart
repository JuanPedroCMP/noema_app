import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';

class Choise extends ConsumerStatefulWidget {
  const Choise({super.key, required this.choiseId});

  final String choiseId;

  @override
  ConsumerState<Choise> createState() => _Choise();
}

class _Choise extends ConsumerState<Choise> {
  bool isCorrect = false;
  String statement = "";
  String? explanation = "";
  int? weight = 0;
  bool? aiGenerated = false;

  int mode = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadData();
    });
  }

  void loadData() async {
    if (widget.choiseId.isEmpty) {
      return;
    }

    final db = ref.watch(appDatabaseProvider);

    final choiseDao = ChoiceDao(db);

    final data = await choiseDao.getChoice(id: widget.choiseId);

    if (!mounted) return;

    if (data == null) return;

    setState(() {
      isCorrect = data.isCorrect;
      statement = data.statement;
      explanation = data.explanation;
      weight = data.weight;
      aiGenerated = data.aiGenerated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Row(children: []));
  }
}
