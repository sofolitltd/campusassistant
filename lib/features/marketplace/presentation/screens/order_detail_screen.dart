import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/orders_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: orderAsync.when(
        data: (order) {
          final stages = ['pending_payment', 'paid', 'processing', 'shipped', 'delivered'];
          final currentIdx = stages.indexOf(order.status);
          final isCancelled = order.status == 'cancelled';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Status timeline
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      if (isCancelled)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Order Cancelled',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        )
                      else
                        Row(
                          children: List.generate(stages.length, (i) {
                            final isActive = i <= currentIdx;
                            final isCurrent = i == currentIdx;
                            return Expanded(
                              child: Column(
                                children: [
                                  if (i > 0)
                                    Container(
                                      height: 2,
                                      color: isActive ? Colors.green : Colors.grey.shade300,
                                    ),
                                  Container(
                                    width: isCurrent ? 14 : 10,
                                    height: isCurrent ? 14 : 10,
                                    decoration: BoxDecoration(
                                      color: isActive ? Colors.green : Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    stages[i].replaceAll('_', '\n'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isCurrent ? 9 : 8,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                      color: isActive ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Shipping info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Shipping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(order.shippingRecipientName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(order.shippingPhone, style: const TextStyle(color: Colors.grey)),
                      Text('${order.shippingAddressLine}, ${order.shippingCity}',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Items
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productTitle,
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text('x${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            Text('৳${item.unitPrice * item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('৳${order.totalAmount}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Could not load order: $e')),
      ),
    );
  }
}
