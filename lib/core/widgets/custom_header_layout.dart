import 'package:flutter/material.dart';
import '/core/widgets/glass_search_bar.dart';
import '/core/widgets/search_outline.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/widgets/search_clear_suffix.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CustomHeaderLayout extends StatefulWidget {
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

  /// Puts the search field in a floating glass capsule at the bottom of the
  /// sheet (above the keyboard when it opens) instead of at the top.
  final bool searchAtBottom;

  /// Uses the glass capsule style for the search field even when it stays at
  /// the top of the page.
  final bool glassSearch;

  /// With [searchAtBottom]: a glass circle button beside the capsule (e.g. a
  /// filter). Build it with [GlassCircleButton].
  final Widget? searchAction;
  final Widget? bottomBar;
  // Optional: when provided, an (X) clear button replaces [searchTrailing]
  // whenever the field has text, clearing the controller and calling
  // [onClear] (falling back to `onSearchChanged('')`). Omitted by every
  // pre-existing caller, so behavior for them is unchanged.
  final TextEditingController? controller;
  final VoidCallback? onClear;

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
    this.searchAtBottom = false,
    this.glassSearch = false,
    this.searchAction,
    this.bottomBar,
    this.controller,
    this.onClear,
  });

  @override
  State<CustomHeaderLayout> createState() => _CustomHeaderLayoutState();
}

class _CustomHeaderLayoutState extends State<CustomHeaderLayout> {
  // Callers that don't pass a controller still get the clear (X) button via
  // this one.
  TextEditingController? _ownController;
  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void dispose() {
    _ownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final actionIcon = widget.actionIcon;
    final onActionTap = widget.onActionTap;
    final actions = widget.actions;
    final searchHint = widget.searchHint;
    final onSearchChanged = widget.onSearchChanged;
    final tabController = widget.tabController;
    final tabs = widget.tabs;
    final body = widget.body;
    final searchTrailing = widget.searchTrailing;
    final showSearchBar = widget.showSearchBar;
    final bottomBar = widget.bottomBar;
    final onClear = widget.onClear;
    final controller = _controller;
    final theme = Theme.of(context);
    final colors = context.colors;

    return Scaffold(
      // Neutral — NOT primaryColor. The teal header band below is scoped to
      // just the constrained column; if the whole Scaffold were teal, that
      // color would bleed down the full page height in the margins outside
      // the 700px column on wide screens.
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: HeaderGradientBackdrop(
            child: Column(
              children: [
                // AppBar deliberately lives here (a plain widget, not
                // Scaffold.appBar) so it's centered/width-constrained with
                // everything else instead of spanning the full viewport.
                SafeArea(
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
                                  icon: Icon(
                                    actionIcon,
                                    color: colors.onPrimary,
                                  ),
                                  onPressed: onActionTap,
                                ),
                            ],
                      ),
                    ],
                  ),
                ),

                // White Body Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.bg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(RadiusToken.xxxl),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(RadiusToken.xxxl),
                      ),
                      child: Column(
                        children: [
                          // Search lives at the top of the body (above any tabs), not in the
                          // teal header, so it reads as part of the content it filters.
                          if (showSearchBar &&
                              !widget.searchAtBottom &&
                              widget.glassSearch)
                            GlassSearchBar(
                              atTop: true,
                              controller: controller,
                              hint: searchHint,
                              trailing: searchTrailing,
                              action: widget.searchAction,
                              onChanged: onSearchChanged,
                              onClear: onClear,
                            ),
                          if (showSearchBar &&
                              !widget.searchAtBottom &&
                              !widget.glassSearch)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.lg,
                                Spacing.lg,
                                Spacing.lg,
                                Spacing.sm,
                              ),
                              child: TextField(
                                controller: controller,
                                onChanged: onSearchChanged,
                                style: TextStyle(color: colors.text),
                                decoration: InputDecoration(
                                  hintText: searchHint,
                                  enabledBorder: searchOutline(context),
                                  hintStyle: TextStyle(
                                    color: colors.textSubtle,
                                    fontSize: FontSizeToken.lg,
                                  ),
                                  prefixIcon: Icon(
                                    LucideIcons.search,
                                    color: colors.textSubtle,
                                    size: 20,
                                  ),
                                  suffixIcon:
                                      ValueListenableBuilder<TextEditingValue>(
                                        valueListenable: controller,
                                        builder: (context, value, _) =>
                                            SearchClearSuffix(
                                              visible: value.text.isNotEmpty,
                                              trailing: searchTrailing,
                                              onClear: () {
                                                controller.clear();
                                                if (onClear != null) {
                                                  onClear();
                                                } else {
                                                  onSearchChanged?.call('');
                                                }
                                              },
                                            ),
                                      ),
                                  suffixIconConstraints:
                                      SearchClearSuffix.constraints(),
                                ),
                              ),
                            ),

                          if (tabs != null && tabController != null)
                            Container(
                              decoration: BoxDecoration(
                                color: colors.surface,
                                border: Border(
                                  bottom: BorderSide(
                                    color: colors.border,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: TabBar(
                                controller: tabController,
                                isScrollable: tabs.length > 3,
                                indicatorColor: colors.primary,
                                indicatorWeight: 3,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: colors.text,
                                unselectedLabelColor: colors.textMuted,
                                labelStyle: const TextStyle(
                                  fontWeight: .bold,
                                  fontSize: FontSizeToken.base,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontWeight: .w500,
                                  fontSize: FontSizeToken.base,
                                ),
                                tabs: tabs.map((t) => Tab(text: t)).toList(),
                              ),
                            ),

                          Expanded(child: body),

                          if (showSearchBar && widget.searchAtBottom)
                            GlassSearchBar(
                              controller: controller,
                              hint: searchHint,
                              trailing: searchTrailing,
                              action: widget.searchAction,
                              onChanged: onSearchChanged,
                              onClear: onClear,
                            ),
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
      ),
    );
  }
}
