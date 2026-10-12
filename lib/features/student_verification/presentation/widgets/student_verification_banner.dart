import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/routes/app_route.dart';
import '../providers/student_verification_provider.dart';

/// Home banner for a signed-in user who is not linked to a student profile
/// yet (signed up without a code, or a code claim failed). Hidden for
/// teachers/staff and for anyone already linked.
class StudentVerificationBanner extends ConsumerWidget {
  const StudentVerificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null || user.role == 'teacher' || user.role == 'staff') {
      return const SizedBox.shrink();
    }
    final student = ref.watch(studentByUserIdProvider(user.id));
    if (student.isLoading || student.hasError || student.value != null) {
      return const SizedBox.shrink();
    }

    final request = ref.watch(myStudentVerificationProvider).value;
    final colors = context.colors;
    final (
      String title,
      String subtitle,
      Color fg,
      Color bg,
    ) = switch (request) {
      final r? when r.isPending => (
        'Verification under review',
        'We will notify you once an admin checks your documents.',
        colors.warning,
        colors.warningSubtle,
      ),
      final r? when r.isRejected => (
        'Verification not approved',
        'Tap to see why and submit again.',
        colors.danger,
        colors.dangerSubtle,
      ),
      _ => (
        'Verify your student profile',
        'Upload your ID card to join your batch.',
        colors.info,
        colors.infoSubtle,
      ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          onTap: () => context.pushNamed(AppRoute.studentVerification.name),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                Icon(Icons.badge_outlined, color: fg),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.text,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: colors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
