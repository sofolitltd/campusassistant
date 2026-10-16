import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/utils/constants.dart';
import '/utils/string_extensions.dart';
import '/widgets/open_app.dart';

/// Shown wherever a student can't find their university, department or batch
/// — either the whole list is empty, or a search inside a picker matched
/// nothing — so they always get a way to ask an admin to add it instead of
/// hitting a dead end.
class NotAddedNotice extends StatelessWidget {
  const NotAddedNotice({super.key, required this.what});

  /// E.g. "your university" — title-cased for display.
  final String what;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.triangleAlert, size: 20, color: colors.warning),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  '${what.toTitleCase()} Not Added Yet',
                  style: TextStyle(
                    fontSize: FontSizeToken.lg,
                    fontWeight: FontWeight.w700,
                    color: colors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            "We haven't added it to Campus Assistant yet. Contact an admin "
            'or moderator and we will get it set up.',
            style: TextStyle(
              fontSize: FontSizeToken.base,
              color: colors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.lg,
            runSpacing: Spacing.xs,
            children: [
              _ContactLink(
                icon: LucideIcons.phone,
                text: kAdminContactPhone,
                onTap: () => OpenApp.withNumber(kAdminContactPhone),
              ),
              _ContactLink(
                icon: LucideIcons.mail,
                text: kAdminContactEmail,
                onTap: () => OpenApp.withEmail(kAdminContactEmail),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.colors.warning),
          const SizedBox(width: Spacing.xs),
          Text(
            text,
            style: TextStyle(
              fontSize: FontSizeToken.base,
              decoration: TextDecoration.underline,
              color: context.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
