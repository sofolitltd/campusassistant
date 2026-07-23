import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '../providers/marketplace_provider.dart';

class AddressListScreen extends ConsumerWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => context.push(AppRoute.marketplaceAddressForm.path).then((_) => ref.invalidate(addressesProvider)),
          ),
        ],
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.mapPin, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No addresses saved', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.push(AppRoute.marketplaceAddressForm.path).then((_) => ref.invalidate(addressesProvider)),
                    child: const Text('Add Address'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, i) {
              final address = addresses[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(address.label,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                if (address.isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('Default',
                                        style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${address.recipientName} — ${address.phone}',
                                style: const TextStyle(fontSize: 13)),
                            Text('${address.addressLine}, ${address.city}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          if (!address.isDefault)
                            IconButton(
                              icon: Icon(LucideIcons.star, size: 20, color: Colors.grey.shade400),
                              onPressed: () async {
                                await setDefaultAddress(ref, addressId: address.id);
                                ref.invalidate(addressesProvider);
                              },
                            ),
                          IconButton(
                            icon: Icon(LucideIcons.pencil, size: 18, color: Colors.grey.shade400),
                            onPressed: () => context.push(
                              '/marketplace/addresses/edit/${address.id}',
                              extra: address,
                            ).then((_) => ref.invalidate(addressesProvider)),
                          ),
                          IconButton(
                            icon: Icon(LucideIcons.trash2, size: 18, color: Colors.red.shade300),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Address'),
                                  content: const Text('Are you sure?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await deleteAddress(ref, addressId: address.id);
                                ref.invalidate(addressesProvider);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Could not load addresses: $e')),
      ),
    );
  }
}
