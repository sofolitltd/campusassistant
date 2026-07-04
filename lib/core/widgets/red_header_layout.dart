import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RedHeaderLayout extends StatelessWidget {
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final TabController? tabController;
  final List<String>? tabs;
  final Widget body;
  final Widget? searchTrailing;
  final bool showSearchBar;

  const RedHeaderLayout({
    super.key,
    required this.title,
    this.actionIcon,
    this.onActionTap,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.tabController,
    this.tabs,
    required this.body,
    this.searchTrailing,
    this.showSearchBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryRed = const Color(0xFFD32F2F);

    return Scaffold(
      backgroundColor: primaryRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (actionIcon != null)
            IconButton(
              icon: Icon(actionIcon, color: Colors.white),
              onPressed: onActionTap,
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Area
          if (showSearchBar)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  suffixIcon: searchTrailing,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // White Body Area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.scaffoldBackgroundColor
                    : const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Column(
                  children: [
                    if (tabs != null && tabController != null)
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? theme.scaffoldBackgroundColor
                              : Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: TabBar(
                          controller: tabController,
                          isScrollable: tabs!.length > 3,
                          indicatorColor: primaryRed,
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: isDark ? Colors.white : Colors.black87,
                          unselectedLabelColor: isDark
                              ? Colors.white54
                              : Colors.grey.shade500,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          tabs: tabs!.map((t) => Tab(text: t)).toList(),
                        ),
                      ),

                    Expanded(child: body),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
