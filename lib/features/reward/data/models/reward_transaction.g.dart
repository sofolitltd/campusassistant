// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RewardTransaction _$RewardTransactionFromJson(Map<String, dynamic> json) =>
    _RewardTransaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      balanceAfter: (json['balance_after'] as num).toInt(),
      resourceId: json['resource_id'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$RewardTransactionToJson(_RewardTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'balance_after': instance.balanceAfter,
      'resource_id': ?instance.resourceId,
      'description': ?instance.description,
      'created_at': instance.createdAt.toIso8601String(),
    };
