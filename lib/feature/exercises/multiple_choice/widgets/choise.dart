import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart' show ChoiceData;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';

/// Parameters:
/// Mode
/// 1 - Do the exercice mode
/// 2 - Only read, show the correct response(s)
class Choise extends ConsumerStatefulWidget {
  const Choise({
    super.key,
    required this.choiseId,
    required this.onChanged,
    required this.mode,
    this.selected = false,
    this.onSelectionChanged,
    this.revealAnswer = false,
  });

  final ValueChanged<ChoiceData> onChanged;
  final String choiseId;
  final int mode;
  final bool selected;
  final ValueChanged<bool>? onSelectionChanged;
  final bool revealAnswer;

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
  ChoiceData? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadData();
    });
  }

  Future<void> loadData() async {
    if (widget.choiseId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = "Alternativa indisponível.";
        });
      }
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final choiseDao = ChoiceDao(db);
      final data = await choiseDao.getChoice(id: widget.choiseId);

      if (!mounted) return;

      if (data == null) {
        setState(() {
          _isLoading = false;
          _error = "Alternativa indisponível.";
        });
        return;
      }

      setState(() {
        _isLoading = false;
        _data = data;
        isCorrect = data.isCorrect;
        isChecked = data.isCorrect;
        statement = data.statement;
        explanation = data.explanation;
        weight = data.weight;
        aiGenerated = data.isAiGenerated;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = "Não foi possível carregar a alternativa.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ListTile(
        leading: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text("Carregando alternativa..."),
      );
    }
    if (_error != null) {
      return ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(_error!),
      );
    }
    if (widget.mode == 2) {
      final showStatus = widget.revealAnswer;
      final icon = !showStatus
          ? widget.selected
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded
          : isCorrect
          ? Icons.check_circle_rounded
          : widget.selected
          ? Icons.cancel_rounded
          : Icons.radio_button_unchecked_rounded;
      final color = showStatus
          ? isCorrect
                ? Theme.of(context).colorScheme.primary
                : widget.selected
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.outline
          : widget.selected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.outline;

      return Semantics(
        selected: widget.selected,
        child: InkWell(
          onTap: showStatus
              ? null
              : () => widget.onSelectionChanged?.call(!widget.selected),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statement),
                      if (showStatus &&
                          (explanation?.trim().isNotEmpty ?? false)) ...[
                        const SizedBox(height: 8),
                        Text(
                          explanation!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        if (widget.mode == 0) ...[
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false;
              });
              if (value != null) {
                final current = _data;
                if (current != null) {
                  widget.onChanged(current.copyWith(isCorrect: value));
                }
              }
            },
          ),
          Expanded(child: Text(statement)),
        ],
        if (widget.mode == 1) ...[
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isCorrect
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statement),
                if (explanation?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 6),
                  Text(
                    explanation!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
