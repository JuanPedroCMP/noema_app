import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

class GraphTransferService {
  const GraphTransferService._();

  static String safeFileName(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
    return normalized.isEmpty ? 'grafo-noema' : normalized;
  }

  static Future<String?> exportGraph({
    required AppDatabase db,
    required KnowledgeGraphData graph,
    required List<GraphNodeData> nodes,
    required List<GraphEdgeData> edges,
  }) async {
    final nodeIds = <String, int>{
      for (var index = 0; index < nodes.length; index++)
        nodes[index].id: index + 1,
    };
    final payload = <String, dynamic>{
      'graph_title': graph.title,
      'graph_description': graph.description ?? '',
      'nodes': [
        for (var index = 0; index < nodes.length; index++)
          {
            'node_id': index + 1,
            'title': nodes[index].title,
            'description': nodes[index].description ?? '',
            'type': nodes[index].type,
          },
      ],
      'edges': [
        for (final edge in edges)
          if (nodeIds.containsKey(edge.sourceNodeId) &&
              nodeIds.containsKey(edge.targetNodeId))
            {
              'source_node': nodeIds[edge.sourceNodeId],
              'target_node': nodeIds[edge.targetNodeId],
              'type': edge.type,
            },
      ],
    };
    final bytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert(payload),
    );
    final uri = await FilePicker.saveFile(
      fileName: '${safeFileName(graph.title)}.json',
      bytes: bytes,
      mimeType: 'application/json',
      dialogTitle: 'Exportar grafo',
    );
    return uri?.toString();
  }

  static Future<String?> importGraph({
    required AppDatabase db,
    required String userId,
  }) async {
    final file = await FilePicker.pickFile(
      dialogTitle: 'Importar grafo',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final jsonString = utf8.decode(bytes, allowMalformed: false);
    return importGraphFromJson(db: db, userId: userId, jsonString: jsonString);
  }
}
