import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/ads/banner_ad_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import 'sections/banner_section.dart';
import 'sections/marketplace_section.dart';
import 'sections/quick_favorites_section.dart';
import 'sections/skill_up_section.dart';
import 'sections/subscription_section.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_header.dart';
import 'widgets/home_section.dart';
import 'widgets/shortcut_strip.dart';

/// Composition only: the header, then a rounded sheet of sections. Sections
/// own their own horizontal inset and the gap below them (see [HomeSection]),
/// so adding, removing or hiding one never needs spacing changes here.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // The drawer belongs to this page's Scaffold, which is created in build()
  // below — Scaffold.of(context) from here would resolve to an ancestor.
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.bg,
      drawer: const HomeDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              HomeHeader(
                onOpenMenu: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: colors.bg,
                  child: const Column(
                    children: [
                      HomeSection(child: ShortcutStrip()),
                      SubscriptionSection(),
                      QuickFavoritesSection(),
                      BannerAdWidget(
                        margin: EdgeInsets.only(bottom: Spacing.lg),
                      ),
                      BannerSection(),
                      SkillUpSection(),
                      MarketplaceSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
