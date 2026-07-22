import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/club_event.dart';

final clubEventsProvider = FutureProvider.family<List<ClubEvent>, String>((
  ref,
  clubId,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/clubs/$clubId/events');
  final data = response.data as List; // raw array, published+upcoming only
  return data
      .map((e) => ClubEvent.fromJson(e as Map<String, dynamic>))
      .toList();
});
