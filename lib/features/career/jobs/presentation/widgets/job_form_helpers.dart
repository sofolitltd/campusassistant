import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

// Ported from personalassistant's AddJobScreen form helpers, restyled with
// this app's Spacing/RadiusToken design tokens instead of the reference
// app's AppSpacing/AppRadius so colors/spacing stay consistent here.

Widget buildSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: Spacing.md),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            letterSpacing: 1,
            fontWeight: FontWeight.w900,
          ),
    ),
  );
}

Widget buildCustomField(
  BuildContext context,
  String label,
  TextEditingController controller,
  IconData icon, [
  String? Function(String?)? validator,
]) {
  final cs = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.only(bottom: Spacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: Spacing.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            border: OutlineInputBorder(
              borderRadius: RadiusToken.circular(RadiusToken.sm),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: RadiusToken.circular(RadiusToken.sm),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: RadiusToken.circular(RadiusToken.sm),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
            filled: true,
            fillColor: cs.surface,
          ),
        ),
      ],
    ),
  );
}

Widget buildModernDateTile(
  BuildContext context,
  String label,
  DateTime? date,
  IconData icon,
  VoidCallback onTap, {
  bool isUrgent = false,
}) {
  final cs = Theme.of(context).colorScheme;
  return Card(
    margin: const EdgeInsets.only(bottom: Spacing.lg),
    elevation: 0,
    color: cs.surface,
    shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
    child: InkWell(
      onTap: onTap,
      borderRadius: RadiusToken.circular(RadiusToken.sm),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Row(
          children: [
            Icon(icon, color: isUrgent ? cs.error : cs.outline, size: 20),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    date == null ? 'Not Set' : DateFormat('MMM dd, yyyy - HH:mm').format(date),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: date == null ? cs.outline : cs.onSurface,
                        ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: cs.outline, size: 16),
          ],
        ),
      ),
    ),
  );
}

Widget buildEmptyAttachmentPlaceholder(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(Spacing.xxxl),
    decoration: BoxDecoration(
      color: cs.surface,
      borderRadius: RadiusToken.circular(RadiusToken.sm),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: Column(
      children: [
        Icon(LucideIcons.paperclip, color: cs.outline, size: 28),
        const SizedBox(height: Spacing.xs),
        Text(
          'No files attached',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget buildLoadingOverlay(BuildContext context, double progress) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    color: cs.surface,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Processing Job Entry...',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: Spacing.xs),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: cs.surfaceContainerHighest,
              color: cs.primary,
              minHeight: 8,
              borderRadius: RadiusToken.circular(RadiusToken.sm),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
