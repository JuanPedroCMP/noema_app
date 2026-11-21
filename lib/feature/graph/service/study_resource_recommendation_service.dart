import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';

final studyResourceRecommendationServiceProvider =
    Provider<StudyResourceRecommendationService>(
      (ref) => StudyResourceRecommendationService(ref),
    );

class StudyResourceRecommendationService {
  StudyResourceRecommendationService(this._ref);

  final Ref _ref;

  Future<List<StudyResourceSuggestion>> recommend({
    required String nodeTitle,
    String? nodeDescription,
  }) async {
    final ai = _ref.read(aiContentGenerationServiceProvider);
    final agentId = await ai.resolveAgentId(AiAgentTask.recommendStudyResource);
    final responseLanguage = await _ref.read(
      aiResponseLanguageResolverProvider,
    )();
    final response = await _ref
        .read(apiClientProvider)
        .dio
        .post<dynamic>(
          '/api/v1/ai_router/get_materials',
          queryParameters: {
            'user_prompt':
                '''
Encontre materiais confiáveis e relevantes para estudar o conceito abaixo.
Priorize conteúdo didático, atual e específico; evite resultados duplicados.
Conceito: $nodeTitle
Descrição: ${nodeDescription?.trim().isNotEmpty == true ? nodeDescription : 'não informada'}
''',
            'agent_id': agentId,
            'get_videos': true,
            'get_books': true,
            'get_papers': true,
            'get_web': true,
          },
          options: Options(
            headers: responseLanguage == null
                ? null
                : {'X-Response-Language': responseLanguage},
            extra: {
              'secure': [
                {'type': 'oauth2', 'name': 'OAuth2PasswordBearer'},
              ],
            },
          ),
        );
    return parseSearchResults(response.data, nodeTitle: nodeTitle);
  }

