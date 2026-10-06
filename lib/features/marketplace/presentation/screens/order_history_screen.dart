import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/orders_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'pending_payment':
        return context.colors.warning;
      case 'paid':
        return context.colors.info;
      case 'processing':
        return context.colors.info;
      case 'shipped':
        return AccentToken.violet;
      case 'delivered':
        return context.colors.success;
      case 'cancelled':
        return context.colors.danger;
      default:
        return context.colors.textSubtle;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending_payment':
        return 'Pending Payment';
      case 'paid':
        return 'Paid';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ordersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        LucideIcons.shoppingBag,
                        size: 64,
                        color: context.colors.borderStrong,
                      ),
                      const SizedBox(height: Spacing.lg),
                      const Text(
                        'No orders yet',
                        style: TextStyle(
                          fontSize: FontSizeToken.xl,
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(Spacing.lg),
                itemCount: orders.length,
                itemBuilder: (context, i) {
                  final order = orders[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: Spacing.md),
                    child: ListTile(
                      title: Text(
                        'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                        style: const TextStyle(fontWeight: .w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '৳${order.totalAmount}',
                            style: const TextStyle(fontWeight: .bold),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: Spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                context,
                                order.status,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                RadiusToken.lg,
                              ),
                            ),
                            child: Text(
                              _statusLabel(order.status),
                              style: TextStyle(
                                fontSize: FontSizeToken.xs,
                                fontWeight: .w600,
                                color: _statusColor(context, order.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(LucideIcons.chevronRight, size: 18),
                      onTap: () =>
                          context.push('/campusmarket/orders/${order.id}'),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('Could not load orders: $e')),
          ),
        ),
      ),
    );
  }
}
