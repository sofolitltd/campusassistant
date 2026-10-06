import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/error/failures.dart';
import '/core/theme/app_colors.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/student/presentation/providers/student_provider.dart';
import 'section_header.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class AcademicSection extends ConsumerWidget {
  final user_entity.User user;

  const AcademicSection({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(studentProfileProvider)
        .when(
          data: (student) {
            if (student == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: Spacing.lg),
              child: Column(
                children: [
                  SectionHeader(
                    title: 'Academic Info',
                    subtitle: 'Batch, session & student ID',
                    icon: LucideIcons.graduationCap,
                  ),
                  Container(
                    padding: const EdgeInsets.all(Spacing.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).cardColor
                          : context.colors.surface,
                      borderRadius: BorderRadius.circular(RadiusToken.md),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? context.colors.border
                            : context.colors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _AcademicRow(student: student),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                children: [
                  Icon(
                    err is NetworkFailure
                        ? Icons.cloud_off
                        : Icons.error_outline,
                    color: context.colors.textSubtle,
                    size: 32,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    err is NetworkFailure
                        ? 'No internet connection'
                        : 'Unable to load academic info',
                    textAlign: .center,
                    style: TextStyle(
                      color: context.colors.textMuted,
                      fontSize: FontSizeToken.base,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

class _AcademicRow extends StatelessWidget {
  final dynamic student;

  const _AcademicRow({required this.student});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      decoration: BoxDecoration(
        color: appColors.academicRowBg,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Row(
        children: [
          _AcademicBadge(
            label: 'Batch',
            value: student.batchName ?? student.batchId,
            textColor: cs.onSurface,
            mutedColor: cs.onSurfaceVariant,
          ),
          _BadgeDivider(color: cs.outlineVariant),
          _AcademicBadge(
            label: 'Session',
            value: student.sessionName ?? student.sessionId,
            textColor: cs.onSurface,
            mutedColor: cs.onSurfaceVariant,
          ),
          _BadgeDivider(color: cs.outlineVariant),
          _AcademicBadge(
            label: 'Student ID',
            value: student.studentId,
            textColor: cs.onSurface,
            mutedColor: cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _AcademicBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color mutedColor;

  const _AcademicBadge({
    required this.label,
    required this.value,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(
              fontWeight: .bold,
              fontSize: FontSizeToken.base,
              color: textColor,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            label,
            style: TextStyle(fontSize: FontSizeToken.xxs, color: mutedColor),
          ),
        ],
      ),
    );
  }
}

class _BadgeDivider extends StatelessWidget {
  final Color color;

  const _BadgeDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      color: color,
    );
  }
}
