import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/app_colors.dart';

class CustomHeaderLayout extends StatelessWidget {
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;
  final List<Widget>? actions;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final TabController? tabController;
  final List<String>? tabs;
  final Widget body;
  final Widget? searchTrailing;
  final bool showSearchBar;
  final Widget? bottomBar;

  const CustomHeaderLayout({
    super.key,
    required this.title,
    this.actionIcon,
    this.onActionTap,
    this.actions,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.tabController,
    this.tabs,
    required this.body,
    this.searchTrailing,
    this.showSearchBar = true,
    this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = Theme.of(context).appColors.primaryColor;

    return Scaffold(
      // Neutral — NOT primaryColor. The teal header band below is scoped to
      // just the constrained column; if the whole Scaffold were teal, that
      // color would bleed down the full page height in the margins outside
      // the 700px column on wide screens.
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              // AppBar deliberately lives here (a plain widget, not
              // Scaffold.appBar) so it's centered/width-constrained with
              // everything else instead of spanning the full viewport.
              Container(
                color: primaryColor,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        title: Text(title),
                        centerTitle: true,
                        actions:
                            actions ??
                            [
                              if (actionIcon != null)
                                IconButton(
                                  icon: Icon(actionIcon, color: Colors.white),
                                  onPressed: onActionTap,
                                ),
                            ],
                      ),

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
                    ],
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
                              indicatorColor: primaryColor,
                              indicatorWeight: 3,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: isDark
                                  ? Colors.white
                                  : Colors.black87,
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
              ?bottomBar,
            ],
          ),
        ),
      ),
    );
  }
}
