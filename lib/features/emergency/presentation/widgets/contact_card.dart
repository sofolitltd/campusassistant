import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/features/emergency/domain/entities/emergency_contact.dart';
import '/widgets/open_app.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ContactCard extends StatelessWidget {
  final EmergencyContact contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.xl),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: .end,
        children: [
          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        contact.title,
                        style: const TextStyle(
                          fontWeight: .bold,
                          fontSize: FontSizeToken.lg,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                    if (contact.isVerified) ...[
                      const SizedBox(width: Spacing.xs),
                      Icon(
                        Icons.verified,
                        color: context.colors.info,
                        size: 14,
                      ),
                    ],
                  ],
                ),
                if (contact.designation != null)
                  Text(
                    contact.designation!,
                    style: TextStyle(
                      color: context.colors.textSubtle,
                      fontSize: FontSizeToken.sm,
                      fontWeight: .w500,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  contact.phone,
                  style: TextStyle(
                    color: context.colors.success,
                    fontSize: FontSizeToken.lg,
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: .min,
            children: [
              _ActionButton(
                icon: LucideIcons.share2,
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          '${contact.title}\n${contact.designation ?? ''}\nPhone: ${contact.phone}',
                    ),
                  );
                },
                color: context.colors.textSubtle,
              ),
              const SizedBox(width: Spacing.sm),
              _ActionButton(
                icon: LucideIcons.phone,
                onPressed: () => OpenApp.withNumber(contact.phone),
                color: context.colors.success,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isPrimary ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: isPrimary
              ? null
              : Border.all(color: context.colors.border, width: 1),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? color : context.colors.textMuted,
        ),
      ),
    );
  }
}
