import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';

class GraphUtilsLayer extends ConsumerStatefulWidget {
  GraphUtilsLayer({super.key});

  @override
  ConsumerState<GraphUtilsLayer> createState() => _GraphUtilsLayer();
}

class _GraphUtilsLayer extends ConsumerState<GraphUtilsLayer> {
  bool isEditing = false;

  void alternateEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final graphStatesNotifier = ref.watch(graphStatesProvider.notifier);
    final graphStates = ref.watch(graphStatesProvider);

    return Row(
      spacing: context.spacing.lg,
      children: [
        if (graphStates.isEditing) ...[
          OutlinedButton(
            onPressed: () {
              graphStatesNotifier.isCreatingNodeChanged(!graphStates.isCreatingNode);
            },
            child: Icon(Icons.add, size: context.iconSize.md),
          ),

          OutlinedButton(
            onPressed: () {
              graphStatesNotifier.isCreatingEdgeChanged(!graphStates.isCreatingEdge);
            },
            child: Icon(Icons.line_axis, size: context.iconSize.md),
          ),

          OutlinedButton(
            onPressed: () {},
            child: Icon(Icons.delete, size: context.iconSize.md),
          ),
        ],
        if(!graphStates.isEditing) ...[

          OutlinedButton(
            onPressed: () {
              graphStatesNotifier.isEditingChanged(!graphStates.isEditing);
            },
            child: Icon(Icons.edit, size: context.iconSize.md),
          ),

          OutlinedButton(
            onPressed: () {},
            child: Icon(Icons.auto_awesome_mosaic, size: context.iconSize.md),
          ),
        ]
      ],
    );
  }
}
