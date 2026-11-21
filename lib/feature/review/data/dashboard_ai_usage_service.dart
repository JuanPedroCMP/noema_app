import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';
import 'package:openapi/openapi.dart';

class DashboardAiUsageSummary {
  const DashboardAiUsageSummary({
    required this.calls,
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
    required this.callsWithTokenData,
    required this.callsWithInputTokenData,
    required this.callsWithOutputTokenData,
    required this.callsWithTotalTokenData,
    required this.unattributedCalls,
    required this.modelCalls,
  });

  final int calls;
  final int inputTokens;
  final int outputTokens;
  final int totalTokens;
  final int callsWithTokenData;
  final int callsWithInputTokenData;
  final int callsWithOutputTokenData;
  final int callsWithTotalTokenData;
  final int unattributedCalls;
  final Map<String, int> modelCalls;
}

class DashboardAiUsageService {
  const DashboardAiUsageService(this._api);

  final AiUsageLogApi _api;

  Future<DashboardAiUsageSummary> load({
    required String remoteUserId,
    required DomainDashboardQuery query,
  }) async {
    final response = await _api.listAgentModelApiV1AiAiUsageLogListGet(
      idUser: remoteUserId,
    );
    return summarize(response.data?.toList() ?? const [], query: query);
  }

  DashboardAiUsageSummary summarize(
    List<AiUsageLogOut> logs, {
    required DomainDashboardQuery query,
  }) {
    var calls = 0;
    var inputTokens = 0;
    var outputTokens = 0;
    var totalTokens = 0;
    var callsWithTokenData = 0;
    var callsWithInputTokenData = 0;
    var callsWithOutputTokenData = 0;
    var callsWithTotalTokenData = 0;
    var unattributedCalls = 0;
    final modelCalls = <String, int>{};

    for (final log in logs) {
      if (!_matchesPeriod(log, query)) continue;
      final details = _asMap(log.usageDetails);
      final graphId = _findString(details, const {
        'graphid',
        'knowledgegraphid',
      });
      final nodeId = _findString(details, const {'nodeid'});
      final filteredByScope = query.graphId != null || query.nodeId != null;
      if (filteredByScope) {
        if (query.nodeId != null) {
          if (nodeId == null) {
            unattributedCalls++;
            continue;
          }
          if (nodeId != query.nodeId) continue;
        } else if (graphId == null) {
          unattributedCalls++;
          continue;
        } else if (graphId != query.graphId) {
          continue;
        }
      }

      calls++;
      modelCalls.update(
        log.idAgentModel,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      final input = _findNumber(details, const {
        'inputtokens',
        'inputtokencount',
        'prompttokens',
        'prompttokencount',
      });
      final output = _findNumber(details, const {
        'outputtokens',
        'outputtokencount',
        'completiontokens',
        'completiontokencount',
      });
      final total = _findNumber(details, const {
        'totaltokens',
        'totaltokencount',
        'tokencount',
      });
      if (input != null || output != null || total != null) {
        callsWithTokenData++;
        if (input != null) {
          callsWithInputTokenData++;
          inputTokens += input;
        }
        if (output != null) {
          callsWithOutputTokenData++;
          outputTokens += output;
        }
        if (total != null) {
          callsWithTotalTokenData++;
          totalTokens += total;
        } else if (input != null || output != null) {
          callsWithTotalTokenData++;
          totalTokens += (input ?? 0) + (output ?? 0);
        }
      }
    }

    return DashboardAiUsageSummary(
      calls: calls,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      totalTokens: totalTokens,
      callsWithTokenData: callsWithTokenData,
      callsWithInputTokenData: callsWithInputTokenData,
      callsWithOutputTokenData: callsWithOutputTokenData,
      callsWithTotalTokenData: callsWithTotalTokenData,
      unattributedCalls: unattributedCalls,
      modelCalls: Map.unmodifiable(modelCalls),
    );
  }

  bool _matchesPeriod(AiUsageLogOut log, DomainDashboardQuery query) {
    final createdAt = log.createdAt;
    if (createdAt == null)
      return query.startAt == null && query.endBefore == null;
    if (query.startAt != null && createdAt.isBefore(query.startAt!)) {
      return false;
    }
    if (query.endBefore != null && !createdAt.isBefore(query.endBefore!)) {
      return false;
    }
    return true;
  }

  Map<String, Object?> _asMap(BuiltMap<String, JsonObject?> details) => {
    for (final entry in details.entries) entry.key: entry.value?.value,
  };

  String? _findString(Object? value, Set<String> keys) {
    if (value is Map) {
      for (final entry in value.entries) {
        final key = _normalizeKey(entry.key.toString());
        if (keys.contains(key) && entry.value is String) {
          return entry.value as String;
        }
        final nested = _findString(entry.value, keys);
        if (nested != null) return nested;
      }
    } else if (value is List) {
      for (final item in value) {
        final nested = _findString(item, keys);
        if (nested != null) return nested;
      }
    }
    return null;
  }

  int? _findNumber(Object? value, Set<String> keys) {
    if (value is Map) {
      for (final entry in value.entries) {
        final key = _normalizeKey(entry.key.toString());
        if (keys.contains(key) && entry.value is num) {
          return (entry.value as num).round();
        }
        final nested = _findNumber(entry.value, keys);
        if (nested != null) return nested;
      }
    } else if (value is List) {
      for (final item in value) {
        final nested = _findNumber(item, keys);
        if (nested != null) return nested;
      }
    }
    return null;
  }

  String _normalizeKey(String key) =>
      key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

final dashboardAiUsageProvider =
    FutureProvider.family<DashboardAiUsageSummary, DomainDashboardQuery>((
      ref,
      query,
    ) async {
      final user = await ref.watch(userProvider.future);
      if (user.remoteId.isEmpty) {
        throw StateError('A conta não possui um identificador remoto.');
      }
      final api = ref.watch(apiClientProvider).getAiUsageLogApi();
      return DashboardAiUsageService(
        api,
      ).load(remoteUserId: user.remoteId, query: query);
    });
