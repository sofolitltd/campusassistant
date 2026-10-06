import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class SelectBar extends StatelessWidget {
  final int count;
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final bool isDark;

  const SelectBar({
    super.key,
    required this.count,
    required this.onDelete,
    required this.onCancel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.sm,
        Spacing.md,
        Spacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.borderStrong)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: context.colors.danger,
                size: 22,
              ),
              onPressed: onDelete,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              count == 1 ? '1 message' : '$count messages',
              style: TextStyle(
                color: context.colors.text,
                fontSize: FontSizeToken.base,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: ControlToken.height,
              child: TextButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
