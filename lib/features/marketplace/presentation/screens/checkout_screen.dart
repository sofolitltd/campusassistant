import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/address.dart';
import '../providers/cart_provider.dart';
import '../providers/marketplace_provider.dart';
import '../providers/orders_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  Address? _selectedAddress;
  MarketplacePaymentMethod _paymentMethod = MarketplacePaymentMethod.bkash;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(addressesProvider);
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          addressesAsync.when(
            data: (addresses) {
              final defaultAddr = addresses.where((a) => a.isDefault).firstOrNull;
              _selectedAddress ??= defaultAddr ?? addresses.firstOrNull;

              if (_selectedAddress == null) {
                return GestureDetector(
                  onTap: () => context.push(AppRoute.marketplaceAddressForm.path).then((_) => ref.invalidate(addressesProvider)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(RadiusToken.md),
                      color: Colors.grey.shade50,
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.plus, size: 20),
                        SizedBox(width: 8),
                        Text('Add a shipping address'),
                      ],
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => context.push(AppRoute.marketplaceAddresses.path).then((_) {
                  ref.invalidate(addressesProvider);
                  setState(() { _selectedAddress = null; });
                }),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_selectedAddress!.label} — ${_selectedAddress!.recipientName}',
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(_selectedAddress!.phone, style: const TextStyle(color: Colors.grey)),
                            Text('${_selectedAddress!.addressLine}, ${_selectedAddress!.city}',
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight),
                    ],
                  ),
                ),
              );
            },
            loading: () => const CupertinoActivityIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 24),
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...cartItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${item.product.title} x${item.quantity}',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Text('৳${item.totalPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('৳$totalAmount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _PaymentMethodTile(
            icon: LucideIcons.smartphone,
            title: 'Pay with bKash',
            subtitle: 'Pay online now via bKash',
            selected: _paymentMethod == MarketplacePaymentMethod.bkash,
            onTap: _isProcessing
                ? null
                : () => setState(() => _paymentMethod = MarketplacePaymentMethod.bkash),
          ),
          const SizedBox(height: 10),
          _PaymentMethodTile(
            icon: LucideIcons.banknote,
            title: 'Cash on Delivery',
            subtitle: 'Pay in cash when your order arrives',
            selected: _paymentMethod == MarketplacePaymentMethod.cashOnDelivery,
            onTap: _isProcessing
                ? null
                : () => setState(() => _paymentMethod = MarketplacePaymentMethod.cashOnDelivery),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAddress == null || _isProcessing ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CupertinoActivityIndicator())
                  : Text(
                      _paymentMethod == MarketplacePaymentMethod.bkash
                          ? 'Place Order — Pay with bKash'
                          : 'Place Order — Cash on Delivery',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) return;

    setState(() => _isProcessing = true);

    try {
      final orderResult = await checkout(
        ref,
        addressId: _selectedAddress!.id,
        paymentMethod: _paymentMethod,
        items: [
          for (final item in ref.read(cartProvider))
            {'product_id': item.product.id, 'quantity': item.quantity},
        ],
      );

      // Cash on delivery skips the bKash gateway entirely — the order is
      // already placed on the backend, so there's nothing left to confirm.
      if (_paymentMethod == MarketplacePaymentMethod.cashOnDelivery) {
        if (!mounted) return;

        ref.read(cartProvider.notifier).clear();
        ref.invalidate(ordersListProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed! Pay in cash on delivery.'), backgroundColor: Colors.green),
        );
        context.pop();
        return;
      }

      final paymentData = await createMarketplacePayment(ref, orderResult.orderId);

      if (!mounted) return;

      final webViewResult = await context.push<String?>(
        AppRoute.bkashWebView.path,
        extra: {
          'url': paymentData['bkash_url'] as String,
          'successURL': paymentData['success_url'] as String? ?? '',
          'failureURL': paymentData['failure_url'] as String? ?? '',
          'cancelURL': paymentData['cancel_url'] as String? ?? '',
        },
      );

      if (webViewResult == 'success') {
        await executeMarketplacePayment(ref, paymentData['payment_id'] as String);
        if (!mounted) return;

        ref.read(cartProvider.notifier).clear();
        ref.invalidate(ordersListProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful! Order placed.'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? theme.colorScheme.primary.withValues(alpha: 0.08) : theme.cardColor,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(
              color: selected ? theme.colorScheme.primary : Colors.grey.shade300,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: selected ? theme.colorScheme.primary : Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? theme.colorScheme.primary : Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
