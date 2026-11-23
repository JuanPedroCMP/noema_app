import 'package:flutter/material.dart';
import 'package:noema/l10n/app_localizations.dart';

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

PageChrome chromeForPath(String path, AppLocalizations l10n) {
  final segments = Uri.parse(path).pathSegments;
  if (path == '/dashboard') {
    return PageChrome(
      title: l10n.dashboardTitle,
      subtitle: l10n.dashboardSubtitle,
      actions: const [],
      pageItens: const [],
    );
  }
  if (segments.isNotEmpty && segments.first == 'study-sessions') {
    final title = segments.length == 1
        ? l10n.studySessions
        : segments.last == 'create'
        ? l10n.createSessionTitle
        : segments.last == 'run'
        ? l10n.activeStudySessionTitle
        : l10n.studySession;
    return PageChrome(
      title: title,
      subtitle: segments.length == 1 ? l10n.studySessionsSubtitle : null,
      actions: const [],
      pageItens: const [],
    );
  }
  if (segments.isNotEmpty && segments.first == 'graphs') {
    if (segments.contains('flashcards')) {
      return PageChrome(
        title: l10n.nodeFlashcardsTitle,
        actions: const [],
        pageItens: const [],
      );
    }
    if (segments.contains('exercises')) {
      if (segments.last == 'responses') {
        return PageChrome(
          title: l10n.answerHistoryTitle,
          actions: const [],
          pageItens: const [],
        );
      }
      return PageChrome(
        title: l10n.exercisesTitle,
        actions: const [],
        pageItens: const [],
      );
    }
    return PageChrome(
      title: l10n.graphsTitle,
      subtitle: l10n.graphsSubtitle,
      actions: const [],
      pageItens: const [],
    );
  }

  if (path.startsWith('/notes')) {
    return PageChrome(
      title: l10n.notesTitle,
      subtitle: l10n.notesSubtitle,
      actions: const [],
      pageItens: const [],
    );
  }

  if (path.startsWith('/config')) {
    return PageChrome(
      title: l10n.settingsTitle,
      subtitle: l10n.settingsSubtitle,
      actions: const [],
      pageItens: const [],
    );
  }

  if (path == '/flashcards') {
    return PageChrome(
      title: l10n.flashcardsTitle,
      subtitle: 'Revise conceitos no seu ritmo',
      actions: const [],
      pageItens: const [],
    );
  }

  if (path == '/ai-queue') {
    return PageChrome(
      title: l10n.aiTaskQueue,
      subtitle: l10n.aiQueueSubtitle,
      actions: const [],
      pageItens: const [],
    );
  }

  return PageChrome(
    title: l10n.homeTitle,
    subtitle: l10n.homeSubtitle,
    actions: const [],
    pageItens: const [],
  );
}
