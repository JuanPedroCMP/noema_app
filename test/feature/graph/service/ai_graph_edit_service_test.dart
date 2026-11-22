import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/service/ai_graph_edit_service.dart';

void main() {
  test(
    'edit prompt sends compact graph and requests only patch operations',
    () {
      final prompt = AiGraphEditService.buildPatchPrompt(
        instruction: 'Adicione o conceito de clorofila.',
        graph: const {
          'nodes': [
            {'id': 1, 'title': 'Fotossíntese'},
          ],
          'edges': [
            {
              'id': 1,
              'source_node': 1,
              'target_node': 2,
              'type': 'SUBTOPIC',
              'weight': 1.0,
            },
          ],
        },
      );

      expect(prompt, startsWith('MODE: EDIT'));
      expect(prompt, contains('"delete_nodes":[]'));
      expect(prompt, contains('"new_1"'));
      expect(prompt, contains('"source_node":1'));
      expect(prompt, contains(jsonEncode({'id': 1, 'title': 'Fotossíntese'})));
      expect(prompt, contains('Não gere descrições'));
    },
  );
}
