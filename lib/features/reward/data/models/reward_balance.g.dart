// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RewardBalance _$RewardBalanceFromJson(Map<String, dynamic> json) =>
    _RewardBalance(
      balance: (json['balance'] as num).toInt(),
      lifetimeEarned: (json['lifetime_earned'] as num).toInt(),
      lifetimeSpent: (json['lifetime_spent'] as num).toInt(),
    );

Map<String, dynamic> _$RewardBalanceToJson(_RewardBalance instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'lifetime_earned': instance.lifetimeEarned,
      'lifetime_spent': instance.lifetimeSpent,
    };
