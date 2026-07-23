import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/error/failures.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/core/theme/tokens/app_radius.dart';

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
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.shade600,
                Colors.teal.shade500,
                Colors.teal.shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(RadiusToken.xl),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(RadiusToken.xl),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.heartHandshake,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "আমাদের এই উদ্যোগকে বাঁচিয়ে রাখুন",
                                style: GoogleFonts.hindSiliguri(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: _isExpanded ? 16 : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!_isExpanded)
                                Text(
                                  "বর্তমানে ব্যবহারকারী বাড়ায় সার্ভার ও মেইনটেন্যান্স খরচ চালানো আমাদের জন্য কঠিন হয়ে পড়ছে। আমরা চাই না অ্যাপটি বন্ধ হয়ে যাক। সামান্য সাবস্ক্রিপশনের মাধ্যমে এই পথচলায় আমাদের সঙ্গী হোন। ❤️",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.tiroBangla(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      height: 1.2,
                                      letterSpacing: .01,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Colors.white24, height: 1),
                          ),
                          Text(
                            "ক্যাম্পাস অ্যাসিস্ট্যান্ট অ্যাপটি সম্পূর্ণ নিজেদের চেষ্টায় তৈরি। বর্তমানে ব্যবহারকারী বাড়ায় সার্ভার ও মেইনটেন্যান্স খরচ চালানো আমাদের জন্য কঠিন হয়ে পড়ছে। আমরা চাই না অ্যাপটি বন্ধ হয়ে যাক। সামান্য সাবস্ক্রিপশনের মাধ্যমে এই পথচলায় আমাদের সঙ্গী হোন। ❤️",
                            style: GoogleFonts.tiroBangla(
                              textStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                height: 1.4,
                                letterSpacing: .01,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push('/subscription');
                              },
                              icon: const Icon(LucideIcons.crown, size: 18),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.teal.shade900,
                              ),
                              label: Text(
                                "সাপোর্ট করুন ও প্রো হোন",
                                style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const _SubscriptionSkeleton(),
      error: (e, _) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.xl),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Icon(
              e is NetworkFailure ? Icons.cloud_off : Icons.error_outline,
              color: Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              e is NetworkFailure ? 'No internet connection' : 'Unable to load',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionSkeleton extends StatelessWidget {
  const _SubscriptionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.xl),
        color: Theme.of(context).cardColor,
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            SizedBox(width: 36, height: 36),
            SizedBox(width: 10),
            Expanded(child: Text('Support Title')),
            SizedBox(width: 22, height: 22),
          ],
        ),
      ),
    );
  }
}
