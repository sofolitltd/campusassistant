import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_client.dart';
import '../../data/models/bkash_transaction.dart';

class TransactionHistoryRepository {
  final ApiClient apiClient;

  TransactionHistoryRepository({required this.apiClient});

  Future<List<BkashTransaction>> list() async {
    final response = await apiClient.get('/payments/bkash/transactions');
    final data = response.data as Map<String, dynamic>;
    final list = data['transactions'] as List? ?? [];
    return list
        .map((e) => BkashTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final transactionHistoryRepositoryProvider =
    Provider<TransactionHistoryRepository>((ref) {
      return TransactionHistoryRepository(
        apiClient: ref.watch(apiClientProvider),
      );
    });

final transactionHistoryProvider = FutureProvider<List<BkashTransaction>>((
  ref,
) async {
  final repo = ref.watch(transactionHistoryRepositoryProvider);
  return repo.list();
});
