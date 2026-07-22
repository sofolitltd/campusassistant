import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String userId,
    required String plan,
    DateTime? startDate,
    DateTime? endDate,
  }) = _Subscription;
}

@freezed
abstract class SubscriptionPlan with _$SubscriptionPlan {
  const SubscriptionPlan._();

  const factory SubscriptionPlan({
    required String id,
    required String title,
    required int price,
    required int discount,
    required int durationDays,
    @Default(false) bool isLifetime,
    required int index,
    required List<SubscriptionTarget> targets,
  }) = _SubscriptionPlan;

  int get mainPrice {
    if (discount == 0) return price;
    return (price / (1 - (discount / 100))).round();
  }

  /// Taka saved vs. the original (pre-discount) price.
  int get savedAmount => mainPrice - price;
}

@freezed
abstract class SubscriptionTarget with _$SubscriptionTarget {
  const factory SubscriptionTarget({
    required String id,
    required String universityId,
    required String departmentId,
  }) = _SubscriptionTarget;
}
