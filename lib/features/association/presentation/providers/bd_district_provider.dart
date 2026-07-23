import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '../../data/models/bd_district.dart';

/// The static list of Bangladesh's 64 districts + upazilas, shared by the
/// association list filters and the suggest-association form's location
/// picker. `keepAlive` since this never changes within a session — no
/// reason to refetch it per-screen.
final bdDistrictsProvider = FutureProvider<List<BDDistrict>>((ref) async {
  ref.keepAlive();
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(ApiEndpoints.bdDistricts);
  final data = response.data as List;
  return data
      .map((e) => BDDistrict.fromJson(e as Map<String, dynamic>))
      .toList();
});
