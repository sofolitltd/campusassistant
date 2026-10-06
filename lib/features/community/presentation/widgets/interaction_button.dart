import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const InteractionButton({
    super.key,
    required this.icon,
    this.label = '',
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.xs,
          horizontal: Spacing.xxs,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor ?? context.colors.textMuted),
            const SizedBox(width: Spacing.sm),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: iconColor ?? context.colors.textMuted,
                fontSize: FontSizeToken.sm,
                fontWeight: iconColor != null
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
