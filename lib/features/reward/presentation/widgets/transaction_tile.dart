import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class HistoryFooter extends StatelessWidget {
  final bool loading;
  final int count;

  const HistoryFooter({super.key, required this.loading, required this.count});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: FontSizeToken.sm,
      color: context.colors.textMuted,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: loading
          ? Row(
              mainAxisAlignment: .center,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CupertinoActivityIndicator(),
                ),
                const SizedBox(width: Spacing.sm),
                Text('Loading more transactions...', style: style),
              ],
            )
          : Center(child: Text('$count loaded', style: style)),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final dynamic transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isEarn = transaction.type == 'earn';
    final dateStr = transaction.createdAt != null
        ? DateFormat('MMM d, yyyy').format(transaction.createdAt)
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: (isEarn ? context.colors.success : context.colors.danger)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusToken.md),
              ),
              child: Icon(
                isEarn ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                size: 16,
                color: isEarn ? context.colors.success : context.colors.danger,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    transaction.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: .w500),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: context.colors.textSubtle),
                    ),
                ],
              ),
            ),
            Text(
              '${isEarn ? '+' : '-'}${transaction.amount}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: .bold,
                color: isEarn ? context.colors.success : context.colors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
