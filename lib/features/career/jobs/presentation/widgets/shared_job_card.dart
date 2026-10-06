import 'package:flutter/material.dart';

import '../../data/models/career_job.dart';
import 'attachment_thumbnail.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// A peer-shared Job card — visually distinct from an official CircularCard
/// (poster name badge instead of a category chip) so it reads as
/// student-shared content, not admin-curated.
class SharedJobCard extends StatelessWidget {
  final CareerJob job;

  const SharedJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            AttachmentThumbnail(
              attachmentUrls: job.attachmentUrls,
              size: 44,
              fallbackIcon: Icons.person_outline,
              background: theme.colorScheme.secondaryContainer,
              foreground: theme.colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Shared by ${job.poster?.name ?? "a student"}',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(RadiusToken.xs),
                        ),
                        child: Text(
                          _scopeLabel(job.scope),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: .bold,
                            fontSize: FontSizeToken.xxs,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    job.title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  if (job.organization.isNotEmpty)
                    Text(
                      job.organization,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  if (job.deadlineDate != null) ...[
                    const SizedBox(height: Spacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: job.isPastDeadline
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Text(
                        job.isPastDeadline
                            ? 'Deadline passed'
                            : 'Deadline: ${_shortDate(job.deadlineDate!)}',
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _scopeLabel(CareerJobScope scope) {
    switch (scope) {
      case CareerJobScope.batch:
        return 'BATCH';
      case CareerJobScope.department:
        return 'DEPT';
      case CareerJobScope.university:
        return 'UNI';
      case CareerJobScope.private_:
        return '';
    }
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
