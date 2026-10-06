import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_balance.freezed.dart';
part 'reward_balance.g.dart';

@freezed
abstract class RewardBalance with _$RewardBalance {
  const factory RewardBalance({
    required int balance,
    @JsonKey(name: 'lifetime_earned') required int lifetimeEarned,
    @JsonKey(name: 'lifetime_spent') required int lifetimeSpent,
  }) = _RewardBalance;

  factory RewardBalance.fromJson(Map<String, dynamic> json) =>
      _$RewardBalanceFromJson(json);
}
