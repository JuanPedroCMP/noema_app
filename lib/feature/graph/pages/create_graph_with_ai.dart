import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGraphWithAi extends ConsumerStatefulWidget {
  const CreateGraphWithAi({super.key});

  @override
  ConsumerState<CreateGraphWithAi> createState() => _CreateGraphWithAiState();
}

class _CreateGraphWithAiState extends ConsumerState<CreateGraphWithAi> {
  final _promptController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _showComingSoon() {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descreva o assunto do grafo primeiro.')),
      );
      return;
    }
    setState(() => _isGenerating = true);
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A geração por IA estará disponível em breve.'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descreva o que você quer aprender e a IA criará uma estrutura inicial para você.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _promptController,
          maxLines: 4,
          maxLength: 500,
          decoration: const InputDecoration(
            labelText: 'Tema do grafo',
            hintText: 'Ex.: Quero aprender machine learning do zero',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.auto_awesome),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isGenerating ? null : _showComingSoon,
            icon: _isGenerating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_isGenerating ? 'Preparando...' : 'Gerar estrutura'),
          ),
        ),
      ],
    );
  }
}
