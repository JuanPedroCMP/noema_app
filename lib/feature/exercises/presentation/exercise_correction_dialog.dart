import 'package:dio/dio.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:flutter/material.dart';

class ExerciseCorrectionDraft {
  const ExerciseCorrectionDraft({
    required this.feedback,
    required this.notes,
    required this.score,
    required this.mastery,
    required this.rating,
    required this.usedAi,
  });

  final String feedback;
  final String notes;
  final double score;
  final String mastery;
  final fsrs.Rating rating;
  final bool usedAi;
}

class ExerciseCorrectionDialog extends StatefulWidget {
  const ExerciseCorrectionDialog({
    super.key,
    required this.title,
    required this.initialFeedback,
    required this.initialNotes,
    required this.initialScore,
    required this.initialMastery,
    required this.initialRating,
    required this.onAiCorrection,
  });

  final String title;
  final String? initialFeedback;
  final String? initialNotes;
  final double? initialScore;
  final String? initialMastery;
  final fsrs.Rating initialRating;
  final Future<Map<String, dynamic>> Function() onAiCorrection;

  @override
  State<ExerciseCorrectionDialog> createState() =>
      _ExerciseCorrectionDialogState();
}

class _ExerciseCorrectionDialogState extends State<ExerciseCorrectionDialog> {
  late final TextEditingController _feedback;
  late final TextEditingController _notes;
  late double _score;
  late fsrs.Rating _rating;
  late String _mastery;
  bool _isGenerating = false;
  bool _usedAi = false;

  @override
  void initState() {
    super.initState();
    _feedback = TextEditingController(text: widget.initialFeedback);
    _notes = TextEditingController(text: widget.initialNotes);
    _score = (widget.initialScore ?? 0.5).clamp(0, 1);
    _rating = widget.initialRating;
    _mastery = switch (widget.initialMastery?.toUpperCase()) {
      'WEAK' => 'WEAK',
      'PARTIAL' => 'PARTIAL',
      'STRONG' => 'STRONG',
      _ => 'ADEQUATE',
    };
  }

  @override
  void dispose() {
    _feedback.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _generateCorrection() async {
    if (_isGenerating) return;
    setState(() => _isGenerating = true);
    try {
      final result = await widget.onAiCorrection();
      if (!mounted) return;

      final feedback =
          result['feedback'] ??
          result['ai_feedback'] ??
          result['explanation'] ??
          result['comment'];
      if (feedback is! String || feedback.trim().isEmpty) {
        throw const FormatException(
          'A resposta não trouxe um campo de feedback válido.',
        );
      }

      final rawScore = result['score'] ?? result['grade'] ?? result['weight'];
      double? score;
      if (rawScore is num && rawScore.isFinite) {
        score = rawScore.toDouble();
        if (score > 1) score /= 100;
      }
      if (score == null || score < 0 || score > 1) {
        throw const FormatException(
          'A resposta não trouxe uma nota entre 0 e 1.',
        );
      }

      final mastery =
          (result['mastery_demonstrated'] ?? result['mastery'] ?? 'ADEQUATE')
              .toString()
              .toUpperCase();
      setState(() {
        _feedback.text = feedback.trim();
        _score = score!;
        _mastery = switch (mastery) {
          'WEAK' => 'WEAK',
          'PARTIAL' => 'PARTIAL',
          'STRONG' => 'STRONG',
          _ => 'ADEQUATE',
        };
        _rating = _ratingForScore(_score);
        _usedAi = true;
      });
    } on DioException catch (error) {
      if (!mounted) return;
      final statusCode = error.response?.statusCode;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              statusCode == null
                  ? 'Não foi possível conectar ao serviço de correção.'
                  : 'A correção falhou (HTTP $statusCode).',
            ),
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Não foi possível aplicar a correção: $error'),
          ),
        );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  fsrs.Rating _ratingForScore(double score) {
    if (score < 0.25) return fsrs.Rating.again;
    if (score < 0.6) return fsrs.Rating.hard;
    if (score < 0.9) return fsrs.Rating.good;
    return fsrs.Rating.easy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Revisar resposta'),
      content: SizedBox(
        width: 600,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.65,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(widget.title, style: theme.textTheme.titleMedium),
                OutlinedButton.icon(
                  onPressed: _isGenerating ? null : _generateCorrection,
                  icon: _isGenerating
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    _isGenerating
                        ? 'Analisando resposta...'
                        : 'Corrigir com IA',
                  ),
                ),
                TextField(
                  controller: _feedback,
                  onChanged: (_) => setState(() {}),
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Feedback da correção',
                    hintText: 'Explique acertos, lacunas e próximos passos.',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                Text(
                  'Nota: ${(_score * 100).round()}%',
                  style: theme.textTheme.titleSmall,
                ),
                Slider(
                  value: _score,
                  min: 0,
                  max: 1,
                  divisions: 20,
                  label: '${(_score * 100).round()}%',
                  onChanged: (value) => setState(() => _score = value),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _mastery,
                  decoration: const InputDecoration(
                    labelText: 'Domínio demonstrado',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'WEAK', child: Text('Inicial')),
                    DropdownMenuItem(value: 'PARTIAL', child: Text('Parcial')),
                    DropdownMenuItem(
                      value: 'ADEQUATE',
                      child: Text('Adequado'),
                    ),
                    DropdownMenuItem(value: 'STRONG', child: Text('Forte')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _mastery = value);
                  },
                ),
                DropdownButtonFormField<fsrs.Rating>(
                  initialValue: _rating,
                  decoration: const InputDecoration(
                    labelText: 'Agendamento FSRS',
                    helperText:
                        'Escolha como foi a recordação para calcular o próximo intervalo.',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: fsrs.Rating.again,
                      child: Text('De novo — esqueci'),
                    ),
                    DropdownMenuItem(
                      value: fsrs.Rating.hard,
                      child: Text('Difícil — muito esforço'),
                    ),
                    DropdownMenuItem(
                      value: fsrs.Rating.good,
                      child: Text('Bom — lembrei com esforço'),
                    ),
                    DropdownMenuItem(
                      value: fsrs.Rating.easy,
                      child: Text('Fácil — lembrei imediatamente'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _rating = value);
                  },
                ),
                TextField(
                  controller: _notes,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Anotações pessoais (opcional)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                Text(
                  _usedAi
                      ? 'A sugestão da IA pode ser editada antes de salvar.'
                      : 'A correção manual também atualiza o agendamento FSRS.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isGenerating ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _isGenerating || _feedback.text.trim().isEmpty
              ? null
              : () => Navigator.pop(
                  context,
                  ExerciseCorrectionDraft(
                    feedback: _feedback.text.trim(),
                    notes: _notes.text.trim(),
                    score: _score,
                    mastery: _mastery,
                    rating: _rating,
                    usedAi: _usedAi,
                  ),
                ),
          icon: const Icon(Icons.save_outlined),
          label: const Text('Salvar revisão'),
        ),
      ],
    );
  }
}
