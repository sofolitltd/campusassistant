import 'package:freezed_annotation/freezed_annotation.dart';

import 'moderator_role.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? profileImage,
    String? phone,
    String? gender,
    String? batch,
    String? batchId,
    String? profession,
    String? session,
    String? hall,
    String? blood,
    @Default(true) bool isActive,
    @Default(false) bool isVerified,
    @Default(false) bool isPhonePublic,
    @Default(false) bool isEmailPublic,
    @Default('basic') String? subscriptionStatus,
    @Default(false) bool legacyIsModerator,
    @Default(false) bool isAdmin,
    @Default(false) bool isCr,
    @Default([]) List<ModeratorRole> moderatorRoles,
    String? universityId,
    String? departmentId,
    DateTime? createdAt,
    // Raw access-grant perks from /me (see core/providers/perks_provider.dart).
    Map<String, dynamic>? perks,
  }) = _User;

  String get fullName => '$firstName $lastName';

  bool get isModerator => moderatorRoles.isNotEmpty || legacyIsModerator;

  ModeratorRole? get highestModeratorRole {
    if (moderatorRoles.isEmpty) return null;
    const priority = {'batch': 0, 'department': 1, 'university': 2};
    return moderatorRoles.reduce(
      (a, b) => (priority[a.scopeType] ?? -1) >= (priority[b.scopeType] ?? -1)
          ? a
          : b,
    );
  }

  bool can(String permission, [ModeratorScopeTarget? target]) {
    if (isAdmin) return true;
    final matchingRoles = target == null
        ? moderatorRoles
        : moderatorRoles.where((role) => role.appliesTo(target));
    return matchingRoles.any((role) => role.permissions.contains(permission));
  }

  ModeratorScopeTarget get moderatorScope => ModeratorScopeTarget(
    batchId: batchId,
    departmentId: departmentId,
    universityId: universityId,
  );
}
