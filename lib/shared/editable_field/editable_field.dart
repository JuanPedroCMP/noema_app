import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

class EditableField extends StatefulWidget {
  const EditableField({
    super.key,
    required this.inputLabel,
    required this.onChanged,
    required this.onConfirm,
    required this.onCancel,
    this.displayLabel,
    required this.display,
  });

  final String inputLabel;
  final ValueChanged<String> onChanged;
  final FutureOr<void> Function() onConfirm;
  final FutureOr<void> Function() onCancel;
  final Widget? displayLabel;
  final Widget display;

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool isEditing = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing.sm;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!isEditing) {
          return Row(
            spacing: spacing,
            children: [
              if (widget.displayLabel case final label?)
                Flexible(
                  flex: 2,
                  child: DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: label,
                  ),
                ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: widget.display,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => setState(() => isEditing = true),
                icon: const Icon(Icons.edit),
                label: Text("Editar", style: context.textTheme.labelMedium),
              ),
            ],
          );
        }

        final field = TextField(
          onChanged: widget.onChanged,
          controller: _controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.inputLabel,
          ),
        );
        final actions = Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                await widget.onConfirm();
                if (mounted) setState(() => isEditing = false);
              },
              icon: const Icon(Icons.save_rounded),
              label: Text("Salvar", style: context.textTheme.labelMedium),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                await widget.onCancel();
                if (mounted) setState(() => isEditing = false);
              },
              icon: const Icon(Icons.cancel),
              label: Text("Cancelar", style: context.textTheme.labelMedium),
            ),
          ],
        );

        if (constraints.maxWidth < 560) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacing,
            children: [field, actions],
          );
        }

        return Row(
          spacing: spacing,
          children: [
            Expanded(child: field),
            actions,
          ],
        );
      },
    );
  }
}
