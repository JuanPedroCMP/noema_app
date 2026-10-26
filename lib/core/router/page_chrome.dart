import 'package:flutter/material.dart';

class PageChrome {
  final String title;
  final List<Widget> actions;
  final List<Widget> pageItens;

  const PageChrome({
    required this.title,
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
    return PageChrome(title: title, actions: const [], pageItens: const []);
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
    return PageChrome(title: 'Grafos', actions: const [], pageItens: const []);
  }

  if (path.startsWith('/notes')) {
    return PageChrome(title: "Notas", actions: const [], pageItens: const []);
  }

  if (path.startsWith('/config')) {
    return PageChrome(
      title: "Configuração",
      actions: const [],
      pageItens: const [],
    );
  }

  if (path == '/flashcards') {
    return PageChrome(
      title: 'Flashcards',
      actions: const [],
      pageItens: const [],
    );
  }

  return PageChrome(title: "Início", actions: const [], pageItens: const []);
}
