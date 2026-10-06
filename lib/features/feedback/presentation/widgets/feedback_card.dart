import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/feedback/domain/entities/feedback.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackItem feedback;

  const FeedbackCard({super.key, required this.feedback});

  static const _categoryMeta = {
    'bug': (LucideIcons.bug, 'Bug Report', AccentToken.red),
    'feature': (LucideIcons.sparkles, 'Feature Request', AccentToken.violet),
    'suggestion': (LucideIcons.lightbulb, 'Suggestion', AccentToken.amber),
    'complaint':
        (LucideIcons.alertTriangle, 'Complaint', AccentToken.orange),
    'general': (LucideIcons.messageSquare, 'General', AccentToken.gray),
  };

  Color _statusColor(String status) {
    return switch (status) {
      'resolved' => const Color(0xFF059669),
      'reviewed' => AccentToken.blueDeep,
      _ => const Color(0xFFD97706),
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      'resolved' => 'Resolved',
      'reviewed' => 'Reviewed',
      _ => 'Pending',
    };
  }

  @override
  Widget build(BuildContext context) {
    final meta = _categoryMeta[feedback.category] ??
        (LucideIcons.messageSquare, 'General', AccentToken.gray);
    final icon = meta.$1;
    final label = meta.$2;
    final color = meta.$3;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: context.colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: Spacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontSize: FontSizeToken.sm,
                  fontWeight: .w600,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
                decoration: BoxDecoration(
                  color: _statusColor(feedback.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(RadiusToken.full),
                ),
                child: Text(
                  _statusLabel(feedback.status),
                  style: TextStyle(
                    fontSize: FontSizeToken.xxs,
                    fontWeight: .bold,
                    color: _statusColor(feedback.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Text(
            feedback.subject,
            style: const TextStyle(
              fontSize: FontSizeToken.lg,
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            feedback.message,
            style: TextStyle(
              fontSize: FontSizeToken.md,
              color: context.colors.textMuted,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: .ellipsis,
          ),
          if (feedback.adminReply != null && feedback.adminReply!.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AccentToken.blueDeep.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                border: Border.all(
                  color: AccentToken.blueDeep.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.messageCircleReply,
                          size: 14, color: AccentToken.blueDeep),
                      const SizedBox(width: Spacing.sm),
                      Text(
                        'Admin Reply',
                        style: TextStyle(
                          fontSize: FontSizeToken.xs,
                          fontWeight: .bold,
                          color: AccentToken.blueDeep,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    feedback.adminReply!,
                    style: TextStyle(
                      fontSize: FontSizeToken.md,
                      color: context.colors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (feedback.createdAt != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              feedback.createdAt!,
              style: TextStyle(
                fontSize: FontSizeToken.xs,
                color: context.colors.textSubtle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
