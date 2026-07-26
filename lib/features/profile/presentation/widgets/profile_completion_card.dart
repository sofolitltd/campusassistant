import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/routes/app_route.dart';

/// Fields treated as "fill this in for a complete profile" — a mix of
/// always-required-at-signup fields (kept in case they're ever blank on an
/// older/imported account) and genuinely optional ones users tend to skip
/// (photo, blood group, hall, gender).
const Map<String, String Function(user_entity.User)> _completionFields = {
  'Full name': _fullName,
  'Email': _email,
  'Phone': _phone,
  'Profile photo': _profileImage,
  'Gender': _gender,
  'Blood group': _blood,
  'Hall': _hall,
};

String _fullName(user_entity.User u) => u.fullName;
String _email(user_entity.User u) => u.email;
String _phone(user_entity.User u) => u.phone ?? '';
String _profileImage(user_entity.User u) => u.profileImage ?? '';
String _gender(user_entity.User u) => u.gender ?? '';
String _blood(user_entity.User u) => u.blood ?? '';
String _hall(user_entity.User u) => u.hall ?? '';

/// Names of [_completionFields] entries [user] hasn't filled in yet.
List<String> missingProfileFields(user_entity.User user) => [
      for (final entry in _completionFields.entries)
        if (entry.value(user).trim().isEmpty) entry.key,
    ];

/// 0-100 — shared by [ProfileCompletionCard] and the header's badge so both
/// always agree on the same number.
int profileCompletionPercent(user_entity.User user) {
  final filledCount =
      _completionFields.length - missingProfileFields(user).length;
  return (filledCount / _completionFields.length * 100).round();
}

class ProfileCompletionCard extends StatelessWidget {
  final user_entity.User user;
  const ProfileCompletionCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final missing = missingProfileFields(user);
    final percent = profileCompletionPercent(user);
    final isComplete = missing.isEmpty;
    final primaryColor = Theme.of(context).appColors.primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isComplete
          ? null
          : () => context.pushNamed(
                AppRoute.editProfile.name,
                queryParameters: {'uid': user.id},
              ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete ? LucideIcons.circleCheck : LucideIcons.userRound,
                  size: 16,
                  color: isComplete ? Colors.green : primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isComplete
                        ? 'Profile complete'
                        : 'Complete your profile',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isComplete ? Colors.green : primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 6,
                backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  isComplete ? Colors.green : primaryColor,
                ),
              ),
            ),
            if (!isComplete) ...[
              const SizedBox(height: 8),
              Text(
                'Add ${missing.join(', ')} to finish your profile',
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
