import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/routes/app_route.dart';
import '../providers/onboarding_provider.dart';

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const _slides = [
  _OnboardingSlide(
    icon: LucideIcons.graduationCap,
    title: 'Your Whole Campus,\nOne App',
    description:
        'University info, department updates, and everything student '
        'life — brought together in a single place.',
  ),
  _OnboardingSlide(
    icon: LucideIcons.bookOpen,
    title: 'Study Smarter',
    description:
        'Routines, course notes, past questions, and syllabus — all '
        'organized and ready whenever you need to revise.',
  ),
  _OnboardingSlide(
    icon: LucideIcons.users,
    title: 'Stay Connected',
    description:
        'Join clubs and associations, chat with peers, and keep up '
        'with what’s happening around campus.',
  ),
  _OnboardingSlide(
    icon: LucideIcons.rocket,
    title: 'Grow Beyond Class',
    description:
        'Track career circulars, buy & sell on the marketplace, and '
        'get instant alerts — all in Campus Assistant.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  bool get _isLastPage => _page == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (mounted) context.go(AppRoute.login.path);
  }

  void _next() {
    if (_isLastPage) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // ── Skip ──
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: Spacing.lg,
                      top: Spacing.xs,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isLastPage ? 0 : 1,
                      child: IgnorePointer(
                        ignoring: _isLastPage,
                        child: TextButton(
                          onPressed: _finish,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Slides ──
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xxxl,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 168,
                              height: 168,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    colors.primaryColor.withValues(alpha: 0.16),
                                    colors.primaryColor.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 104,
                                  height: 104,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.primaryColor.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 24,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    slide.icon,
                                    size: 44,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ).animate(key: ValueKey('icon-$index')).fadeIn(
                              duration: 350.ms,
                            ).scale(begin: const Offset(0.85, 0.85)),
                            const SizedBox(height: Spacing.xxxl),
                            Text(
                                  slide.title,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
                                  ),
                                )
                                .animate(key: ValueKey('title-$index'))
                                .fadeIn(delay: 80.ms, duration: 350.ms)
                                .slideY(begin: 0.15, end: 0),
                            const SizedBox(height: Spacing.md),
                            Text(
                                  slide.description,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                )
                                .animate(key: ValueKey('desc-$index'))
                                .fadeIn(delay: 140.ms, duration: 350.ms)
                                .slideY(begin: 0.15, end: 0),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Indicators + CTA ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.xxl,
                    Spacing.lg,
                    Spacing.xxl,
                    Spacing.xxl,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (i) {
                          final active = i == _page;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(
                              horizontal: Spacing.xxs,
                            ),
                            width: active ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? colors.primaryColor
                                  : colors.primaryColor.withValues(alpha: 0.2),
                              borderRadius: RadiusToken.circular(RadiusToken.full),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: Spacing.xxl),
                      ElevatedButton(
                        onPressed: _next,
                        child: Text(_isLastPage ? 'Get Started' : 'Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
