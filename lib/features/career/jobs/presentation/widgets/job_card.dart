import 'package:campusassistant/core/theme/app_colors.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';
import 'package:flutter/material.dart';

import '../../data/models/career_job.dart';
import 'attachment_thumbnail.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class JobCard extends StatelessWidget {
  final CareerJob job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  Color _statusColor(BuildContext context) {
    switch (job.status) {
      case CareerJobStatus.pending:
        return context.colors.warning;
      case CareerJobStatus.applied:
        return context.colors.info;
      case CareerJobStatus.completed:
        return context.colors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: theme.brightness == Brightness.dark
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
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              AttachmentThumbnail(
                attachmentUrls: job.attachmentUrls,
                size: 88,
                fallbackIcon: Icons.work_outline,
                background: context.colors.primary.withValues(alpha: 0.3),
                foreground: context.colors.onPrimary,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 1,
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
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                            vertical: Spacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(context),
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                          ),
                          child: Text(
                            job.status.name.toUpperCase(),
                            style: TextStyle(
                              color: context.colors.onPrimary,
                              fontSize: FontSizeToken.xxs,
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                        if (job.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: Spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.sm,
                              ),
                            ),
                            child: Text(
                              job.category!.name,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                        if (_scopeLabel(job.scope).isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: Spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.sm,
                              ),
                            ),
                            child: Text(
                              _scopeLabel(job.scope),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                        if (job.deadlineDate != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: Spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: job.isPastDeadline
                                  ? theme.colorScheme.errorContainer
                                  : theme.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.sm,
                              ),
                            ),
                            child: Text(
                              job.isPastDeadline
                                  ? 'Expired'
                                  : 'Deadline: ${_shortDate(job.deadlineDate!)}',
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                          if (!job.isPastDeadline) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: Spacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.sm,
                                ),
                              ),
                              child: Text(
                                _countdown(job.deadlineDate!),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  String _countdown(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    if (days > 0) return '${days}d ${hours}h left';
    if (hours > 0) return '${hours}h ${minutes}m left';
    return '${minutes}m left';
  }
}
