import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../network/api_client.dart';

class UsageAnalytics {
  final ApiClient _apiClient;
  final Uuid _uuid = const Uuid();

  UsageAnalytics(this._apiClient);

  Future<void> record({
    required String eventType,
    String? entityType,
    String? entityId,
    String? attemptId,
    String? category,
    int? resultCount,
  }) async {
    try {
      await _apiClient.post(
        '/analytics/events',
        data: {
          'id': _uuid.v4(),
          'event_type': eventType,
          'entity_type': ?entityType,
          'entity_id': ?entityId,
          'attempt_id': ?attemptId,
          'category': ?category,
          'result_count': ?resultCount,
          'platform': kIsWeb
              ? 'web'
              : switch (defaultTargetPlatform) {
                  TargetPlatform.android => 'android',
                  TargetPlatform.iOS => 'ios',
                  TargetPlatform.macOS ||
                  TargetPlatform.windows ||
                  TargetPlatform.linux ||
                  TargetPlatform.fuchsia => 'other',
                },
        },
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to record usage event: $eventType',
        name: 'UsageAnalytics',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
