import 'package:flutter/material.dart';

const nodeTypes = <String>['AREA', 'TOPIC', 'CONCEPT', 'SUBCONCEPT'];
const skillTypes = <String>['MEMORIZE', 'APPLY', 'ANALYZE', 'CREATE'];
const resourceCategories = <String>[
  'BOOK',
  'ACADEMIC_ARTICLE',
  'DOCUMENTATION',
  'COURSE',
  'VIDEO',
  'WEB_ARTICLE',
  'TOOL',
  'EXERCISE',
  'PODCAST',
];
const resourceTiers = <String>['TIER_1', 'TIER_2', 'TIER_3'];

String nodeTypeLabel(String type) {
  return switch (type) {
    'AREA' => 'Área',
    'TOPIC' => 'Tópico',
    'CONCEPT' => 'Conceito',
    'SUBCONCEPT' => 'Subconceito',
    _ => type,
  };
}

String skillTypeLabel(String type) {
  return switch (type) {
    'MEMORIZE' => 'Memorizar',
    'APPLY' => 'Aplicar',
    'ANALYZE' => 'Analisar',
    'CREATE' => 'Criar',
    _ => type,
  };
}

String resourceCategoryLabel(String category) {
  return switch (category) {
    'BOOK' => 'Livro',
    'ACADEMIC_ARTICLE' => 'Artigo acadêmico',
    'DOCUMENTATION' => 'Documentação',
    'COURSE' => 'Curso',
    'VIDEO' => 'Vídeo',
    'WEB_ARTICLE' => 'Artigo web',
    'TOOL' => 'Ferramenta',
    'EXERCISE' => 'Exercício',
    'PODCAST' => 'Podcast',
    _ => category,
  };
}

String resourceTierLabel(String tier) {
  return switch (tier) {
    'TIER_1' => 'Essencial',
    'TIER_2' => 'Complementar',
    'TIER_3' => 'Extra',
    _ => tier,
  };
}

String masteryCodeFromScore(double? score) {
  if (score == null) return 'UNRATED';
  if (score < 0.25) return 'WEAK';
  if (score < 0.5) return 'PARTIAL';
  if (score < 0.75) return 'ADEQUATE';
  return 'STRONG';
}

String masteryLabel(double? score) {
  return switch (masteryCodeFromScore(score)) {
    'UNRATED' => 'Ainda não avaliado',
    'WEAK' => 'Fraco',
    'PARTIAL' => 'Parcial',
    'ADEQUATE' => 'Adequado',
    'STRONG' => 'Forte',
    _ => 'Ainda não avaliado',
  };
}

Color nodeTypeColor(ColorScheme colors, String type) {
  return switch (type) {
    'AREA' => colors.primary,
    'TOPIC' => colors.secondary,
    'CONCEPT' => colors.tertiary,
    'SUBCONCEPT' => colors.outline,
    _ => colors.primary,
  };
}
