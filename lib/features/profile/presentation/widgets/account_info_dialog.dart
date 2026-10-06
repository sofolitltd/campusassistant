import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/subscription/presentation/providers/subscription_provider.dart'
    show userSubscriptionProvider;

/// Shows the account's plan details: join date for Basic users, purchase date
/// and remaining time for Pro users.
Future<void> showAccountInfoDialog(
  BuildContext context,
  user_entity.User user,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => AccountInfoDialog(user: user),
  );
}

class AccountInfoDialog extends ConsumerWidget {
  final user_entity.User user;

  const AccountInfoDialog({super.key, required this.user});

  static String _date(DateTime? d) =>
      d == null ? '—' : DateFormat('dd MMM yyyy').format(d.toLocal());

  static String _remaining(DateTime end) {
    final days = end.difference(DateTime.now()).inDays;
    if (days < 0) return 'Expired';
    if (days == 0) return 'Ends today';
    if (days >= 60) return '$days days (~${(days / 30).floor()} months)';
    return '$days day${days == 1 ? '' : 's'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isPro = user.subscriptionStatus == 'pro';
    final subscription = isPro
        ? ref.watch(userSubscriptionProvider(user.id))
        : null;

    final rows = <_InfoRow>[];
    if (!isPro) {
      rows.add(_InfoRow('Plan', 'Basic'));
      rows.add(_InfoRow('Joined', _date(user.createdAt)));
    } else if (subscription == null || subscription.isLoading) {
      // Rows are added once loaded.
    } else {
      final sub = subscription.value;
      rows.add(_InfoRow('Plan', sub == null ? 'Pro' : 'Pro (${sub.plan})'));
      rows.add(_InfoRow('Joined', _date(user.createdAt)));
      if (sub != null) {
        rows.add(_InfoRow('Pro since', _date(sub.startDate)));
        final end = sub.endDate;
        rows.add(
          _InfoRow('Valid until', end == null ? 'Life Time' : _date(end)),
        );
        rows.add(
          _InfoRow('Time left', end == null ? 'Life Time' : _remaining(end)),
        );
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: _Avatar(imageUrl: user.profileImage ?? '')),
            const SizedBox(height: Spacing.md),
            Text(
              user.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: FontSizeToken.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSizeToken.sm,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Divider(color: colors.border, height: 1),
            const SizedBox(height: Spacing.md),
            if (isPro && (subscription?.isLoading ?? false))
              const Padding(
                padding: EdgeInsets.all(Spacing.lg),
                child: Center(child: CupertinoActivityIndicator()),
              )
            else
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          row.label,
                          style: TextStyle(color: colors.textMuted),
                        ),
                      ),
                      Text(
                        row.value,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: Spacing.lg),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
}

class _Avatar extends StatelessWidget {
  final String imageUrl;
  const _Avatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final placeholder = Icon(
      LucideIcons.user,
      size: 36,
      color: colors.onPrimary,
    );
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .6),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isEmpty
          ? Center(child: placeholder)
          : CachedNetworkImage(
              imageUrl: ApiEndpoints.resolveImageUrl(imageUrl),
              fit: BoxFit.cover,
              placeholder: (_, _) => Center(child: placeholder),
              errorWidget: (_, _, _) => Center(child: placeholder),
            ),
    );
  }
}
