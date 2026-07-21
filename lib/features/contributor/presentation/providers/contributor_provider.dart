import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di.dart';
import '../../data/models/contributor_model.dart';

part 'contributor_provider.g.dart';

@riverpod
Future<List<ContributorModel>> contributors(Ref ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    '/contributors',
    queryParameters: {'limit': 200},
  );

  final Map<String, dynamic> body = response.data;
  final List<dynamic> data = body['data'] ?? [];
  return data.map((json) => ContributorModel.fromJson(json)).toList();
}
