import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Shown while a club request is pending review, so the requester has a
/// human to reach out to instead of just waiting silently.
class ContactAdminBanner extends StatelessWidget {
  final bool compact;

  const ContactAdminBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        color: context.colors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.info.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent_rounded,
                size: compact ? 16 : 18,
                color: context.colors.info,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  'Questions about your request? Contact $kAdminContactName',
                  style: TextStyle(
                    fontSize: compact ? 12 : 13,
                    fontWeight: .w600,
                    color: context.colors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.md,
            children: [
              _ContactLink(
                icon: Icons.phone_rounded,
                text: kAdminContactPhone,
                onTap: () => OpenApp.withNumber(kAdminContactPhone),
              ),
              _ContactLink(
                icon: Icons.email_rounded,
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
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactLink({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 14, color: context.colors.info),
          const SizedBox(width: Spacing.xs),
          Text(
            text,
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              decoration: .underline,
              color: context.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
