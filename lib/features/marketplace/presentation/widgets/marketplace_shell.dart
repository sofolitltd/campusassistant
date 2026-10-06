import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '../../data/models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'market_theme.dart';
import '../screens/marketplace_home_screen.dart';
import '../screens/category_grid_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/merchants_tab.dart';
import '../screens/account_tab.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class MarketplaceShell extends ConsumerStatefulWidget {
  const MarketplaceShell({super.key});

  @override
  ConsumerState<MarketplaceShell> createState() => _MarketplaceShellState();
}

class _MarketplaceShellState extends ConsumerState<MarketplaceShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartCount = cartItems.fold(
      0,
      (int sum, CartItem item) => sum + item.quantity,
    );

    return MarketTheme(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                _buildTab(0, const MarketplaceHomeScreen()),
                _buildTab(1, const CategoryGridScreen()),
                _buildTab(2, const MerchantsTab()),
                _buildTab(3, const CartScreen()),
                _buildTab(4, const AccountTab()),
              ],
            ),
            bottomNavigationBar: _BlurryMarketplaceNavBar(
              currentIndex: _currentIndex,
              cartCount: cartCount,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, Widget child) {
    if (index == _currentIndex) return child;
    return child;
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}

class _BlurryMarketplaceNavBar extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onDestinationSelected;

  const _BlurryMarketplaceNavBar({
    required this.currentIndex,
    required this.cartCount,
    required this.onDestinationSelected,
  });

  static const _tabs = [
    _TabItem(icon: LucideIcons.house, label: 'Home'),
    _TabItem(icon: LucideIcons.layers, label: 'Categories'),
    _TabItem(icon: LucideIcons.store, label: 'Merchants'),
    _TabItem(icon: LucideIcons.shoppingCart, label: 'Cart'),
    _TabItem(icon: LucideIcons.userRound, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusToken.xxl),
          topRight: Radius.circular(RadiusToken.xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusToken.xxl),
          topRight: Radius.circular(RadiusToken.xxl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.82),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(RadiusToken.xxl),
                topRight: Radius.circular(RadiusToken.xxl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 60,
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final tab = _tabs[index];
                    final isSelected = currentIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onDestinationSelected(index),
                        child: Column(
                          mainAxisAlignment: .start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              height: 3,
                              width: isSelected ? 32 : 0,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(RadiusToken.xs),
                                  bottomRight: Radius.circular(RadiusToken.xs),
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.sm),
                            Stack(
                              clipBehavior: .none,
                              children: [
                                Icon(
                                  tab.icon,
                                  size: 22,
                                  color: isSelected
                                      ? primaryColor
                                      : context.colors.textSubtle,
                                ),
                                if (index == 3 && cartCount > 0)
                                  Positioned(
                                    right: -10,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(Spacing.xs),
                                      decoration: BoxDecoration(
                                        color: context.colors.danger,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        cartCount > 99
                                            ? '99+'
                                            : cartCount.toString(),
                                        style: TextStyle(
                                          color: context.colors.onPrimary,
                                          fontSize: FontSizeToken.xxs,
                                          fontWeight: .bold,
                                        ),
                                        textAlign: .center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: Spacing.xxs),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: FontSizeToken.xs,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? primaryColor
                                    : context.colors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
