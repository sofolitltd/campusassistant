import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/marketplace_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/reviews_provider.dart';
import '../widgets/rating_widgets.dart';
import '../widgets/review_sheet.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      backgroundColor: context.colors.primary,
      body: MarketBody(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: orderAsync.when(
              data: (order) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(orderDetailsProvider(orderId));
                  await ref.read(orderDetailsProvider(orderId).future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Spacing.lg),
                  children: [
                    _Timeline(order: order),
                    const SizedBox(height: Spacing.md),
                    if (order.status == 'delivered') ...[
                      _RateItems(orderId: order.id),
                      const SizedBox(height: Spacing.md),
                    ],
                    _SectionCard(
                      title: 'Shipping',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.shippingRecipientName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            order.shippingPhone,
                            style: TextStyle(color: context.colors.textSubtle),
                          ),
                          Text(
                            '${order.shippingAddressLine}, ${order.shippingCity}',
                            style: TextStyle(color: context.colors.textSubtle),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    _SectionCard(
                      title: 'Items',
                      child: Column(
                        children: [
                          ...order.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: Spacing.sm,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'x${item.quantity}',
                                          style: TextStyle(
                                            color: context.colors.textSubtle,
                                            fontSize: FontSizeToken.sm,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '৳${item.unitPrice * item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSizeToken.lg,
                                ),
                              ),
                              Text(
                                '৳${order.totalAmount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSizeToken.lg,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    _Actions(order: order),
                  ],
                ),
              ),
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('Could not load order: $e')),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSizeToken.lg,
            ),
          ),
          const SizedBox(height: Spacing.md),
          child,
        ],
      ),
    ),
  );
}

// ─── Timeline ────────────────────────────────────────────────────────────

class _Stage {
  final String status;
  final String label;
  final String hint;
  const _Stage(this.status, this.label, this.hint);
}

/// Cash-on-delivery orders are live from the start, so they skip the payment steps.
List<_Stage> _stagesFor(Order order) {
  if (order.paymentMethod == 'cash_on_delivery') {
    return const [
      _Stage(
        'processing',
        'Order placed',
        'The seller is preparing your order',
      ),
      _Stage('shipped', 'On the way', 'Your order has been shipped'),
      _Stage('delivered', 'Delivered', 'Pay the seller on delivery'),
    ];
  }
  return const [
    _Stage('pending_payment', 'Order placed', 'Waiting for your bKash payment'),
    _Stage('paid', 'Payment received', 'The seller will start preparing it'),
    _Stage('processing', 'Preparing', 'The seller is getting it ready'),
    _Stage('shipped', 'On the way', 'Your order has been shipped'),
    _Stage('delivered', 'Delivered', 'Enjoy! Leave a review below'),
  ];
}

class _Timeline extends StatelessWidget {
  final Order order;
  const _Timeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stages = _stagesFor(order);
    final cancelled = order.status == 'cancelled';
    final currentIdx = stages.indexWhere((s) => s.status == order.status);
    final fmt = DateFormat('d MMM, h:mm a');

