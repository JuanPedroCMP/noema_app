import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/pages/create_graph_with_ai.dart';

void main() {
  test('explains when no active API key is configured', () {
    final request = RequestOptions(path: '/api/v1/ai_router/use_ai');
    final error = DioException(
      requestOptions: request,
      response: Response(
        requestOptions: request,
        statusCode: 422,
        data: {
          'detail':
              'No active API keys are configured for any model of this agent.',
        },
      ),
    );

    expect(
      graphGenerationApiErrorMessage(error),
      contains('Cadastre ou ative uma chave'),
    );
  });

  test('explains AI provider timeouts returned by the backend', () {
    final request = RequestOptions(path: '/api/v1/ai_router/use_ai');
    final error = DioException(
      requestOptions: request,
      response: Response(
        requestOptions: request,
        statusCode: 504,
        data: {'detail': 'AI generation timed out.'},
      ),
    );

    expect(
      graphGenerationApiErrorMessage(error),
      contains('excedeu o tempo limite'),
    );
  });

  test('shows the server graph-audit reason for rejected output', () {
    final request = RequestOptions(path: '/api/v1/ai_router/use_ai');
    final error = DioException(
      requestOptions: request,
      response: Response(
        requestOptions: request,
        statusCode: 422,
        data: {
          'detail':
              'The graph did not pass the server-side quality audit: '
              'missing_coverage_map',
        },
      ),
    );

    expect(
      graphGenerationApiErrorMessage(error),
      contains('missing_coverage_map'),
    );
  });

  test('explains which server generation stage failed', () {
    final request = RequestOptions(path: '/api/v1/ai_router/use_ai');
    final error = DioException(
      requestOptions: request,
      response: Response(
        requestOptions: request,
        statusCode: 502,
        data: {
          'detail': 'Graph planning stage failed for all configured AI models.',
        },
      ),
    );

    expect(
      graphGenerationApiErrorMessage(error),
      contains('planejamento do grafo'),
    );
  });
}
