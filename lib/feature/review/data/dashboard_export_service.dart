import 'dart:convert';
import 'dart:typed_data';

import 'package:noema/feature/review/data/dashboard_ai_usage_service.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum DashboardExportFormat { csv, pdf, png }

class DashboardExportService {
  const DashboardExportService();

  Uint8List toCsv({
    required DomainDashboardSummary summary,
    required DashboardAiUsageSummary? aiUsage,
    required String scope,
    required String period,
    required Set<String> sections,
  }) {
    final rows = <List<Object?>>[
      ['Noema - Painel de aprendizagem'],
      ['Escopo', scope],
      ['Período', period],
      ['Métrica', 'Valor'],
      ['Grafos', summary.graphCount],
      ['Nós dominados', summary.masteredConcepts],
      ['Nós frágeis', summary.fragileConcepts],
      ['Nós sem avaliação', summary.unassessedConcepts],
      ['Domínio médio', summary.averageMastery],
      ['Revisões', summary.reviewCount],
      ['Taxa média de acertos', summary.averageAccuracy],
      ['Retenção média (FSRS)', summary.averageRetrievability],
      ['Intervalo médio agendado (dias)', summary.averageScheduledDays],
      ['Dias ativos de revisão', summary.activeReviewDays],
      ['Tempo de sessão (min)', summary.sessionMinutes],
      ['Sessões registradas', summary.sessionCount],
      ['Tempo de revisão (min)', summary.reviewMinutes],
    ];

    if (sections.contains('fsrs')) {
      rows
        ..add(const [])
        ..add(['Avaliações FSRS', 'Quantidade'])
        ..addAll([
          for (var rating = 1; rating <= 4; rating++)
            [_ratingLabel(rating), summary.ratingCounts[rating] ?? 0],
        ]);
    }
    if (sections.contains('evolution')) {
      rows
        ..add(const [])
        ..add(['Evolução do domínio'])
        ..add(['Data', 'Domínio médio'])
        ..addAll([
          for (final point in summary.recentProgress)
            [_dateKey(point.date), point.averageScore],
        ]);
    }
    if (sections.contains('reviews')) {
      rows
        ..add(const [])
        ..add(['Frequência e acertos'])
        ..add(['Data', 'Revisões', 'Taxa média de acertos']);
      rows.addAll([
        for (final point in summary.reviewFrequency)
          [
            _dateKey(point.date),
            point.reviewCount,
            point.averageAccuracy,
          ],
      ]);
    }
    if (sections.contains('graphs')) {
      rows
        ..add(const [])
        ..add(['Desempenho por grafo'])
        ..add(['Grafo', 'Nós', 'Domínio médio'])
        ..addAll([
          for (final graph in summary.graphPerformance)
            [graph.graphTitle, graph.nodeCount, graph.averageMastery],
        ]);
    }
    if (sections.contains('nodes')) {
      rows
        ..add(const [])
        ..add(['Desempenho por nó'])
        ..add(['Grafo', 'Nó', 'Domínio', 'Revisões', 'Taxa de acertos'])
        ..addAll([
          for (final node in summary.nodePerformance)
            [
              node.graphTitle,
              node.nodeTitle,
              node.masteryScore,
              node.reviewCount,
              node.averageAccuracy,
            ],
        ]);
    }
    if (sections.contains('activity')) {
      rows
        ..add(const [])
        ..add(['Atividade recente'])
        ..add(['Data', 'Grafo', 'Nó', 'Domínio', 'Origem', 'Tipo'])
        ..addAll([
          for (final activity in summary.recentActivity)
            [
              activity.loggedAt.toIso8601String(),
              activity.graphTitle,
              activity.nodeTitle,
              activity.score,
              activity.eventOrigin,
              activity.activityType,
            ],
        ]);
    }
    if (sections.contains('ai')) {
      rows
        ..add(const [])
        ..add(['Uso de IA'])
        ..add([
          'Chamadas',
          aiUsage == null ? 'Indisponível' : aiUsage.calls,
        ])
        ..add([
          'Tokens de entrada',
          aiUsage == null || aiUsage.callsWithInputTokenData == 0
              ? 'Indisponível'
              : aiUsage.inputTokens,
        ])
        ..add([
          'Tokens de saída',
          aiUsage == null || aiUsage.callsWithOutputTokenData == 0
              ? 'Indisponível'
              : aiUsage.outputTokens,
        ])
        ..add([
          'Tokens totais',
          aiUsage == null || aiUsage.callsWithTotalTokenData == 0
              ? 'Indisponível'
              : aiUsage.totalTokens,
        ])
        ..add([
          'Chamadas com dados de tokens',
          aiUsage?.callsWithTokenData ?? 'Indisponível',
        ])
        ..add([
          'Chamadas com tokens de entrada',
          aiUsage?.callsWithInputTokenData ?? 'Indisponível',
        ])
        ..add([
          'Chamadas com tokens de saída',
          aiUsage?.callsWithOutputTokenData ?? 'Indisponível',
        ])
        ..add([
          'Chamadas com tokens totais',
          aiUsage?.callsWithTotalTokenData ?? 'Indisponível',
        ]);
      if (aiUsage != null && aiUsage.modelCalls.isNotEmpty) {
        rows
          ..add(['Chamadas por modelo'])
          ..add(['Modelo', 'Chamadas'])
          ..addAll([
            for (final entry in aiUsage.modelCalls.entries)
              [entry.key, entry.value],
          ]);
      }
    }

    final csv = rows.map((row) => row.map(_csvCell).join(';')).join('\r\n');
    return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]);
  }

  Future<Uint8List> toPdf({
    required DomainDashboardSummary summary,
    required DashboardAiUsageSummary? aiUsage,
    required String scope,
    required String period,
    required Set<String> sections,
  }) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.indigo900,
              borderRadius: pw.BorderRadius.circular(14),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'NOEMA  /  INSIGHTS',
                  style: pw.TextStyle(
                    color: PdfColors.indigo100,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Painel de aprendizagem',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  '$scope  ·  $period',
                  style: const pw.TextStyle(
                    color: PdfColors.indigo100,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          _pdfSection('Visão geral', [
            ['Grafos', '${summary.graphCount}'],
            ['Nós no escopo', '${summary.nodePerformance.length}'],
            ['Nós dominados', '${summary.masteredConcepts}'],
            ['Nós frágeis', '${summary.fragileConcepts}'],
            ['Nós sem avaliação', '${summary.unassessedConcepts}'],
            ['Pré-requisitos críticos', '${summary.criticalPrerequisites}'],
            ['Domínio médio', _percent(summary.averageMastery)],
            ['Revisões', '${summary.reviewCount}'],
            ['Taxa média de acertos', _percent(summary.averageAccuracy)],
            ['Retenção FSRS média', _percent(summary.averageRetrievability)],
            [
              'Intervalo agendado médio',
              summary.averageScheduledDays == null
                  ? 'Sem dados'
                  : '${summary.averageScheduledDays!.toStringAsFixed(1)} dias',
            ],
            ['Sessões registradas', '${summary.sessionCount}'],
            ['Tempo de sessão', '${summary.sessionMinutes} min'],
            ['Tempo de revisão', '${summary.reviewMinutes} min'],
          ]),
          if (sections.contains('evolution'))
            _pdfSection('Evolução do domínio', _pdfRows([
              for (final point in summary.recentProgress)
                [
                  _dateKey(point.date),
                  _percent(point.averageScore),
                ],
            ])),
          if (sections.contains('reviews'))
            _pdfSection('Frequência e acertos', _pdfRows([
              for (final point in summary.reviewFrequency)
                [
                  _dateKey(point.date),
                  '${point.reviewCount} revisões',
                  'Acertos ${_percent(point.averageAccuracy)}',
                ],
            ])),
          if (sections.contains('fsrs'))
            _pdfSection('Métricas FSRS', [
              ['Retenção média estimada', _percent(summary.averageRetrievability)],
              [
                'Intervalo agendado médio',
                summary.averageScheduledDays == null
                    ? 'Sem dados'
                    : '${summary.averageScheduledDays!.toStringAsFixed(1)} dias',
              ],
              for (var rating = 1; rating <= 4; rating++)
                [
                  _ratingLabel(rating),
                  '${summary.ratingCounts[rating] ?? 0} revisões',
                ],
            ]),
          if (sections.contains('ai'))
            _pdfSection('Uso de IA', [
              [
                'Chamadas registradas',
                aiUsage == null ? 'Indisponível' : '${aiUsage.calls}',
              ],
              [
                'Tokens de entrada',
                (aiUsage?.callsWithInputTokenData ?? 0) == 0
                    ? 'Indisponível'
                    : '${aiUsage?.inputTokens ?? 0}',
              ],
              [
                'Tokens de saída',
                (aiUsage?.callsWithOutputTokenData ?? 0) == 0
                    ? 'Indisponível'
                    : '${aiUsage?.outputTokens ?? 0}',
              ],
              [
                'Tokens totais',
                (aiUsage?.callsWithTotalTokenData ?? 0) == 0
                    ? 'Indisponível'
                    : '${aiUsage?.totalTokens ?? 0}',
              ],
              if ((aiUsage?.unattributedCalls ?? 0) > 0)
                [
                  'Chamadas sem vínculo com este escopo',
                  '${aiUsage!.unattributedCalls}',
                ],
              if (aiUsage != null)
                for (final entry in aiUsage.modelCalls.entries)
                  [entry.key, '${entry.value} chamadas'],
            ]),
          if (sections.contains('graphs'))
            _pdfSection(
              'Desempenho por grafo',
              _pdfRows(summary.graphPerformance.map((graph) {
                return [
                  graph.graphTitle,
                  '${graph.nodeCount} nós',
                  _percent(graph.averageMastery),
                ];
              }).toList()),
            ),
          if (sections.contains('nodes'))
            _pdfSection(
              'Desempenho por nó',
              _pdfRows(summary.nodePerformance.map((node) {
                return [
                  node.nodeTitle,
                  node.graphTitle,
                  _percent(node.masteryScore),
                  '${node.reviewCount} revisões',
                ];
              }).toList()),
            ),
          if (sections.contains('activity'))
            _pdfSection(
              'Atividade recente',
              _pdfRows(summary.recentActivity.map((activity) {
                return [
                  activity.loggedAt.toLocal().toString(),
                  activity.nodeTitle,
                  '${activity.graphTitle} · ${_percent(activity.score)}',
                ];
              }).toList()),
            ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Métricas de IA refletem somente os dados fornecidos pela API; '
            'tokens não informados não são estimados.',
            style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 9),
          ),
        ],
      ),
    );
    return Uint8List.fromList(await document.save());
  }

  pw.Widget _pdfSection(String title, List<List<String>> rows) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 14),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.indigo900,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        if (rows.isEmpty)
          pw.Text('Sem dados neste período.')
        else
          pw.Column(
            children: [
              for (final row in rows)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey300),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      for (var index = 0; index < row.length; index++)
                        pw.Expanded(
                          flex: index == 0 ? 2 : 1,
                          child: pw.Text(
                            row[index],
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    ),
  );

  List<List<String>> _pdfRows(List<List<String>> rows) {
    const maxRows = 24;
    if (rows.length <= maxRows) return rows;
    return [
      ...rows.take(maxRows - 1),
      [
        '...',
        'PDF limitado a $maxRows linhas; use o CSV para os dados completos.',
      ],
    ];
  }

  String _csvCell(Object? value) {
    var text = switch (value) {
      null => '',
      double number when number.isFinite => number.toStringAsFixed(4),
      _ => value.toString(),
    };
    if (value is String && RegExp(r'^[=+\-@]').hasMatch(text)) {
      text = "'$text";
    }
    return '"${text.replaceAll('"', '""')}"';
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  String _percent(double? value) =>
      value == null ? 'Sem dados' : '${(value * 100).round()}%';

  String _ratingLabel(int rating) => switch (rating) {
    1 => 'Novamente',
    2 => 'Difícil',
    3 => 'Bom',
    4 => 'Fácil',
    _ => 'Desconhecido',
  };
}
