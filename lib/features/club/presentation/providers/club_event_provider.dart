import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/club_event.dart';
import '/core/providers/cache_for.dart';

final clubEventsProvider = FutureProvider.autoDispose
    .family<List<ClubEvent>, String>((ref, clubId) async {
      ref.cacheFor(kParamProviderCacheTime);
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get('/clubs/$clubId/events');
      final data = response.data as List; // raw array, published+upcoming only
      return data
          .map((e) => ClubEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    });
