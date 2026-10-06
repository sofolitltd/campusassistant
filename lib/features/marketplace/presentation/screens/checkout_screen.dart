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
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

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
      backgroundColor: context.colors.primary,
      body: MarketBody(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(Spacing.lg),
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontWeight: .bold,
                    fontSize: FontSizeToken.lg,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                addressesAsync.when(
                  data: (addresses) {
                    final defaultAddr = addresses
                        .where((a) => a.isDefault)
                        .firstOrNull;
                    _selectedAddress ??= defaultAddr ?? addresses.firstOrNull;

                    if (_selectedAddress == null) {
                      return GestureDetector(
                        onTap: () => context
                            .push(AppRoute.marketplaceAddressForm.path)
                            .then((_) => ref.invalidate(addressesProvider)),
                        child: Container(
                          padding: const EdgeInsets.all(Spacing.lg),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colors.borderStrong,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(RadiusToken.md),
                            color: context.colors.surfaceAlt,
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.plus, size: 20),
                              SizedBox(width: Spacing.sm),
                              Text('Add a shipping address'),
                            ],
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () => context
                          .push(AppRoute.marketplaceAddresses.path)
                          .then((_) {
                            ref.invalidate(addressesProvider);
                            setState(() {
                              _selectedAddress = null;
                            });
                          }),
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.colors.borderStrong,
                          ),
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    '${_selectedAddress!.label} — ${_selectedAddress!.recipientName}',
                                    style: const TextStyle(fontWeight: .w600),
                                  ),
                                  Text(
                                    _selectedAddress!.phone,
                                    style: TextStyle(
                                      color: context.colors.textSubtle,
                                    ),
                                  ),
                                  Text(
                                    '${_selectedAddress!.addressLine}, ${_selectedAddress!.city}',
                                    style: TextStyle(
                                      color: context.colors.textSubtle,
                                    ),
                                  ),
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
                const SizedBox(height: Spacing.xxl),
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontWeight: .bold,
                    fontSize: FontSizeToken.lg,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                ...cartItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.product.title} x${item.quantity}',
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                        ),
                        Text(
                          '৳${item.totalPrice}',
                          style: const TextStyle(fontWeight: .bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: .bold,
                        fontSize: FontSizeToken.lg,
                      ),
                    ),
                    Text(
                      '৳$totalAmount',
                      style: const TextStyle(
                        fontWeight: .bold,
                        fontSize: FontSizeToken.lg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xxl),
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontWeight: .bold,
                    fontSize: FontSizeToken.lg,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                _PaymentMethodTile(
                  icon: LucideIcons.smartphone,
                  title: 'Pay with bKash',
                  subtitle: 'Pay online now via bKash',
                  selected: _paymentMethod == MarketplacePaymentMethod.bkash,
                  onTap: _isProcessing
                      ? null
                      : () => setState(
                          () => _paymentMethod = MarketplacePaymentMethod.bkash,
                        ),
                ),
                const SizedBox(height: Spacing.md),
                _PaymentMethodTile(
                  icon: LucideIcons.banknote,
                  title: 'Cash on Delivery',
                  subtitle: 'Pay in cash when your order arrives',
                  selected:
                      _paymentMethod == MarketplacePaymentMethod.cashOnDelivery,
                  onTap: _isProcessing
                      ? null
                      : () => setState(
                          () => _paymentMethod =
                              MarketplacePaymentMethod.cashOnDelivery,
                        ),
                ),
                const SizedBox(height: Spacing.xxxl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedAddress == null || _isProcessing
                        ? null
                        : _placeOrder,
                    style: ElevatedButton.styleFrom(),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CupertinoActivityIndicator(),
                          )
                        : Text(
                            _paymentMethod == MarketplacePaymentMethod.bkash
                                ? 'Place Order — Pay with bKash'
                                : 'Place Order — Cash on Delivery',
                            style: const TextStyle(
                              fontWeight: .bold,
                              fontSize: FontSizeToken.lg,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          SnackBar(
            content: Text('Order placed! Pay in cash on delivery.'),
            backgroundColor: context.colors.success,
          ),
        );
        context.pop();
        return;
      }

      final paymentData = await createMarketplacePayment(
        ref,
        orderResult.orderId,
      );

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
        await executeMarketplacePayment(
          ref,
          paymentData['payment_id'] as String,
        );
        if (!mounted) return;

        ref.read(cartProvider.notifier).clear();
        ref.invalidate(ordersListProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful! Order placed.'),
            backgroundColor: context.colors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: context.colors.danger,
        ),
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
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.08)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : context.colors.borderStrong,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? theme.colorScheme.primary
                    : context.colors.textMuted,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: .w600,
                        fontSize: FontSizeToken.base,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: FontSizeToken.sm,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? theme.colorScheme.primary
                    : context.colors.textSubtle,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
