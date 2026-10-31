import 'package:flutter/material.dart';

class PageChrome {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> pageItens;

  const PageChrome({
    required this.title,
    this.subtitle,
    required this.actions,
    required this.pageItens,
  });
}

PageChrome chromeForPath(String path) {
  final segments = Uri.parse(path).pathSegments;
  if (segments.isNotEmpty && segments.first == 'study-sessions') {
    final title = segments.length == 1
        ? 'Sessões de estudo'
        : segments.last == 'create'
        ? 'Criar sessão'
        : segments.last == 'run'
        ? 'Sessão em andamento'
        : 'Sessão de estudo';
    return PageChrome(
      title: title,
      subtitle: segments.length == 1
          ? 'Planeje e acompanhe seu progresso'
          : null,
      actions: const [],
      pageItens: const [],
    );
  }
  if (segments.isNotEmpty && segments.first == 'graphs') {
    if (segments.contains('flashcards')) {
      return PageChrome(
        title: 'Flashcards do nó',
        actions: const [],
        pageItens: const [],
      );
    }
    if (segments.contains('exercises')) {
      if (segments.last == 'responses') {
        return PageChrome(
          title: 'Histórico de respostas',
          actions: const [],
          pageItens: const [],
        );
      }
      return PageChrome(
        title: 'Exercícios',
        actions: const [],
        pageItens: const [],
      );
    }
    return PageChrome(
      title: 'Grafos',
      subtitle: 'Conecte ideias e explore conceitos',
      actions: const [],
      pageItens: const [],
    );
  }

  if (path.startsWith('/notes')) {
    return PageChrome(
      title: 'Notas',
      subtitle: 'Organize suas ideias e materiais',
      actions: const [],
      pageItens: const [],
    );
  }

  if (path.startsWith('/config')) {
    return PageChrome(
      title: 'Configuração',
      subtitle: 'Personalize sua experiência no Noema',
      actions: const [],
      pageItens: const [],
    );
  }

  if (path == '/flashcards') {
    return PageChrome(
      title: 'Flashcards',
      subtitle: 'Revise conceitos no seu ritmo',
      actions: const [],
      pageItens: const [],
    );
  }

  if (path == '/ai-queue') {
    return PageChrome(
      title: 'Fila de IA',
      subtitle: 'Acompanhe tarefas em segundo plano',
      actions: const [],
      pageItens: const [],
    );
  }

  return PageChrome(
    title: 'Início',
    subtitle: 'Seu espaço de aprendizagem',
    actions: const [],
    pageItens: const [],
  );
}
