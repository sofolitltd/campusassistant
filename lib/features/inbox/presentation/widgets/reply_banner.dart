import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ReplyBanner extends StatelessWidget {
  final String text;
  final VoidCallback onCancel;
  final bool isDark;

  const ReplyBanner({
    super.key,
    required this.text,
    required this.onCancel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.sm,
        Spacing.sm,
        Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.borderStrong)),
      ),
      child: Row(
        children: [
          Container(width: 3, height: 32, color: context.colors.primary),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  'Replying',
                  style: TextStyle(
                    fontSize: FontSizeToken.xs,
                    fontWeight: .w600,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  text,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.x,
              size: 16,
              color: context.colors.textSubtle,
            ),
            onPressed: onCancel,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
