import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/subscription.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@freezed
abstract class SubscriptionModel with _$SubscriptionModel {
  const SubscriptionModel._();

  const factory SubscriptionModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String plan,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Subscription toEntity() => Subscription(
    id: id,
    userId: userId,
    plan: plan,
    startDate: startDate,
    endDate: endDate,
  );

  factory SubscriptionModel.fromEntity(Subscription subscription) =>
      SubscriptionModel(
        id: subscription.id,
        userId: subscription.userId,
        plan: subscription.plan,
        startDate: subscription.startDate,
        endDate: subscription.endDate,
      );
}

@freezed
abstract class SubscriptionPlanModel with _$SubscriptionPlanModel {
  const SubscriptionPlanModel._();

  const factory SubscriptionPlanModel({
    required String id,
    required String title,
    required int price,
    required int discount,
    @JsonKey(name: 'duration_days') required int durationDays,
    required int index,
    required List<SubscriptionTargetModel> targets,
  }) = _SubscriptionPlanModel;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanModelFromJson(json);

  SubscriptionPlan toEntity() => SubscriptionPlan(
    id: id,
    title: title,
    price: price,
    discount: discount,
    durationDays: durationDays,
    index: index,
    targets: targets.map((t) => t.toEntity()).toList(),
  );

  factory SubscriptionPlanModel.fromEntity(SubscriptionPlan plan) =>
      SubscriptionPlanModel(
        id: plan.id,
        title: plan.title,
        price: plan.price,
        discount: plan.discount,
        durationDays: plan.durationDays,
        index: plan.index,
        targets: plan.targets
            .map((t) => SubscriptionTargetModel.fromEntity(t))
            .toList(),
      );
}

@freezed
abstract class SubscriptionTargetModel with _$SubscriptionTargetModel {
  const SubscriptionTargetModel._();

  const factory SubscriptionTargetModel({
    required String id,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
  }) = _SubscriptionTargetModel;

  factory SubscriptionTargetModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTargetModelFromJson(json);

  SubscriptionTarget toEntity() => SubscriptionTarget(
    id: id,
    universityId: universityId,
    departmentId: departmentId,
  );

  factory SubscriptionTargetModel.fromEntity(SubscriptionTarget target) =>
      SubscriptionTargetModel(
        id: target.id,
        universityId: target.universityId,
        departmentId: target.departmentId,
      );
}
