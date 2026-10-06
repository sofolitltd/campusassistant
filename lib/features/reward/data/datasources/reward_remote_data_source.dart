import '/core/network/api_endpoints.dart';
import '/core/network/api_client.dart';
import '../models/reward_balance.dart';
import '../models/reward_transaction.dart';

abstract class RewardRemoteDataSource {
  Future<RewardBalance> getBalance();
  Future<RewardBalance> earn();
  Future<Map<String, dynamic>> spend(String resourceId);
  Future<({List<RewardTransaction> data, int count})> getTransactions({
    int limit,
    int offset,
  });
  Future<int> getCost(String resourceId);
}

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  final ApiClient apiClient;

  RewardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RewardBalance> getBalance() async {
    final response = await apiClient.get(ApiEndpoints.rewardBalance);
    return RewardBalance.fromJson(response.data);
  }

  @override
  Future<RewardBalance> earn() async {
    final response = await apiClient.post(ApiEndpoints.rewardEarn);
    // Older backends omit lifetime_spent from the earn response.
    return RewardBalance.fromJson({
      'lifetime_spent': 0,
      ...Map<String, dynamic>.from(response.data),
    });
  }

  @override
  Future<Map<String, dynamic>> spend(String resourceId) async {
    final response = await apiClient.post(
      ApiEndpoints.rewardSpend(resourceId),
    );
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<({List<RewardTransaction> data, int count})> getTransactions({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.rewardTransactions,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final List<dynamic> items = response.data['data'] ?? [];
    final data = items.map((j) => RewardTransaction.fromJson(j)).toList();
    final count = response.data['count'] as int? ?? 0;
    return (data: data, count: count);
  }

  @override
  Future<int> getCost(String resourceId) async {
    final response = await apiClient.get(
      ApiEndpoints.rewardCost(resourceId),
    );
    return response.data['cost'] as int;
  }
}
