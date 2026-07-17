import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/features/emergency/domain/entities/emergency_contact.dart';
import '/widgets/open_app.dart';

class ContactCard extends StatelessWidget {
  final EmergencyContact contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: .end,
        children: [
          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        contact.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (contact.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 14),
                    ],
                  ],
                ),
                if (contact.designation != null)
                  Text(
                    contact.designation!,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                Text(
                  contact.phone,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
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
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: LucideIcons.phone,
                onPressed: () => OpenApp.withNumber(contact.phone),
                color: Colors.green,
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary
              ? null
              : Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? color : Colors.grey.shade600,
        ),
      ),
    );
  }
}
