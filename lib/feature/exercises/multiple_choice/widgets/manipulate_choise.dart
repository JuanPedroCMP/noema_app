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
    required this.multipleChoiceId,
    required this.onSave,
  });

  final ValueChanged<ChoiceData> onChanged;

  final String? choiseId;
  final String multipleChoiceId;

  final VoidCallback onSave;

  @override
  ConsumerState<ManipulateChoise> createState() => _Choise();
}

class _Choise extends ConsumerState<ManipulateChoise> {
  bool isCorrect = false;
  String statement = "";
  String? explanation = "";
  int? weight = 0;
  bool? aiGenerated = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadData();
    });
  }

  Future<void> loadData() async {
    final choiseId = widget.choiseId;
    if (choiseId == null || choiseId.isEmpty) {
      return;
    }

    final db = ref.read(appDatabaseProvider);

    final choiseDao = ChoiceDao(db);

    final data = await choiseDao.getChoice(id: choiseId);

    if (!mounted) return;

    if (data == null) return;

    setState(() {
      isCorrect = data.isCorrect;
      statement = data.statement;
      explanation = data.explanation;
      weight = data.weight;
      aiGenerated = data.isAiGenerated;
    });
    widget.onChanged(data);
    statementController.text = statement;
    explanationController.text = explanation ?? '';
    weightController.text = weight?.toString() ?? '';
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
      weight = int.tryParse(value);
    });
  }

  Future<void> save() async {
    if (statement.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe o texto da alternativa.")),
      );
      return;
    }
    if (weight != null && weight! < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O peso não pode ser negativo.")),
      );
      return;
    }
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final newQuestion = widget.choiseId == null || widget.choiseId!.isEmpty;
      final db = ref.read(appDatabaseProvider);
      final choiseDao = ChoiceDao(db);

      if (newQuestion) {
        await choiseDao.insertChoice(
          multipleChoiceId: widget.multipleChoiceId,
          isCorrect: isCorrect,
          statement: statement.trim(),
          explanation: explanation?.trim().isEmpty == true
              ? null
              : explanation?.trim(),
          weight: weight,
        );
      } else {
        await choiseDao.updateChoice(
          id: widget.choiseId!,
          isCorrect: isCorrect,
          statement: statement.trim(),
          explanation: explanation?.trim().isEmpty == true
              ? null
              : explanation?.trim(),
          weight: weight,
        );
      }
      if (mounted) widget.onSave();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Não foi possível salvar a alternativa.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  late final TextEditingController statementController =
      TextEditingController();
  late final TextEditingController explanationController =
      TextEditingController();
  late final TextEditingController weightController = TextEditingController();

  @override
  void dispose() {
    statementController.dispose();
    explanationController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: context.spacing.md,
        children: [
          TextField(
            onChanged: sChanged,
            controller: statementController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enunciado",
            ),
          ),
          TextField(
            onChanged: eChanged,
            controller: explanationController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Explicação",
            ),
          ),
          TextField(
            onChanged: wChanged,
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
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Alternativa correta"),
            value: isCorrect,
            onChanged: (value) => setState(() => isCorrect = value ?? false),
          ),
          FilledButton(
            onPressed: _isSaving ? null : save,
            child: Text(_isSaving ? "Salvando..." : "Salvar alternativa"),
          ),
        ],
      ),
    );
  }
}
