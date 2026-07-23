import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '../../data/models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../screens/marketplace_home_screen.dart';
import '../screens/category_grid_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/account_tab.dart';

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
    final cartCount = cartItems.fold(0, (int sum, CartItem item) => sum + item.quantity);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildTab(0, const MarketplaceHomeScreen()),
          _buildTab(1, const CategoryGridScreen()),
          _buildTab(2, const CartScreen()),
          _buildTab(3, const AccountTab()),
        ],
      ),
      bottomNavigationBar: _BlurryMarketplaceNavBar(
        currentIndex: _currentIndex,
        cartCount: cartCount,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
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
    _TabItem(icon: LucideIcons.shoppingCart, label: 'Cart'),
    _TabItem(icon: LucideIcons.userRound, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).appColors.primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.82),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              height: 3,
                              width: isSelected ? 32 : 0,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  tab.icon,
                                  size: 22,
                                  color: isSelected ? primaryColor : Colors.grey,
                                ),
                                if (index == 2 && cartCount > 0)
                                  Positioned(
                                    right: -10,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        cartCount > 99 ? '99+' : cartCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? primaryColor : Colors.grey,
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
