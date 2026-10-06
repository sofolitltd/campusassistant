import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/notification/presentation/widgets/notification_badge.dart';
import '/routes/app_route.dart';
import 'home_section.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Gradient header: profile avatar, search / notifications / menu actions and
/// the greeting. The enclosing page overlaps the sheet below it by
/// [HomeHeader.overlap], so the header reserves that much extra bottom space.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, required this.onOpenMenu});

  /// How far the content sheet below is pulled up over this header.
  static const double overlap = 20;

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final name = ref.watch(userProvider).value?.name.trim() ?? '';

    return DecoratedBox(
      decoration: BoxDecoration(gradient: homeHeaderGradient(context)),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: homeInset,
                vertical: Spacing.sm,
              ),
              child: Row(
                children: [
                  _Avatar(
                    initial: name.isEmpty ? null : name[0].toUpperCase(),
                    onTap: () => context.goNamed(AppRoute.profile.name),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Search',
                    icon: Icon(LucideIcons.search, color: colors.onPrimary),
                    onPressed: () => context.push(AppRoute.search.path),
                  ),
                  NotificationBadge(
                    icon: Icon(LucideIcons.bell, color: colors.onPrimary),
                    onTap: () => context.push(AppRoute.notifications.path),
                  ),
                  IconButton(
                    tooltip: 'Menu',
                    icon: _LogoMark(color: colors.onPrimary),
                    onPressed: onOpenMenu,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: homeInset,
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
            const SizedBox(height: Spacing.xxxl),
          ],
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

/// The app logo in a translucent disc, sized to sit in an [IconButton] next
/// to the other header icons (so all three share one tap target and rhythm).
class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
      width: 28,
      height: 28,
      padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .2),
        shape: BoxShape.circle,
      ),
      child: Image.asset('assets/images/logo.png', fit: .contain),
    );
}
