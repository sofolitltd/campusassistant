import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:campusassistant/core/theme/app_colors.dart';
import 'package:campusassistant/features/auth/domain/entities/user.dart'
    as user_entity;
import 'package:campusassistant/features/student/presentation/providers/student_provider.dart';
import 'section_header.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';

class AcademicSection extends ConsumerWidget {
  final user_entity.User user;

  const AcademicSection({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(studentProfileProvider).when(
      data: (student) {
        if (student == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              SectionHeader(
                title: 'Academic Info',
                subtitle: 'Batch, session & student ID',
                icon: LucideIcons.graduationCap,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).cardColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(RadiusToken.md),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
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
      loading: () => const SizedBox.shrink(),
      error: (err, _) => const SizedBox.shrink(),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
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
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: mutedColor),
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: color,
    );
  }
}
