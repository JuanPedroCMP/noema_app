import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/router/route_paths.dart';

void main() {
  test('builds a node-scoped dashboard route', () {
    final uri = Uri.parse(RoutePaths.dashboardForNode('graph-1', 'node-1'));

    expect(uri.path, RoutePaths.dashboard);
    expect(uri.queryParameters['scope'], 'node');
    expect(uri.queryParameters['graphId'], 'graph-1');
    expect(uri.queryParameters['nodeId'], 'node-1');
  });

  test('builds the selected node exercise-history route', () {
    expect(
      RoutePaths.exerciseResponses('graph-1', 'node-1'),
      '/graphs/graph-1/exercises/node-1/responses',
    );
  });
}