    Widget row(int i, _Stage stage) {
      final reached = !cancelled && i <= currentIdx;
      final current = !cancelled && i == currentIdx;
      final at = order.reachedAt(stage.status);
      final last = i == stages.length - 1 && !cancelled;
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  Container(
                    width: current ? 18 : 14,
                    height: current ? 18 : 14,
                    margin: const EdgeInsets.only(top: Spacing.xxs),
                    decoration: BoxDecoration(
                      color: reached ? c.success : c.surface,
                      border: Border.all(
                        color: reached ? c.success : c.borderStrong,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: reached
                        ? Icon(Icons.check, size: 10, color: c.onSuccess)
                        : null,
                  ),
                  if (!last)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: reached && i < currentIdx ? c.success : c.border,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: Spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.label,
                      style: TextStyle(
                        fontWeight: current ? FontWeight.w800 : FontWeight.w600,
                        color: reached ? c.text : c.textSubtle,
                      ),
                    ),
                    Text(
                      at != null ? fmt.format(at) : (current ? stage.hint : ''),
                      style: TextStyle(
                        fontSize: FontSizeToken.sm,
                        color: c.textSubtle,
                      ),
                    ),
                    if (current && at != null)
                      Text(
                        stage.hint,
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _SectionCard(
      title: 'Order status',
      child: Column(
        children: [
          for (var i = 0; i < stages.length; i++) row(i, stages[i]),
          if (cancelled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: c.dangerSubtle,
                borderRadius: BorderRadius.circular(RadiusToken.md),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.circleX, size: 18, color: c.danger),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      '${order.reachedAt('paid') != null ? 'Cancelled and refunded' : 'Cancelled'}'
                      '${order.reachedAt('cancelled') != null ? ' on ${fmt.format(order.reachedAt('cancelled')!)}' : ''}',
                      style: TextStyle(
                        color: c.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Rate items ──────────────────────────────────────────────────────────

class _RateItems extends ConsumerWidget {
  final String orderId;
  const _RateItems({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final items = ref.watch(orderReviewableProvider(orderId)).value ?? const [];
    if (items.isEmpty) return const SizedBox.shrink();

    return _SectionCard(
      title: 'Rate your items',
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.productTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.myRating != null)
                    StarRow(rating: item.myRating!.toDouble(), size: 15),
                  TextButton(
                    onPressed: () async {
                      // Load the existing review so editing keeps the comment.
                      final existing = item.myRating == null
                          ? null
                          : (await ref.read(
                              productReviewsProvider(item.productId).future,
                            )).myReview;
                      if (!context.mounted) return;
                      await showReviewSheet(
                        context,
                        productId: item.productId,
                        productTitle: item.productTitle,
                        existing: existing,
                      );
                    },
                    child: Text(
                      item.myRating == null ? 'Rate' : 'Edit',
                      style: TextStyle(color: c.primary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Actions: cancel / reorder ───────────────────────────────────────────

class _Actions extends ConsumerStatefulWidget {
  final Order order;
  const _Actions({required this.order});

  @override
  ConsumerState<_Actions> createState() => _ActionsState();
}

class _ActionsState extends ConsumerState<_Actions> {
  bool _busy = false;

  void _snack(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _cancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this order?'),
        content: const Text(
          'The seller will be told and the order will be closed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Cancel Order',
              style: TextStyle(color: ctx.colors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await cancelOrder(ref, widget.order.id);
    } catch (_) {
      if (mounted) _snack('This order can no longer be cancelled.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Puts every still-available item back in the cart at current prices.
  Future<void> _reorder() async {
    setState(() => _busy = true);
    var added = 0, skipped = 0;
    for (final line in widget.order.items) {
      try {
        final product = await ref.read(
          productDetailsProvider(line.productId).future,
        );
        if (!product.isPublished || product.stock <= 0) {
          skipped++;
          continue;
        }
        final qty = line.quantity > product.stock
            ? product.stock
            : line.quantity;
        ref.read(cartProvider.notifier).addItem(product, quantity: qty);
        added++;
      } catch (_) {
        skipped++;
      }
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (added == 0) {
      _snack('None of these items are available right now.');
      return;
    }
    if (skipped > 0) {
      _snack('$skipped item${skipped == 1 ? '' : 's'} no longer available.');
    }
    context.push(AppRoute.marketplaceCart.path);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final done = order.status == 'delivered' || order.status == 'cancelled';
    return Column(
      children: [
        if (order.canCancel)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _busy ? null : _cancel,
              icon: const Icon(LucideIcons.x, size: 16),
              label: const Text('Cancel Order'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.danger,
              ),
            ),
          ),
        if (done) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _busy ? null : _reorder,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: Text(_busy ? 'Adding…' : 'Order again'),
            ),
          ),
        ],
      ],
    );
  }
}
