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
    return !isEditing
        ? Row(
            spacing: context.spacing.sm,
            children: [
              ?widget.displayLabel,
              widget.display,
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    Text("Editar", style: context.textTheme.labelMedium),
                  ],
                ),
              ),
            ],
          )
        : Row(
            spacing: context.spacing.sm,
            children: [
              Expanded(
                child: TextField(
                  onChanged: widget.onChanged,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: widget.inputLabel,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await widget.onConfirm();
                  setState(() {
                    isEditing = false;
                  });
                },

                child: Row(
                  children: [
                    Icon(Icons.save_rounded),
                    Text("Salvar", style: context.textTheme.labelMedium),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await widget.onCancel();
                  setState(() {
                    isEditing = false;
                  });
                },

                child: Row(
                  children: [
                    Icon(Icons.cancel),
                    Text("Cancelar", style: context.textTheme.labelMedium),
                  ],
                ),
              ),
            ],
          );
  }
}
