import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/notification/presentation/widgets/notification_badge.dart';
import '/routes/app_route.dart';
import 'home_section.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Gradient header: profile avatar, search / notifications / menu actions and
/// the greeting. The action row is pinned, so it stays put while the page
/// scrolls; the greeting fades away behind it. The enclosing page overlaps the
/// sheet below it by [HomeHeader.overlap], so the header reserves that much
/// extra bottom space.
///
/// This is a sliver: place it first in a [CustomScrollView].
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, required this.onOpenMenu});

  /// How far the content sheet below is pulled up over this header.
  static const double overlap = 20;

  /// Height of the pinned action row (excluding the status bar).
  static const double _toolbarHeight = 56;

  /// Height of the greeting block plus the space reserved for [overlap].
  static const double _greetingHeight = 94;

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final name = ref.watch(userProvider).value?.name.trim() ?? '';

    return SliverAppBar(
      pinned: true,
      primary: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: _toolbarHeight,
      expandedHeight: _toolbarHeight + _greetingHeight,
      titleSpacing: homeInset,
      title: Align(
        alignment: Alignment.centerLeft,
        child: _Avatar(
          initial: name.isEmpty ? null : name[0].toUpperCase(),
          onTap: () => context.goNamed(AppRoute.profile.name),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: Icon(LucideIcons.search, color: colors.onPrimary),
          onPressed: () => context.push(AppRoute.search.path),
        ),
        NotificationBadge(
          icon: Icon(LucideIcons.bell, color: colors.onPrimary),
          onTap: () => context.push(AppRoute.notifications.path),
        ),
        Padding(
          padding: const EdgeInsets.only(right: Spacing.md),
          child: GestureDetector(onTap: onOpenMenu, child: const _LogoMark()),
        ),
      ],
      // The 1px bottom inset keeps the gradient's anti-aliased last row from
      // bleeding through as a hairline along the top of the sheet.
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: homeHeaderGradient(context)),
          child: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: _ScrollWithBody(
              builder: (strip) => Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top + _toolbarHeight,
                      left: homeInset,
                      right: homeInset,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              _greeting(),
                              style: TextStyle(
                                color: colors.onPrimary.withValues(alpha: .9),
                                fontSize: FontSizeToken.base,
                              ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(
                              // Until the profile loads, don't flash a placeholder name.
                              name.isEmpty ? 'Welcome' : name,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontSize: FontSizeToken.xl,
                                fontWeight: .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // The sheet's rounded top edge. Painted here, inside the header,
                  // because a translated sliver child is covered by the pinned bar.
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: overlap,
                    child: Opacity(
                      opacity: strip,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.bg,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(RadiusToken.xxl),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial, required this.onTap});

  final String? initial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: 'Profile',
      child: Material(
        color: colors.onPrimary.withValues(alpha: .2),
        shape: const CircleBorder(),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: initial == null
                  ? Icon(LucideIcons.user, size: 20, color: colors.onPrimary)
                  : Text(
                      initial!,
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: FontSizeToken.xl,
                        fontWeight: .bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The app logo in a translucent disc — the same mark the Study, Career,
/// Community and Profile app bars show.
class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: context.colors.surface.withValues(alpha: 0.2),
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(Spacing.xs),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(RadiusToken.lg),
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    ),
  );
}

/// Moves its child up one-for-one with the scroll, so the greeting travels
/// with the page body instead of staying put until the header collapses. The
/// child's bottom edge stays glued to the header's bottom edge. [builder]
/// receives how visible the rounded sheet edge should be: it fades out over its
/// last [HomeHeader.overlap] pixels so it never lands on the pinned toolbar.
class _ScrollWithBody extends StatelessWidget {
  const _ScrollWithBody({required this.builder});

  final Widget Function(double stripOpacity) builder;

  @override
  Widget build(BuildContext context) {
    final settings = context
        .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) return builder(1);

    final collapsed = (settings.maxExtent - settings.currentExtent).clamp(
      0.0,
      settings.maxExtent - settings.minExtent,
    );
    final remaining = settings.currentExtent - settings.minExtent;
    return Transform.translate(
      offset: Offset(0, -collapsed),
      child: builder((remaining / HomeHeader.overlap).clamp(0.0, 1.0)),
    );
  }
}
