import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/routes/app_route.dart';
import '/core/theme/tokens/app_font_size.dart';

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

  void _showCompletionDialog(BuildContext context) {
    final missing = missingProfileFields(user);
    final percent = profileCompletionPercent(user);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.colors.primary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        title: Row(
          children: [
            Icon(LucideIcons.userRound, size: 20, color: primaryColor),
            const SizedBox(width: Spacing.sm),
            Text(
              'Profile Completion',
              style: TextStyle(
                fontSize: FontSizeToken.lg,
                fontWeight: .bold,
                color: context.colors.text,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusToken.lg),
              ),
              child: Text(
                '$percent%',
                style: TextStyle(
                  fontSize: FontSizeToken.md,
                  fontWeight: .bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: .min,
            children: [
              Container(
                height: 6,
                margin: const EdgeInsets.only(bottom: Spacing.lg),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusToken.xs),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    backgroundColor: context.colors.border,
                    valueColor: AlwaysStoppedAnimation(
                      percent == 100 ? context.colors.success : primaryColor,
                    ),
                  ),
                ),
              ),
              for (final entry in _completionFields.entries)
                _FieldRow(
                  label: entry.key,
                  isFilled: entry.value(user).trim().isNotEmpty,
                  isDark: isDark,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              context.pushNamed(
                AppRoute.editProfile.name,
                queryParameters: {'uid': user.id},
              );
            },
            icon: Icon(
              missing.length == _completionFields.length
                  ? LucideIcons.plus
                  : LucideIcons.arrowRight,
              size: 16,
            ),
            label: Text(
              missing.isEmpty
                  ? 'View profile'
                  : 'Complete ${missing.take(2).join(' & ')}${missing.length > 2 ? ' +${missing.length - 2} more' : ''}',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missing = missingProfileFields(user);
    final percent = profileCompletionPercent(user);
    final isComplete = missing.isEmpty;
    final primaryColor = context.colors.primary;

    return GestureDetector(
      onTap: () => _showCompletionDialog(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete ? LucideIcons.circleCheck : LucideIcons.userRound,
                  size: 16,
                  color: isComplete ? context.colors.success : primaryColor,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    isComplete ? 'Profile complete' : 'Complete your profile',
                    style: TextStyle(
                      fontSize: FontSizeToken.md,
                      fontWeight: .w600,
                      color: context.colors.text,
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: FontSizeToken.md,
                    fontWeight: .bold,
                    color: isComplete ? context.colors.success : primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(RadiusToken.xs),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 6,
                backgroundColor: context.colors.border,
                valueColor: AlwaysStoppedAnimation(
                  isComplete ? context.colors.success : primaryColor,
                ),
              ),
            ),
            if (!isComplete) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                missing.length == _completionFields.length
                    ? 'Tap to get started'
                    : '${missing.length} of ${_completionFields.length} remaining',
                style: TextStyle(
                  fontSize: 11.5,
                  color: context.colors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final bool isFilled;
  final bool isDark;

  const _FieldRow({
    required this.label,
    required this.isFilled,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        children: [
          Icon(
            isFilled ? LucideIcons.checkCircle : LucideIcons.circleX,
            size: 18,
            color: isFilled ? context.colors.success : context.colors.danger,
          ),
          const SizedBox(width: Spacing.md),
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.base,
              color: context.colors.text,
            ),
          ),
          const Spacer(),
          Text(
            isFilled ? 'Filled' : 'Missing',
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              color: isFilled ? context.colors.success : context.colors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
