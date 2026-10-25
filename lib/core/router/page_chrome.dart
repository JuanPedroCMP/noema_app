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

  return PageChrome(title: "Início", actions: const [], pageItens: const []);
}
