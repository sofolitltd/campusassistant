import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/error/failures.dart';
import '/core/providers/is_pro_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_card.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../widgets/home_section.dart';
import '/core/theme/tokens/app_font_size.dart';

const _title = 'আমাদের এই উদ্যোগকে বাঁচিয়ে রাখুন';
const _message =
    'বর্তমানে ব্যবহারকারী বাড়ায় সার্ভার ও মেইনটেন্যান্স খরচ চালানো আমাদের জন্য কঠিন হয়ে পড়ছে। আমরা চাই না অ্যাপটি বন্ধ হয়ে যাক। সামান্য সাবস্ক্রিপশনের মাধ্যমে এই পথচলায় আমাদের সঙ্গী হোন। ❤️';
const _intro =
    'ক্যাম্পাস অ্যাসিস্ট্যান্ট অ্যাপটি সম্পূর্ণ নিজেদের চেষ্টায় তৈরি। ';

/// "Support us" promo. Collapsed it teases the message; tapped it expands to
/// the full text and the subscribe button. Hidden for Pro users — they have
/// already subscribed, so asking again is noise.
class SubscriptionSection extends ConsumerStatefulWidget {
  const SubscriptionSection({super.key});

  @override
  ConsumerState<SubscriptionSection> createState() =>
      _SubscriptionSectionState();
}

class _SubscriptionSectionState extends ConsumerState<SubscriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (ref.watch(isProUserProvider)) return const SizedBox.shrink();

    return ref
        .watch(userProvider)
        .when(
          loading: () => const HomeSectionLoading(height: 64),
          error: (e, _) => HomeSectionError(
            offline: e is NetworkFailure,
            message: e is NetworkFailure
                ? 'No internet connection'
                : 'Unable to load',
            onRetry: () => ref.invalidate(userProvider),
          ),
          data: (_) => _buildCard(context),
        );
  }

  Widget _buildCard(BuildContext context) {
    final colors = context.colors;
    final onPrimary = colors.onPrimary;

    return HomeSection(
      child: SectionCard(
        margin: const EdgeInsets.symmetric(horizontal: homeInset),
        radius: homeCardRadius,
        gradient: homeHeaderGradient(context),
        borderColor: Colors.transparent,
        shadow: false,
        padding: const EdgeInsets.all(Spacing.md),
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Column(
          mainAxisSize: .min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: onPrimary.withValues(alpha: .15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.heartHandshake,
                    color: onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        _title,
                        style: GoogleFonts.hindSiliguri(
                          textStyle: TextStyle(
                            color: onPrimary,
                            fontSize: FontSizeToken.lg,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                      if (!_isExpanded)
                        Text(
                          _message,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: GoogleFonts.tiroBangla(
                            textStyle: TextStyle(
                              color: onPrimary.withValues(alpha: .9),
                              fontSize: FontSizeToken.xs,
                              height: 1.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  color: onPrimary,
                  size: 22,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: !_isExpanded
                  ? const SizedBox(width: double.infinity)
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Spacing.md,
                          ),
                          child: Divider(
                            color: onPrimary.withValues(alpha: .25),
                            height: 1,
                          ),
                        ),
                        Text(
                          '$_intro$_message',
                          style: GoogleFonts.tiroBangla(
                            textStyle: TextStyle(
                              color: onPrimary.withValues(alpha: .95),
                              fontSize: FontSizeToken.sm,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => context.push('/subscription'),
                            icon: const Icon(LucideIcons.crown, size: 18),
                            style: FilledButton.styleFrom(
                              backgroundColor: onPrimary,
                              foregroundColor: colors.primaryPressed,
                            ),
                            label: Text(
                              'সাপোর্ট করুন ও প্রো হোন',
                              style: GoogleFonts.hindSiliguri(
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
