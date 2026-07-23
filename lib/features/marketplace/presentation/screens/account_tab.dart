import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '../providers/marketplace_provider.dart';

class AccountTab extends ConsumerWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantAsync = ref.watch(myMerchantProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ListTile(
            icon: LucideIcons.shoppingBag,
            title: 'My Orders',
            subtitle: 'View your order history and tracking',
            onTap: () => context.push(AppRoute.marketplaceOrders.path),
          ),
          const SizedBox(height: 8),
          _ListTile(
            icon: LucideIcons.mapPin,
            title: 'Manage Addresses',
            subtitle: 'Add, edit, or remove shipping addresses',
            onTap: () => context.push(AppRoute.marketplaceAddresses.path),
          ),
          const SizedBox(height: 8),
          merchantAsync.when(
            data: (merchant) {
              if (merchant != null) {
                return _ListTile(
                  icon: LucideIcons.store,
                  title: 'My Merchant Profile',
                  subtitle: merchant.businessName,
                  onTap: () => context.push(AppRoute.merchantApply.path),
                );
              }
              return _ListTile(
                icon: LucideIcons.store,
                title: 'Become a Merchant',
                subtitle: 'Sell your products on campus',
                onTap: () => context.push(AppRoute.merchantApply.path),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, _) => _ListTile(
              icon: LucideIcons.store,
              title: 'Become a Merchant',
              subtitle: 'Sell your products on campus',
              onTap: () => context.push(AppRoute.merchantApply.path),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(LucideIcons.chevronRight, size: 18),
        onTap: onTap,
      ),
    );
  }
}
