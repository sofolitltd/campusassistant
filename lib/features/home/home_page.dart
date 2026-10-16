import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/ads/banner_ad_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/reward/presentation/widgets/daily_reward_banner.dart';
import '/features/student_verification/presentation/widgets/student_verification_banner.dart';
import '/routes/scaffold_with_navbar.dart';
import 'sections/banner_section.dart';
import 'sections/marketplace_section.dart';
import 'sections/quick_favorites_section.dart';
import 'sections/skill_up_section.dart';
import 'sections/subscription_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_section.dart';
import 'widgets/shortcut_strip.dart';
import '/core/theme/tokens/app_layout.dart';

/// Composition only: the header, then a rounded sheet of sections. Sections
/// own their own horizontal inset and the gap below them (see [HomeSection]),
/// so adding, removing or hiding one never needs spacing changes here.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _sections = <Widget>[
    StudentVerificationBanner(),
    HomeSection(child: ShortcutStrip()),
    DailyRewardBanner(),
    SubscriptionSection(),
    QuickFavoritesSection(),
    BannerAdWidget(margin: EdgeInsets.only(bottom: Spacing.lg)),
    BannerSection(),
    SkillUpSection(),
    MarketplaceSection(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppLayout.pageWidth),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              HomeHeader(
                onOpenMenu: () =>
                    ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
              ),
              // Lazy so sections below the fold (and their API calls) wait
              // until they're scrolled near; KeepAlive so a section that has
              // built isn't torn down and refetched (or its ad reloaded) each
              // time it scrolls off-screen. The two auto-wrappers are off
              // because KeepAlive must be the list's direct child.
              SliverList.list(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                children: [
                  for (final section in _sections)
                    KeepAlive(
                      keepAlive: true,
                      child: RepaintBoundary(child: section),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
