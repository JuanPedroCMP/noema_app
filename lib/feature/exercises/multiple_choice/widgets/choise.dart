import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart' show ChoiceData;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';

class Choise extends ConsumerStatefulWidget {
  const Choise({super.key, required this.choiseId, required this.onChanged, required this.mode});

  final ValueChanged<ChoiceData> onChanged;
  final String choiseId;
  final int mode;

  @override
  ConsumerState<Choise> createState() => _Choise();
}

class _Choise extends ConsumerState<Choise> {
  bool isCorrect = false;
  String statement = "";
  String? explanation = "";
  int? weight = 0;
  bool? aiGenerated = false;

  bool isChecked = false;

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

      widget.onChanged(
        ChoiceData(
          id: data.id,
          multipleChoiceId: data.multipleChoiceId,
          isCorrect: data.isCorrect,
          statement: data.statement,
          explanation: data.explanation,
          weight: data.weight,
          aiGenerated: data.aiGenerated,
          updatedAt: data.updatedAt,
          createdAt: data.createdAt,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          if (widget.mode == 0) ...[
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Text(statement),
          ],
          if (widget.mode == 1) ...[
            Checkbox(
              value: isCorrect,
              onChanged: (bool? value) {
                setState(() {
                  isCorrect = value!;
                });
              },
            ),
            Text(statement),
          ],
        ],
      ),
    );
  }
}
