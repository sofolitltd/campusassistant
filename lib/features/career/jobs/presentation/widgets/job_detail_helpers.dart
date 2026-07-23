import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

// Ported from personalassistant's JobDetailsScreen widgets/info_card.dart,
// restyled with this app's Spacing/RadiusToken tokens.

Widget buildJobInfoCard(
  BuildContext context,
  IconData icon,
  String label,
  DateTime date, {
  bool isUrgent = false,
  String? timeLeft,
}) {
  final cs = Theme.of(context).colorScheme;
  return Card(
    margin: const EdgeInsets.only(bottom: Spacing.xl),
    elevation: 0,
    color: cs.surface,
    shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.xl)),
    child: Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: isUrgent ? cs.errorContainer : cs.primaryContainer,
              borderRadius: RadiusToken.circular(RadiusToken.md),
            ),
            child: Icon(icon, size: 18, color: isUrgent ? cs.error : cs.primary),
          ),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: Spacing.xxs),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface),
                ),
              ],
            ),
          ),
          if (timeLeft != null) ...[
            const SizedBox(width: Spacing.xl),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xxs),
              decoration: BoxDecoration(
                color: timeLeft == 'Expired'
                    ? cs.surfaceContainerHighest
                    : isUrgent
                        ? cs.errorContainer
                        : cs.tertiaryContainer,
                borderRadius: RadiusToken.circular(RadiusToken.xs),
              ),
              child: Text(
                timeLeft,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: timeLeft == 'Expired'
                          ? cs.onSurfaceVariant
                          : isUrgent
                              ? cs.error
                              : cs.tertiary,
                    ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget buildJobLinkSection(BuildContext context, String title, String url, IconData icon) {
  final cs = Theme.of(context).colorScheme;
  return Card(
    margin: const EdgeInsets.only(bottom: Spacing.xl),
    elevation: 0,
    color: cs.surface,
    shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.xl)),
    child: Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: RadiusToken.circular(RadiusToken.md),
            ),
            child: Icon(icon, color: cs.primary, size: 20),
          ),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                Text(
                  url,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
            icon: Icon(LucideIcons.arrowUpRight, color: cs.primary),
          ),
        ],
      ),
    ),
  );
}

Widget buildEmptyJobMedia(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    height: 180,
    width: double.infinity,
    color: cs.surfaceContainerHighest,
    child: Center(
      child: Icon(LucideIcons.briefcase, size: 48, color: cs.outline),
    ),
  );
}
