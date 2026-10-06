import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/routes/app_route.dart';
import '../../data/models/merchant.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/market_theme.dart';
import '../widgets/rating_widgets.dart';

/// Every approved merchant selling on campus; tap one to open its storefront.
class MerchantsTab extends ConsumerWidget {
  const MerchantsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(merchantsListProvider);

    return Scaffold(
      backgroundColor: context.colors.primary,
      appBar: AppBar(title: const Text('Merchants')),
      body: MarketBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(merchantsListProvider);
            await ref.read(merchantsListProvider.future);
          },
          child: merchantsAsync.when(
            data: (merchants) {
              if (merchants.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('No merchants yet.')),
                  ],
                );
              }
              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(Spacing.lg),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  mainAxisExtent: 196,
                ),
                itemCount: merchants.length,
                itemBuilder: (context, i) =>
                    _MerchantCard(merchant: merchants[i]),
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Could not load merchants.')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MerchantCard extends StatelessWidget {
  final Merchant merchant;
  const _MerchantCard({required this.merchant});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.marketplaceMerchantProfile.name,
        pathParameters: {'merchantId': merchant.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(RadiusToken.xl),
          border: Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color: c.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: c.primarySubtle,
                shape: BoxShape.circle,
                border: Border.all(color: c.primary.withValues(alpha: 0.3)),
              ),
              clipBehavior: Clip.antiAlias,
              child: merchant.logoUrl.isNotEmpty
                  ? Image.network(
                      ApiEndpoints.resolveImageUrl(merchant.logoUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(LucideIcons.store, color: c.primary),
                    )
                  : Icon(LucideIcons.store, color: c.primary),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              merchant.isPlatform ? 'Campus Assistant' : merchant.businessName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: FontWeight.w700,
                color: c.text,
              ),
            ),
            if (merchant.businessType.isNotEmpty) ...[
              const SizedBox(height: Spacing.xxs),
              Text(
                merchant.businessType,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontSizeToken.xs,
                  color: c.textMuted,
                ),
              ),
            ],
            const SizedBox(height: Spacing.sm),
            if (merchant.ratingCount > 0)
              RatingBadge(
                average: merchant.ratingAvg,
                count: merchant.ratingCount,
              )
            else
              Text(
                'New merchant',
                style: TextStyle(
                  fontSize: FontSizeToken.xs,
                  color: c.textSubtle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
