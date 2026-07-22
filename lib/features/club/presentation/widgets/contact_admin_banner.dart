import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';

/// Shown while a club request is pending review, so the requester has a
/// human to reach out to instead of just waiting silently.
class ContactAdminBanner extends StatelessWidget {
  final bool compact;

  const ContactAdminBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.blue.withValues(alpha: 0.08)
            : Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent_rounded,
                size: compact ? 16 : 18,
                color: Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Questions about your request? Contact $kAdminContactName',
                  style: TextStyle(
                    fontSize: compact ? 12 : 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              decoration: TextDecoration.underline,
              color: isDark ? Colors.white60 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
