import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class EditBanner extends StatelessWidget {
  final String oldText;
  final VoidCallback onCancel;
  final bool isDark;

  const EditBanner({
    super.key,
    required this.oldText,
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
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  'Editing',
                  style: TextStyle(
                    fontSize: FontSizeToken.xs,
                    fontWeight: .w600,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  oldText,
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
