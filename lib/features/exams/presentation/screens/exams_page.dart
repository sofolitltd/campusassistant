import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/exam_notice.dart';
import '../providers/exam_notice_provider.dart';

class ExamsPage extends ConsumerWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(userProvider).value?.information;
    final scope = (
      universityId: info?.universityId ?? '',
      departmentId: info?.departmentId ?? '',
      batchId: info?.batchId,
    );
    final examsAsync = ref.watch(examNoticesProvider(scope));

    return CustomHeaderLayout(
      title: 'Exams',
      showSearchBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(examNoticesProvider(scope));
          await ref.read(examNoticesProvider(scope).future);
        },
        child: examsAsync.when(
          data: (exams) {
            if (exams.isEmpty) return const _EmptyExams();
            // exams is sorted soonest-first; the first non-past one becomes
            // the hero — the single thing a student should see at a glance.
            final nextIndex = exams.indexWhere((e) => !e.isPast);
            final next = nextIndex == -1 ? null : exams[nextIndex];
            final rest = [
              for (var i = 0; i < exams.length; i++)
                if (i != nextIndex) exams[i],
            ];
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(Spacing.lg),
              itemCount: rest.length + (next != null ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, i) {
                if (next != null) {
                  if (i == 0) return _NextExamHero(exam: next);
                  return _ExamCard(exam: rest[i - 1]);
                }
                return _ExamCard(exam: rest[i]);
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: Spacing.md),
              Center(
                child: Text(
                  "Couldn't load exams. Pull down to retry.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyExams extends StatelessWidget {
  const _EmptyExams();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(LucideIcons.clipboardList, size: 56, color: colors.textSubtle),
        const SizedBox(height: Spacing.lg),
        Center(
          child: Text(
            'No exams scheduled',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Center(
          child: Text(
            "You'll see exam dates and seat plans here once they're posted.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.textMuted),
          ),
        ),
      ],
    );
  }
}

({String label, Color color}) _typeMeta(AppColors colors, String type) {
  switch (type) {
    case 'final':
      return (label: 'Final', color: colors.danger);
    case 'midterm':
      return (label: 'Midterm', color: colors.warning);
    case 'quiz':
      return (label: 'Quiz', color: colors.info);
    case 'retake':
      return (label: 'Retake', color: colors.textMuted);
    case 'improvement':
      return (label: 'Improvement', color: colors.textMuted);
    default:
      return (label: type, color: colors.textMuted);
  }
}

String _countdownLabel(ExamNotice exam) {
  final d = exam.daysUntil();
  if (d < 0) return 'Past';
  if (d == 0) return 'Today';
  if (d == 1) return 'Tomorrow';
  return 'In $d days';
}

/// The single most urgent upcoming exam, pulled out of the flat list and
/// shown big — this is what makes the countdown actually feel urgent instead
/// of being just another equal-weight card in a scroll.
class _NextExamHero extends StatelessWidget {
  final ExamNotice exam;
  const _NextExamHero({required this.exam});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final typeMeta = _typeMeta(colors, exam.examType);
    final d = exam.daysUntil();
    final urgent = d <= 2;
    final big = switch (d) {
      0 => 'Today',
      1 => 'Tomorrow',
      _ => '$d days',
    };

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: urgent
              ? [colors.danger, colors.danger.withValues(alpha: 0.75)]
              : [colors.primary, colors.primary.withValues(alpha: 0.75)],
        ),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Next up',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              _Pill(label: typeMeta.label, color: Colors.white),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            exam.courseName,
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            big,
            style: textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Icon(
                LucideIcons.clock3,
                size: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                [
                  '${exam.examDate.day}/${exam.examDate.month}/${exam.examDate.year}',
                  if (exam.startTime.isNotEmpty) exam.startTime,
                  if (exam.room.isNotEmpty) exam.room,
                ].join(' · '),
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          if (exam.hasCourseLink || exam.hasSeatPlan || exam.hasSyllabus) ...[
            const SizedBox(height: Spacing.md),
            Wrap(
              spacing: Spacing.lg,
              runSpacing: Spacing.sm,
              children: [
                if (exam.hasCourseLink)
                  _WhiteLink(
                    icon: LucideIcons.bookOpen,
                    label: 'View Course',
                    onTap: () => context.pushNamed(
                      AppRoute.courseDetails.name,
                      pathParameters: {'courseCode': exam.courseCode},
                    ),
                  ),
                if (exam.hasSeatPlan)
                  _WhiteLink(
                    icon: LucideIcons.fileText,
                    label: 'Seat Plan',
                    onTap: () => launchUrl(
                      Uri.parse(ApiEndpoints.resolveImageUrl(exam.seatPlanUrl)),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                if (exam.hasSyllabus)
                  _WhiteLink(
                    icon: LucideIcons.fileText,
                    label: 'Syllabus',
                    onTap: () => launchUrl(
                      Uri.parse(ApiEndpoints.resolveImageUrl(exam.syllabusUrl)),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WhiteLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _WhiteLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(RadiusToken.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamNotice exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final typeMeta = _typeMeta(colors, exam.examType);
    final countdown = _countdownLabel(exam);
    final isUrgent = !exam.isPast && exam.daysUntil() <= 2;

    return Opacity(
      opacity: exam.isPast ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Pill(label: typeMeta.label, color: typeMeta.color),
                const SizedBox(width: Spacing.sm),
                _Pill(
                  label: countdown,
                  color: isUrgent ? colors.danger : colors.success,
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              exam.courseName,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Icon(LucideIcons.clock3, size: 14, color: colors.textMuted),
                const SizedBox(width: Spacing.xs),
                Text(
                  [
                    '${exam.examDate.day}/${exam.examDate.month}/${exam.examDate.year}',
                    if (exam.startTime.isNotEmpty) exam.startTime,
                  ].join(' · '),
                  style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
            if (exam.room.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Row(
                children: [
                  Icon(LucideIcons.mapPin, size: 14, color: colors.textMuted),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    exam.room,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
            if (exam.note.isNotEmpty) ...[
              const SizedBox(height: Spacing.sm),
              Text(exam.note, style: textTheme.bodySmall),
            ],
            if (exam.hasCourseLink) ...[
              const SizedBox(height: Spacing.sm),
              GestureDetector(
                onTap: () => context.pushNamed(
                  AppRoute.courseDetails.name,
                  pathParameters: {'courseCode': exam.courseCode},
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.bookOpen, size: 16, color: colors.primary),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      'View Course',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (exam.hasSeatPlan || exam.hasSyllabus) ...[
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  if (exam.hasSeatPlan)
                    _AttachmentLink(label: 'Seat Plan', url: exam.seatPlanUrl),
                  if (exam.hasSeatPlan && exam.hasSyllabus)
                    const SizedBox(width: Spacing.lg),
                  if (exam.hasSyllabus)
                    _AttachmentLink(label: 'Syllabus', url: exam.syllabusUrl),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AttachmentLink extends StatelessWidget {
  final String label;
  final String url;
  const _AttachmentLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => launchUrl(
        Uri.parse(ApiEndpoints.resolveImageUrl(url)),
        mode: LaunchMode.externalApplication,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.fileText, size: 16, color: colors.primary),
          const SizedBox(width: Spacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: colors.primary),
          ),
        ],
      ),
    );
  }
}
