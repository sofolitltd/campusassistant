import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../../../data/models/seller_models.dart';
import '../../providers/seller_provider.dart';
import '../../widgets/rating_widgets.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Is this seller a reliable shipper? Needs a few shipped orders to mean anything.
bool isFastShipper(double avgShipHours, int shippedCount) =>
    shippedCount >= 5 && avgShipHours > 0 && avgShipHours <= 24;

class InsightsTab extends ConsumerStatefulWidget {
  final String merchantId;
  const InsightsTab({super.key, required this.merchantId});

  @override
  ConsumerState<InsightsTab> createState() => _InsightsTabState();
}

class _InsightsTabState extends ConsumerState<InsightsTab> {
  int _days = 30;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final async = ref.watch(
      merchantStatsProvider((merchantId: widget.merchantId, days: _days)),
    );
    final money = NumberFormat.decimalPattern();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(merchantStatsProvider);
        await ref.read(
          merchantStatsProvider((
            merchantId: widget.merchantId,
            days: _days,
          )).future,
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 7, label: Text('7 days')),
              ButtonSegment(value: 30, label: Text('30 days')),
              ButtonSegment(value: 90, label: Text('90 days')),
            ],
            selected: {_days},
            onSelectionChanged: (s) => setState(() => _days = s.first),
          ),
          const SizedBox(height: Spacing.lg),
          async.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(Spacing.xxxxl),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(Spacing.xxxl),
              child: Center(
                child: Text(
                  'Could not load insights.',
                  style: TextStyle(color: c.textSubtle),
                ),
              ),
            ),
            data: (s) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFastShipper(s.avgShipHours, s.shippedCount)) ...[
                  const TrustChip(icon: LucideIcons.zap, label: 'Fast shipper'),
                  const SizedBox(height: Spacing.md),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _Kpi(
                        label: 'Net revenue',
                        value: '৳${money.format(s.netRevenue)}',
                        accent: true,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: _Kpi(label: 'Orders', value: '${s.orders}'),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _Kpi(
                        label: 'Avg order',
                        value: '৳${money.format(s.avgOrderValue)}',
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: _Kpi(label: 'Units sold', value: '${s.units}'),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _Kpi(
                        label: 'Rating',
                        value: s.ratingCount == 0
                            ? '—'
                            : s.ratingAvg.toStringAsFixed(1),
                        sub: s.ratingCount == 0
                            ? 'No reviews yet'
                            : '${s.ratingCount} reviews',
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: _Kpi(
                        label: 'Ships in',
                        value: s.shippedCount == 0
                            ? '—'
                            : _hours(s.avgShipHours),
                        sub: s.shippedCount == 0
                            ? 'No shipped orders yet'
                            : 'avg of ${s.shippedCount} orders',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xl),
                Text(
                  'Revenue',
                  style: TextStyle(
                    fontSize: FontSizeToken.lg,
                    fontWeight: FontWeight.w800,
                    color: c.text,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  'Last $_days days, before commission',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: c.textSubtle,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                _BarChart(points: s.daily),
                const SizedBox(height: Spacing.xxl),
                Text(
                  'Top products',
                  style: TextStyle(
                    fontSize: FontSizeToken.lg,
                    fontWeight: FontWeight.w800,
                    color: c.text,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                if (s.topProducts.isEmpty)
                  Text(
                    'Sales will show up here once orders come in.',
                    style: TextStyle(color: c.textSubtle),
                  )
                else
                  for (final p in s.topProducts) _TopProductRow(product: p),
                if (s.lowStockProducts > 0) ...[
                  const SizedBox(height: Spacing.lg),
                  Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: c.warningSubtle,
                      borderRadius: BorderRadius.circular(RadiusToken.lg),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.triangleAlert,
                          size: 18,
                          color: c.warning,
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: Text(
                            '${s.lowStockProducts} product${s.lowStockProducts == 1 ? ' is' : 's are'} almost out of stock. '
                            'Restock to keep selling.',
                            style: TextStyle(
                              color: c.text,
                              fontSize: FontSizeToken.md,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _hours(double h) {
  if (h < 1) return '<1 hr';
  if (h < 48) return '${h.round()} hr';
  return '${(h / 24).round()} days';
}

class _Kpi extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final bool accent;
  const _Kpi({
    required this.label,
    required this.value,
    this.sub,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: accent ? c.primarySubtle : c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: accent ? c.primary.withValues(alpha: 0.3) : c.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.xs,
              fontWeight: FontWeight.w600,
              color: c.textMuted,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizeToken.xxl,
              fontWeight: FontWeight.w800,
              color: accent ? c.primary : c.text,
            ),
          ),
          if (sub != null)
            Text(sub!, style: TextStyle(fontSize: 10.5, color: c.textSubtle)),
        ],
      ),
    );
  }
}

/// Minimal bar chart: one bar per day, height relative to the best day.
class _BarChart extends StatelessWidget {
  final List<DailyPoint> points;
  const _BarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final max = points.fold<int>(0, (m, p) => p.revenue > m ? p.revenue : m);
    if (max == 0) {
      return Container(
        height: 110,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        child: Text(
          'No sales in this period yet',
          style: TextStyle(color: c.textSubtle, fontSize: FontSizeToken.sm),
        ),
      );
    }
    return Container(
      height: 130,
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.md,
        Spacing.md,
        Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: c.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final p in points)
            Expanded(
              child: Tooltip(
                message:
                    '${p.date}\n৳${p.revenue} · ${p.orders} order${p.orders == 1 ? '' : 's'}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xxs),
                  child: FractionallySizedBox(
                    heightFactor: p.revenue == 0
                        ? 0.02
                        : (p.revenue / max).clamp(0.04, 1.0),
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: p.revenue == 0 ? c.border : c.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(RadiusToken.xs),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopProductRow extends StatelessWidget {
  final TopProduct product;
  const _TopProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final conv = product.views == 0
        ? null
        : (product.units / product.views * 100);
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
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, color: c.text),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  '${product.units} sold · ${product.views} views${conv == null ? '' : ' · ${conv.toStringAsFixed(1)}% bought'}',
                  style: TextStyle(fontSize: 11.5, color: c.textSubtle),
                ),
              ],
            ),
          ),
          Text(
            '৳${NumberFormat.decimalPattern().format(product.revenue)}',
            style: TextStyle(fontWeight: FontWeight.w800, color: c.primary),
          ),
        ],
      ),
    );
  }
}