  static List<StudyResourceSuggestion> parseSearchResults(
    Object? payload, {
    required String nodeTitle,
  }) {
    Object? papers;
    Object? videos;
    Object? books;
    Object? web;
    if (payload is List && payload.length >= 4) {
      papers = payload[0];
      videos = payload[1];
      books = payload[2];
      web = payload[3];
    } else if (payload is Map) {
      papers = payload['papers'];
      videos = payload['yt_videos'] ?? payload['videos'];
      books = payload['books'];
      web = payload['search_results'] ?? payload['web'];
    } else {
      throw const FormatException(
        'A API não retornou uma lista de fontes de estudo.',
      );
    }

    Map<String, dynamic>? asMap(Object? value) {
      if (value is! Map) return null;
      return {
        for (final entry in value.entries) entry.key.toString(): entry.value,
      };
    }

    List<Object?> asList(Object? value) =>
        value is List ? value.cast<Object?>() : const [];

    String? asText(Object? value) {
      if (value is! String || value.trim().isEmpty) return null;
      return value.trim();
    }

    double score(Object? value, {double fallback = 0.5}) {
      if (value is! num || !value.isFinite) return fallback;
      return value.toDouble().clamp(0.0, 1.0).toDouble();
    }

    String? asUrl(Object? value) {
      final raw = asText(value);
      if (raw == null) return null;
      var uri = Uri.tryParse(raw);
      if (uri != null && uri.scheme.isEmpty) {
        uri = Uri.tryParse('https://$raw');
      }
      if (uri == null ||
          !{'http', 'https'}.contains(uri.scheme) ||
          uri.host.isEmpty) {
        return null;
      }
      return uri.toString();
    }

    String? authorText(Object? value) {
      if (value is String) return asText(value);
      if (value is! List) return null;
      final authors = value
          .map((item) {
            if (item is String) return item.trim();
            return asText(asMap(item)?['name']) ?? '';
          })
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
      return authors.isEmpty ? null : authors.join(', ');
    }

    final suggestions = <StudyResourceSuggestion>[];
    final seenUrls = <String>{};

    void add({
      required String category,
      required Object? title,
      required Object? url,
      required String tier,
      required String rationale,
      Object? author,
      double relevanceScore = 0.5,
      double reputationScore = 0.5,
    }) {
      final normalizedTitle = asText(title);
      final normalizedUrl = asUrl(url);
      if (normalizedTitle == null || normalizedUrl == null) return;
      final urlKey = resourceUrlKey(normalizedUrl);
      if (!seenUrls.add(urlKey)) return;
      final summary = rationale.trim().isEmpty
          ? 'Relacionado ao conceito $nodeTitle.'
          : rationale.trim();
      suggestions.add(
        StudyResourceSuggestion(
          category: category,
          title: normalizedTitle,
          author: asText(author),
          url: normalizedUrl,
          tier: tier,
          rationale: summary.length <= 700
              ? summary
              : '${summary.substring(0, 697)}...',
          relevanceScore: relevanceScore,
          reputationScore: reputationScore,
        ),
      );
    }

    final paperContainer = asMap(papers);
    final paperItems = paperContainer?['data'] ?? papers;
    for (final item in asList(paperItems)) {
      final paper = asMap(item);
      if (paper == null) continue;
      final openAccessPdf = asMap(paper['openAccessPdf']);
      final externalIds = asMap(paper['externalIds']);
      final citationCount = paper['citationCount'];
      final citations = citationCount is num ? citationCount.toDouble() : 0.0;
      final isOpenAccess = paper['isOpenAccess'] == true;
      final doi = asText(externalIds?['DOI']);
      add(
        category: 'ACADEMIC_ARTICLE',
        title: paper['title'],
        url:
            paper['url'] ??
            openAccessPdf?['url'] ??
            (doi == null ? null : 'https://doi.org/$doi'),
        author: authorText(paper['authors']),
        tier: isOpenAccess || citations >= 50 ? 'TIER_1' : 'TIER_2',
        rationale:
            asText(paper['abstract']) ??
            'Artigo acadêmico relacionado ao conceito.',
        relevanceScore: 0.7,
        reputationScore: citations <= 0 ? 0.5 : citations / (citations + 100),
      );
    }

    for (final item in asList(videos)) {
      final video = asMap(item);
      if (video == null) continue;
      final snippet = asMap(video['snippet']);
      final videoId = asMap(video['id']);
      final id = videoId?['videoId'];
      add(
        category: 'VIDEO',
        title: snippet?['title'],
        url: id is String && id.trim().isNotEmpty
            ? 'https://www.youtube.com/watch?v=${id.trim()}'
            : null,
        author: snippet?['channelTitle'],
        tier: 'TIER_2',
        rationale:
            asText(snippet?['description']) ?? 'Vídeo relacionado ao conceito.',
        relevanceScore: 0.65,
      );
    }

    for (final item in asList(books)) {
      final book = asMap(item);
      if (book == null) continue;
      final volume = asMap(book['volumeInfo']);
      final access = asMap(book['accessInfo']);
      final rating = volume?['averageRating'];
      final numericRating = rating is num ? rating.toDouble() : null;
      add(
        category: 'BOOK',
        title: volume?['title'],
        url:
            volume?['previewLink'] ??
            volume?['infoLink'] ??
            access?['webReaderLink'],
        author: authorText(volume?['authors']),
        tier: numericRating != null && numericRating >= 4 ? 'TIER_1' : 'TIER_2',
        rationale:
            asText(volume?['description']) ?? 'Livro relacionado ao conceito.',
        relevanceScore: 0.65,
        reputationScore: numericRating == null
            ? 0.5
            : (numericRating / 5).clamp(0.0, 1.0).toDouble(),
      );
    }

    final webContainer = asMap(web);
    final webItems = webContainer?['results'] ?? web;
    for (final item in asList(webItems)) {
      final result = asMap(item);
      if (result == null) continue;
      add(
        category: 'WEB_ARTICLE',
        title: result['title'],
        url: result['url'],
        author: result['domain'],
        tier: 'TIER_2',
        rationale:
            asText(result['content']) ??
            'Material online relacionado ao conceito.',
        relevanceScore: score(result['score']),
      );
    }

    suggestions.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return suggestions.take(24).toList(growable: false);
  }

  static String resourceUrlKey(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '';
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) return trimmed;
    final path = uri.path.endsWith('/')
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
    return Uri(
      scheme: uri.scheme.toLowerCase(),
      userInfo: uri.userInfo,
      host: uri.host.toLowerCase(),
      port: uri.hasPort ? uri.port : null,
      path: path,
      query: uri.hasQuery ? uri.query : null,
    ).toString();
  }
}

class StudyResourceSuggestion {
  const StudyResourceSuggestion({
    required this.category,
    required this.title,
    required this.url,
    required this.tier,
    required this.rationale,
    required this.relevanceScore,
    required this.reputationScore,
    this.author,
  });

  final String category;
  final String title;
  final String? author;
  final String url;
  final String tier;
  final String rationale;
  final double relevanceScore;
  final double reputationScore;
}
