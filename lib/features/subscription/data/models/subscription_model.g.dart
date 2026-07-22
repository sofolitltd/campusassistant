// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    _SubscriptionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      plan: json['plan'] as String,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$SubscriptionModelToJson(_SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'plan': instance.plan,
      'start_date': ?instance.startDate?.toIso8601String(),
      'end_date': ?instance.endDate?.toIso8601String(),
    };

_SubscriptionPlanModel _$SubscriptionPlanModelFromJson(
  Map<String, dynamic> json,
) => _SubscriptionPlanModel(
  id: json['id'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toInt(),
  discount: (json['discount'] as num).toInt(),
  durationDays: (json['duration_days'] as num).toInt(),
  isLifetime: json['is_lifetime'] as bool? ?? false,
  index: (json['index'] as num).toInt(),
  targets: (json['targets'] as List<dynamic>)
      .map((e) => SubscriptionTargetModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubscriptionPlanModelToJson(
  _SubscriptionPlanModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'discount': instance.discount,
  'duration_days': instance.durationDays,
  'is_lifetime': instance.isLifetime,
  'index': instance.index,
  'targets': instance.targets,
};

_SubscriptionTargetModel _$SubscriptionTargetModelFromJson(
  Map<String, dynamic> json,
) => _SubscriptionTargetModel(
  id: json['id'] as String,
  universityId: json['university_id'] as String,
  departmentId: json['department_id'] as String,
);

Map<String, dynamic> _$SubscriptionTargetModelToJson(
  _SubscriptionTargetModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'university_id': instance.universityId,
  'department_id': instance.departmentId,
};
