import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '../providers/marketplace_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

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
            onPressed: () => context
                .push(AppRoute.marketplaceAddressForm.path)
                .then((_) => ref.invalidate(addressesProvider)),
          ),
        ],
      ),
      backgroundColor: context.colors.primary,
      body: MarketBody(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: addressesAsync.when(
              data: (addresses) {
                if (addresses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 64,
                          color: context.colors.borderStrong,
                        ),
                        const SizedBox(height: Spacing.lg),
                        const Text(
                          'No addresses saved',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xl,
                          ),
                          child: ElevatedButton(
                            onPressed: () => context
                                .push(AppRoute.marketplaceAddressForm.path)
                                .then((_) => ref.invalidate(addressesProvider)),
                            child: const Text('Add Address'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(Spacing.lg),
                  itemCount: addresses.length,
                  itemBuilder: (context, i) {
                    final address = addresses[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: Spacing.md),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.lg),
                        child: Row(
                          crossAxisAlignment: .start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        address.label,
                                        style: const TextStyle(
                                          fontWeight: .bold,
                                          fontSize: FontSizeToken.base,
                                        ),
                                      ),
                                      if (address.isDefault) ...[
                                        const SizedBox(width: Spacing.sm),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Spacing.sm,
                                            vertical: Spacing.xxs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: context.colors.success
                                                .withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(
                                              RadiusToken.md,
                                            ),
                                          ),
                                          child: Text(
                                            'Default',
                                            style: TextStyle(
                                              fontSize: FontSizeToken.xxs,
                                              color: context.colors.success,
                                              fontWeight: .w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    '${address.recipientName} — ${address.phone}',
                                    style: const TextStyle(
                                      fontSize: FontSizeToken.md,
                                    ),
                                  ),
                                  Text(
                                    '${address.addressLine}, ${address.city}',
                                    style: TextStyle(
                                      fontSize: FontSizeToken.sm,
                                      color: context.colors.textSubtle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                if (!address.isDefault)
                                  IconButton(
                                    icon: Icon(
                                      LucideIcons.star,
                                      size: 20,
                                      color: context.colors.textSubtle,
                                    ),
                                    onPressed: () async {
                                      await setDefaultAddress(
                                        ref,
                                        addressId: address.id,
                                      );
                                      ref.invalidate(addressesProvider);
                                    },
                                  ),
                                IconButton(
                                  icon: Icon(
                                    LucideIcons.pencil,
                                    size: 18,
                                    color: context.colors.textSubtle,
                                  ),
                                  onPressed: () => context
                                      .push(
                                        '/campusmarket/addresses/edit/${address.id}',
                                        extra: address,
                                      )
                                      .then(
                                        (_) =>
                                            ref.invalidate(addressesProvider),
                                      ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    LucideIcons.trash2,
                                    size: 18,
                                    color: context.colors.danger,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Address'),
                                        content: const Text('Are you sure?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await deleteAddress(
                                        ref,
                                        addressId: address.id,
                                      );
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
              error: (e, _) =>
                  Center(child: Text('Could not load addresses: $e')),
            ),
          ),
        ),
      ),
    );
  }
}
