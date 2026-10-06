import 'package:flutter/material.dart';

import '../../../jobs/presentation/widgets/attachment_thumbnail.dart';
import '../../data/models/career_circular.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CircularCard extends StatelessWidget {
  final CareerCircular circular;
  final VoidCallback onTap;

  const CircularCard({super.key, required this.circular, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
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
                attachmentUrls: circular.attachmentUrls,
                size: 56,
                fallbackIcon: Icons.business_center_outlined,
                background: theme.colorScheme.primaryContainer,
                foreground: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: circular.category != null
                              ? Text(
                                  circular.category!.name,
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: .bold,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                            vertical: Spacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(RadiusToken.xs),
                          ),
                          child: Text(
                            'OFFICIAL',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onTertiary,
                              fontWeight: .bold,
                              fontSize: FontSizeToken.xxs,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      circular.title,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                    if (circular.organization.isNotEmpty)
                      Text(
                        circular.organization,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    const SizedBox(height: Spacing.sm),
                    if (circular.deadlineDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: circular.isPastDeadline
                              ? theme.colorScheme.errorContainer
                              : theme.colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(RadiusToken.sm),
                        ),
                        child: Text(
                          circular.isPastDeadline
                              ? 'Deadline passed'
                              : 'Deadline: ${_formatDate(circular.deadlineDate!)}',
                          style: theme.textTheme.labelSmall,
                        ),
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

  String _formatDate(DateTime date) {
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
