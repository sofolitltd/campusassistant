import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const InteractionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor ?? Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: iconColor ?? Colors.grey.shade600,
                fontSize: 12,
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
