import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../../data/models/invoice.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

final myInvoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final response = await ref.watch(apiClientProvider).get('/my/invoices', queryParameters: {'limit': 100});
  final list = (response.data as Map<String, dynamic>)['invoices'] as List? ?? [];
  return list.map((e) => Invoice.fromJson(e as Map<String, dynamic>)).toList();
});

/// Receipts for everything the user has paid for: Pro subscriptions and marketplace orders.
class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(myInvoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices & receipts')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: async.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Could not load invoices.', style: TextStyle(color: c.textSubtle))),
            data: (invoices) {
              if (invoices.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xxxl),
                    child: Text('Receipts for your payments will appear here.', style: TextStyle(color: c.textSubtle)),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(myInvoicesProvider);
                  await ref.read(myInvoicesProvider.future);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Spacing.lg),
                  itemCount: invoices.length,
                  itemBuilder: (context, i) => _InvoiceTile(invoice: invoices[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  const _InvoiceTile({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: c.border),
      ),
      child: ListTile(
        onTap: () => _showDetail(context, invoice),
        leading: CircleAvatar(
          backgroundColor: c.primarySubtle,
          child: Icon(invoice.kind == 'order' ? LucideIcons.shoppingBag : LucideIcons.crown, size: 18, color: c.primary),
        ),
        title: Text(invoice.number, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${invoice.kind == 'order' ? 'Marketplace order' : 'Pro subscription'} · ${DateFormat('d MMM y').format(invoice.issuedAt)}',
          style: TextStyle(fontSize: FontSizeToken.sm, color: c.textSubtle),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('৳${invoice.total}', style: TextStyle(fontWeight: FontWeight.w800, color: c.text)),
            if (invoice.voided) Text('Refunded', style: TextStyle(fontSize: FontSizeToken.xs, fontWeight: FontWeight.w700, color: c.danger)),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Invoice inv) {
    final c = context.colors;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.xl, 0, Spacing.xl, Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(inv.number, style: TextStyle(fontSize: FontSizeToken.xl, fontWeight: FontWeight.w800, color: c.text))),
                  if (inv.voided)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
                      decoration: BoxDecoration(color: c.dangerSubtle, borderRadius: BorderRadius.circular(RadiusToken.full)),
                      child: Text('Refunded', style: TextStyle(color: c.danger, fontSize: FontSizeToken.xs, fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
              Text(DateFormat('d MMM y, h:mm a').format(inv.issuedAt), style: TextStyle(color: c.textSubtle, fontSize: FontSizeToken.sm)),
              const Divider(height: 24),
              for (final l in inv.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: Row(
                    children: [
                      Expanded(child: Text('${l.description}${l.quantity > 1 ? '  ×${l.quantity}' : ''}')),
                      Text('৳${l.total}'),
                    ],
                  ),
                ),
              const Divider(height: 24),
              if (inv.discount > 0) ...[
                _row('Subtotal', '৳${inv.subtotal}', c),
                _row('Discount', '−৳${inv.discount}', c),
              ],
              _row('Total paid', '৳${inv.total}', c, bold: true),
              if (inv.paymentRef.isNotEmpty) ...[
                const SizedBox(height: Spacing.sm),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: inv.paymentRef));
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Transaction id copied')));
                  },
                  child: Row(
                    children: [
                      Text('${inv.paymentMethod.toUpperCase()} TrxID ', style: TextStyle(color: c.textSubtle, fontSize: FontSizeToken.sm)),
                      Text(inv.paymentRef, style: TextStyle(color: c.text, fontSize: FontSizeToken.sm, fontWeight: FontWeight.w700)),
                      const SizedBox(width: Spacing.sm),
                      Icon(LucideIcons.copy, size: 12, color: c.textSubtle),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, AppColors c, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.xs),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: c.text)),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: c.text)),
      ],
    ),
  );
}
