import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '../../data/models/association_event.dart';

/// Public, read-only association sub-resources — mirrors clubEventsProvider.
final associationEventsProvider =
    FutureProvider.family<List<AssociationEvent>, String>((
      ref,
      associationId,
    ) async {
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '${ApiEndpoints.associations}/$associationId/events',
      );
      final data = response.data as List; // raw array, published+upcoming only
      return data
          .map((e) => AssociationEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    });
