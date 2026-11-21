import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/service/study_resource_recommendation_service.dart';

void main() {
  test('parses papers, videos, books, and web results from the API tuple', () {
    final suggestions = StudyResourceRecommendationService.parseSearchResults([
      {
        'data': [
          {
            'title': 'Cell Biology',
            'url': 'https://example.org/paper',
            'abstract': 'An academic resource.',
            'authors': [
              {'name': 'A. Author'},
            ],
            'citationCount': 80,
            'isOpenAccess': true,
          },
        ],
      },
      [
        {
          'id': {'videoId': 'video-id'},
          'snippet': {
            'title': 'Cell biology explained',
            'channelTitle': 'Learning Channel',
            'description': 'A video resource.',
          },
        },
      ],
      [
        {
          'volumeInfo': {
            'title': 'A Guide to Cells',
            'authors': ['B. Author'],
            'previewLink': 'https://books.example/preview',
            'averageRating': 4.5,
            'description': 'A book resource.',
          },
        },
      ],
      {
        'results': [
          {
            'title': 'Cell biology introduction',
            'url': 'https://web.example/article',
            'content': 'A web resource.',
            'score': 0.92,
          },
        ],
      },
    ], nodeTitle: 'Cell biology');

    expect(suggestions, hasLength(4));
    expect(suggestions.map((suggestion) => suggestion.category).toSet(), {
      'ACADEMIC_ARTICLE',
      'VIDEO',
      'BOOK',
      'WEB_ARTICLE',
    });
    expect(
      suggestions.singleWhere((item) => item.category == 'VIDEO').url,
      'https://www.youtube.com/watch?v=video-id',
    );
    expect(
      suggestions.singleWhere((item) => item.category == 'BOOK').author,
      'B. Author',
    );
    expect(
      suggestions
          .singleWhere((item) => item.category == 'ACADEMIC_ARTICLE')
          .tier,
      'TIER_1',
    );
    expect(suggestions.first.relevanceScore, 0.92);
  });

  test('drops unusable links, duplicate URLs, and caps suggestions', () {
    final suggestions = StudyResourceRecommendationService.parseSearchResults([
      {
        'data': [
          {'title': 'No link'},
          {
            'title': 'First result',
            'url': 'https://example.org/item/',
            'isOpenAccess': true,
          },
        ],
      },
      const [],
      const [],
      {
        'results': [
          {
            'title': 'Duplicate result',
            'url': 'https://example.org/item',
            'content': 'Duplicate URL.',
            'score': 0.99,
          },
        ],
      },
    ], nodeTitle: 'Cell biology');

    expect(suggestions, hasLength(1));
    expect(suggestions.single.title, 'First result');
  });

  test('reports an unsupported response shape', () {
    expect(
      () => StudyResourceRecommendationService.parseSearchResults(
        'invalid',
        nodeTitle: 'Cell biology',
      ),
      throwsFormatException,
    );
  });

  test('normalizes URL hosts without changing case-sensitive paths', () {
    expect(
      StudyResourceRecommendationService.resourceUrlKey(
        'HTTPS://Example.org/Case/',
      ),
      'https://example.org/Case',
    );
    expect(
      StudyResourceRecommendationService.resourceUrlKey(
        'https://example.org/case',
      ),
      'https://example.org/case',
    );
  });
}
