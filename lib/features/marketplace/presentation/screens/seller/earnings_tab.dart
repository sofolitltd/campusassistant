import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../../../data/models/seller_models.dart';
import '../../providers/orders_provider.dart';
import '../../providers/seller_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class EarningsTab extends ConsumerWidget {
  final String merchantId;
  const EarningsTab({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final earnings = ref.watch(merchantEarningsProvider(merchantId));
    final payouts = ref.watch(merchantPayoutsProvider(merchantId));
    final orders = ref.watch(merchantOrdersProvider(merchantId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(merchantEarningsProvider(merchantId));
        ref.invalidate(merchantPayoutsProvider(merchantId));
        ref.invalidate(merchantOrdersProvider(merchantId));
        await ref.read(merchantEarningsProvider(merchantId).future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          earnings.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.all(Spacing.xxl),
              child: Center(
                child: Text(
                  'Could not load your balance.',
                  style: TextStyle(color: c.textSubtle),
                ),
              ),
            ),
            data: (e) => _BalanceCard(earnings: e, merchantId: merchantId),
          ),
          const SizedBox(height: Spacing.md),
          _FeeCard(merchantId: merchantId),
          const SizedBox(height: Spacing.xl),
          Text(
            'Payouts',
            style: TextStyle(
              fontSize: FontSizeToken.lg,
              fontWeight: FontWeight.w800,
              color: c.text,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          payouts.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (_, _) => Text(
              'Could not load payouts.',
              style: TextStyle(color: c.textSubtle),
            ),
            data: (list) => list.isEmpty
                ? Text(
                    'No payouts yet. Your first request will appear here.',
                    style: TextStyle(color: c.textSubtle),
                  )
                : Column(
                    children: [for (final p in list) _PayoutRow(payout: p)],
                  ),
          ),
          const SizedBox(height: Spacing.xl),
          Text(
            'Completed sales',
            style: TextStyle(
              fontSize: FontSizeToken.lg,
              fontWeight: FontWeight.w800,
              color: c.text,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          orders.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (list) {
              final done = list.where((o) => o.status == 'delivered').toList();
              if (done.isEmpty) {
                return Text(
                  'Delivered orders and what you earn from them will show here.',
                  style: TextStyle(color: c.textSubtle),
                );
              }
              return Column(
                children: [
                  for (final o in done)
                    Container(
                      margin: const EdgeInsets.only(bottom: Spacing.sm),
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                        border: Border.all(color: c.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${o.id.substring(0, o.id.length < 8 ? o.id.length : 8)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: c.text,
                                  ),
                                ),
                                Text(
                                  '${o.items.length} item${o.items.length == 1 ? '' : 's'} · gross ৳${o.items.fold<int>(0, (s, i) => s + i.totalPrice)}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: c.textSubtle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '৳${o.items.fold<double>(0, (s, i) => s + i.netPayout).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: c.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends ConsumerStatefulWidget {
  final Earnings earnings;
  final String merchantId;
  const _BalanceCard({required this.earnings, required this.merchantId});

  @override
  ConsumerState<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<_BalanceCard> {
  bool _busy = false;

  Future<void> _request() async {
    final e = widget.earnings;
    final controller = TextEditingController(text: '${e.balance}');
    final amount = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available ৳${e.balance} · minimum ৳${e.minPayout}',
              style: TextStyle(
                color: ctx.colors.textMuted,
                fontSize: FontSizeToken.md,
              ),
            ),
            const SizedBox(height: Spacing.md),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                prefixText: '৳ ',
                labelText: 'Amount',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(controller.text)),
            child: const Text('Request'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await requestPayout(ref, merchantId: widget.merchantId, amount: amount);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Payout requested. We will send it to your payout account.',
            ),
          ),
        );
      }
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiErrorMessage(err))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final e = widget.earnings;
    final canRequest = e.hasPayoutAccount && e.balance >= e.minPayout && !_busy;
    final hint = !e.hasPayoutAccount
        ? 'Add a payout account in your business profile to request payouts.'
        : e.balance < e.minPayout
        ? 'You can request a payout once you reach ৳${e.minPayout}.'
        : null;

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.primary, c.primaryPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RadiusToken.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available balance',
            style: TextStyle(
              color: c.onPrimary.withValues(alpha: 0.85),
              fontSize: FontSizeToken.sm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            '৳${NumberFormat.decimalPattern().format(e.balance)}',
            style: TextStyle(
              color: c.onPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canRequest ? _request : null,
              icon: _busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.banknote, size: 16),
              label: const Text('Request Payout'),
              style: FilledButton.styleFrom(
                backgroundColor: c.onPrimary,
                foregroundColor: c.primary,
                disabledBackgroundColor: c.onPrimary.withValues(alpha: 0.3),
                disabledForegroundColor: c.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              hint,
              style: TextStyle(
                color: c.onPrimary.withValues(alpha: 0.85),
                fontSize: 11.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PayoutRow extends StatelessWidget {
  final Payout payout;
  const _PayoutRow({required this.payout});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (label, fg, bg) = switch (payout.status) {
      'paid' => ('Paid', c.success, c.successSubtle),
      'rejected' => ('Rejected', c.danger, c.dangerSubtle),
      _ => ('Pending', c.warning, c.warningSubtle),
    };
    final detail = payout.status == 'paid' && payout.reference.isNotEmpty
        ? 'Ref ${payout.reference}'
        : payout.status == 'rejected' && payout.note.isNotEmpty
        ? payout.note
        : '${payout.method.toUpperCase()} ${payout.account}';
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '৳${payout.amount}',
                  style: TextStyle(fontWeight: FontWeight.w800, color: c.text),
                ),
                Text(
                  '${DateFormat('d MMM y').format(payout.createdAt)} · $detail',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: c.textSubtle),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(RadiusToken.full),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: FontSizeToken.xs,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The seller's current commission, with the new-seller promo countdown.
class _FeeCard extends ConsumerWidget {
  final String merchantId;
  const _FeeCard({required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final info = ref.watch(merchantCommissionProvider(merchantId)).value;
    if (info == null) return const SizedBox.shrink();

    final text = info.onPromo
        ? 'You pay ${formatPercent(info.rate)} commission for ${info.promoDaysLeft} more day${info.promoDaysLeft == 1 ? '' : 's'}, '
              'then ${formatPercent(info.baseRate)}.'
        : 'Your commission is ${formatPercent(info.baseRate)} of each delivered sale.';
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: info.onPromo ? c.successSubtle : c.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Row(
        children: [
          Icon(
            info.onPromo ? LucideIcons.sparkles : LucideIcons.percent,
            size: 18,
            color: info.onPromo ? c.success : c.textMuted,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.5, color: c.text, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
