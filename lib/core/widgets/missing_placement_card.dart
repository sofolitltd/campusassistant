import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import 'contact_help_sheet.dart';
import 'section_card.dart';

/// Shown proactively below the university/department/batch picker — before
/// any list actually comes back empty — so a student whose placement isn't
/// in the system yet knows right away how to ask for help, instead of
/// discovering a dead end only after selecting through the cascade.
class MissingPlacementCard extends StatelessWidget {
  const MissingPlacementCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SectionCard(
      radius: RadiusToken.lg,
      color: colors.primarySubtle,
      borderColor: colors.primary.withValues(alpha: 0.3),
      shadow: false,
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: RadiusToken.circular(RadiusToken.full),
                ),
                child: Icon(
                  LucideIcons.badgeHelp,
                  color: colors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Can't Find Your Placement?",
                      style: TextStyle(
                        fontSize: FontSizeToken.lg,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      "If your university, department or batch isn't "
                      "listed, let us know and we'll add it.",
                      style: TextStyle(
                        fontSize: FontSizeToken.sm,
                        color: colors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            width: double.infinity,
            height: ControlToken.height,
            child: ElevatedButton.icon(
              onPressed: () => showContactHelpSheet(
                context,
                title: "Can't Find Your Placement?",
                subtitle:
                    'Tell us your university, department and batch — '
                    "we'll get it added.",
              ),
              icon: const Icon(LucideIcons.lifeBuoy, size: 18),
              label: const Text('Contact Us'),
            ),
          ),
        ],
      ),
    );
  }
}
