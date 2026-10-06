import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;

  const MenuRow({
    super.key,
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? context.colors.danger
        : Theme.of(context).brightness == Brightness.dark
        ? context.colors.textMuted
        : context.colors.text;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: Spacing.md),
        Text(
          label,
          style: TextStyle(color: color, fontSize: FontSizeToken.base),
        ),
      ],
    );
  }
}
