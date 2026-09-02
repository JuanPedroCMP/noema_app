import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart' show ChoiceData;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';

class ManipulateChoise extends ConsumerStatefulWidget {
  const ManipulateChoise({
    super.key,
    this.choiseId,
    required this.onChanged,
    required this.multipleChoiceId, required this.onSave,
  });

  final ValueChanged<ChoiceData> onChanged;

  final String? choiseId;
  final String multipleChoiceId;

  final Function onSave;

  @override
  ConsumerState<ManipulateChoise> createState() => _Choise();
}

class _Choise extends ConsumerState<ManipulateChoise> {
  bool isCorrect = false;
  String statement = "";
  String? explanation = "";
  int? weight = 0;
  bool? aiGenerated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadData();
    });
  }

  void loadData() async {
    if (widget.choiseId == null) {
      return;
    }

    if (widget.choiseId!.isEmpty) {
      return;
    }

    final db = ref.watch(appDatabaseProvider);

    final choiseDao = ChoiceDao(db);

    final data = await choiseDao.getChoice(id: widget.choiseId!);

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

  void sChanged(String value) {
    setState(() {
      statement = value;
    });
  }

  void eChanged(String value) {
    setState(() {
      explanation = value;
    });
  }

  void wChanged(String value) {
    setState(() {
      weight = int.parse(value);
    });
  }

  void save() async {
    bool newQuestion = false;

    if (widget.choiseId == null) {
      newQuestion = true;
    }

    if (widget.choiseId!.isEmpty) {
      newQuestion = true;
    }

    final db = ref.watch(appDatabaseProvider);

    final choiseDao = ChoiceDao(db);

    if (newQuestion) {
      choiseDao.insertChoice(
        multipleChoiceId: widget.multipleChoiceId,
        isCorrect: isCorrect,
        statement: statement,
        explanation: explanation,
        weight: weight,
      );
    } else {
      choiseDao.updateChoice(
        id: widget.choiseId!,
        isCorrect: isCorrect,
        statement: statement,
        explanation: explanation,
        weight: weight,
      );
    }
  }

  late TextEditingController statementController;
  late TextEditingController explanationController;
  late TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    statementController = TextEditingController(text: statement);
    explanationController = TextEditingController(text: explanation);
    weightController = TextEditingController(text: weight.toString());

    return Center(
      child: Column(
        spacing: context.spacing.md,
        children: [
          TextField(
            onChanged: (value) => sChanged,
            controller: statementController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enunciado",
            ),
          ),
          TextField(
            onChanged: (value) => eChanged,
            controller: explanationController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Explicação",
            ),
          ),
          TextField(
            onChanged: (value) => wChanged,
            controller: weightController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Peso",
            ),
          ),
          Text(
            "Peso define o quanto a nota vai ser alterada caso essa questão seja marcada como correta ou errada",
            style: context.textTheme.labelSmall,
          ),
          Checkbox(
            value: isCorrect,
            onChanged: (bool? value) {
              setState(() {
                isCorrect = value!;
              });
            },
          ),
          OutlinedButton(
            onPressed: () {
              save();
              widget.onSave();
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }
}
