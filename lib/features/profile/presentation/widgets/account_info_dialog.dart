import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/subscription/domain/entities/subscription.dart';
import '/features/subscription/presentation/providers/subscription_provider.dart'
    show userSubscriptionProvider;
import '/routes/app_route.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isPro = user.subscriptionStatus == 'pro';
    final subscription = isPro
        ? ref.watch(userSubscriptionProvider(user.id))
        : null;

    final rows = <_InfoRow>[
      _InfoRow('Plan', isPro ? 'Pro' : 'Basic'),
      _InfoRow('Joined', _date(user.createdAt)),
    ];
    Subscription? sub;
    if (isPro && subscription != null && !subscription.isLoading) {
      sub = subscription.value;
      if (sub != null) {
        rows.add(_InfoRow('Pro since', _date(sub.startDate)));
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.xl,
              Spacing.xl,
              Spacing.xl,
              Spacing.xl,
            ),
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
                else ...[
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Spacing.xs,
                      ),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: Spacing.md),
                  _BkmeProSection(isPro: isPro, subscription: sub),
                ],
              ],
            ),
          ),
          Positioned(
            top: Spacing.sm,
            right: Spacing.sm,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(LucideIcons.x, size: 18, color: colors.textMuted),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}

class _BkmeProSection extends StatelessWidget {
  final bool isPro;
  final Subscription? subscription;

  const _BkmeProSection({required this.isPro, required this.subscription});

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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final end = subscription?.endDate;

    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: colors.primary.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: .15),
            ),
            child: Icon(LucideIcons.trophy, size: 16, color: colors.primary),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Become Pro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                if (isPro)
                  Text(
                    end == null
                        ? 'Life Time access'
                        : '${_remaining(end)} left · ends ${_date(end)}',
                    style: TextStyle(
                      fontSize: FontSizeToken.sm,
                      color: colors.textMuted,
                    ),
                  )
                else
                  Text(
                    'Unlock premium features',
                    style: TextStyle(
                      fontSize: FontSizeToken.sm,
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (!isPro)
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: colors.primary,
            ),
        ],
      ),
    );

    if (isPro) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(RadiusToken.md),
      onTap: () {
        Navigator.of(context).pop();
        context.pushNamed(AppRoute.subscription.name);
      },
      child: card,
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
