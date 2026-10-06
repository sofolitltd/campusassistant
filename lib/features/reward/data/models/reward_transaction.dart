import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_transaction.freezed.dart';
part 'reward_transaction.g.dart';

@freezed
abstract class RewardTransaction with _$RewardTransaction {
  const factory RewardTransaction({
    required String id,
    required String type,
    required int amount,
    @JsonKey(name: 'balance_after') required int balanceAfter,
    @JsonKey(name: 'resource_id') String? resourceId,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _RewardTransaction;

  factory RewardTransaction.fromJson(Map<String, dynamic> json) =>
      _$RewardTransactionFromJson(json);
}
