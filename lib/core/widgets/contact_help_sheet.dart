import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';

/// Bottom sheet listing every way to reach us — email, phone, WhatsApp,
/// Facebook, website. Shared by any screen that offers a "contact us" /
/// "troubleshoot" action (login help, missing university/department/batch,
/// etc.) so the list of channels stays in one place.
void showContactHelpSheet(
  BuildContext context, {
  String title = 'Need Help?',
  String subtitle = 'Reach out through any of these channels.',
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.lg,
          0,
          Spacing.lg,
          Spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: sheetContext.colors.primarySubtle,
                    borderRadius: RadiusToken.circular(RadiusToken.full),
                  ),
                  child: Icon(
                    LucideIcons.lifeBuoy,
                    color: sheetContext.colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(sheetContext).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        subtitle,
                        style: Theme.of(sheetContext).textTheme.bodySmall
                            ?.copyWith(color: sheetContext.colors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),
            _ContactOption(
              icon: LucideIcons.mail,
              color: sheetContext.colors.danger,
              title: 'Email',
              subtitle: kAppEmail,
              onTap: () {
                Navigator.pop(sheetContext);
                OpenApp.withEmailNew(
                  kAppEmail,
                  subject: 'Login problem - Campus Assistant',
                  message: '',
                );
              },
            ),
            const SizedBox(height: Spacing.sm),
            _ContactOption(
              icon: LucideIcons.phone,
              color: sheetContext.colors.success,
              title: 'Phone',
              subtitle: kDeveloperMobile,
              onTap: () {
                Navigator.pop(sheetContext);
                OpenApp.withNumber(kDeveloperMobile);
              },
            ),
            const SizedBox(height: Spacing.sm),
            _ContactOption(
              icon: LucideIcons.messageCircle,
              color: sheetContext.colors.success,
              title: 'WhatsApp',
              subtitle: 'Chat with us',
              onTap: () {
                Navigator.pop(sheetContext);
                final message = Uri.encodeComponent(
                  "Hi, I'm having trouble signing in to Campus Assistant. "
                  'Could you help?',
                );
                OpenApp.withUrl('https://wa.me/8801704340860?text=$message');
              },
            ),
            const SizedBox(height: Spacing.sm),
            _ContactOption(
              icon: Icons.facebook_rounded,
              color: sheetContext.colors.info,
              title: 'Facebook',
              subtitle: 'Message our page',
              onTap: () {
                Navigator.pop(sheetContext);
                OpenApp.withUrl(kFbGroup);
              },
            ),
            const SizedBox(height: Spacing.sm),
            _ContactOption(
              icon: LucideIcons.globe,
              color: sheetContext.colors.primary,
              title: 'Website',
              subtitle: kDevWebsite,
              onTap: () {
                Navigator.pop(sheetContext);
                OpenApp.withUrl(kDevWebsite);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

/// A single tappable contact channel row used in the contact help sheet.
class _ContactOption extends StatelessWidget {
  const _ContactOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceAlt,
      borderRadius: RadiusToken.circular(RadiusToken.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: RadiusToken.circular(RadiusToken.full),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: context.colors.textSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
