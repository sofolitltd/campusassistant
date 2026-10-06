import 'package:flutter/material.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class DateSeparator extends StatelessWidget {
  final String date;
  final bool isDark;

  const DateSeparator({super.key, required this.date, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(RadiusToken.md),
          ),
          child: Text(
            date,
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              fontWeight: .w500,
              color: context.colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
