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
    required this.onCancel,
  });

  final ValueChanged<ChoiceData> onChanged;

  final String? choiseId;
  final String multipleChoiceId;

  final VoidCallback onSave;
  final VoidCallback onCancel;

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
  bool _isLoading = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();

    _isLoading = widget.choiseId?.isNotEmpty == true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadData();
    });
  }

  Future<void> loadData() async {
    final choiseId = widget.choiseId;
    if (choiseId == null || choiseId.isEmpty) {
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final data = await ChoiceDao(db).getChoice(id: choiseId);
      if (!mounted) return;
      if (data == null) {
        setState(() {
          _isLoading = false;
          _loadError = 'Alternativa não encontrada ou removida.';
        });
        return;
      }

      setState(() {
        _isLoading = false;
        _loadError = null;
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
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Não foi possível carregar a alternativa.';
      });
    }
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
    if (weightController.text.trim().isNotEmpty && weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe um peso numérico válido.")),
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
          const SnackBar(
            content: Text("Não foi possível salvar a alternativa."),
          ),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_loadError!, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Fechar'),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _loadError = null;
                  });
                  loadData();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ],
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: Column(
          spacing: context.spacing.md,
          children: [
            TextField(
              onChanged: sChanged,
              controller: statementController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Alternativa",
              ),
            ),
            TextField(
              onChanged: eChanged,
              controller: explanationController,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Explicação (opcional)",
              ),
            ),
            TextField(
              onChanged: wChanged,
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Peso (opcional)",
              ),
            ),
            Text(
              "Use o peso para ajustar a pontuação atribuída a esta alternativa.",
              style: context.textTheme.labelSmall,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Alternativa correta"),
              value: isCorrect,
              onChanged: (value) => setState(() => isCorrect = value ?? false),
            ),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: _isSaving ? null : widget.onCancel,
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: _isSaving ? null : save,
                  child: Text(_isSaving ? "Salvando..." : "Salvar alternativa"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
