import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/app_update/presentation/providers/app_update_provider.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/member_card/presentation/screens/member_card_page.dart';
import '/features/reward/presentation/providers/reward_providers.dart';
import '/routes/app_route.dart';
import 'referral_provider.dart';

class ReferralPage extends ConsumerWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(referralSummaryProvider);

    return CustomHeaderLayout(
      title: 'Invite & Earn',
      showSearchBar: false,
      body: summaryAsync.when(
        data: (s) => RefreshIndicator(
          onRefresh: () => ref.refresh(referralSummaryProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              _CodeCard(summary: s),
              const SizedBox(height: Spacing.lg),
              _Stats(summary: s),
              const SizedBox(height: Spacing.lg),
              _HowItWorks(summary: s),
              if (s.canApplyCode) ...[
                const SizedBox(height: Spacing.lg),
                const _ApplyCode(),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load your invite code'),
                const SizedBox(height: Spacing.md),
                OutlinedButton(
                  onPressed: () => ref.invalidate(referralSummaryProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CodeCard extends ConsumerWidget {
  const _CodeCard({required this.summary});
  final ReferralSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider).value;
    final isStudent = user?.role == 'student';

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primaryPressed, context.colors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Column(
        children: [
          Text(
            'Your invite code',
            style: text.labelLarge?.copyWith(
              color: context.colors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: summary.code));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Code copied')));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  summary.code,
                  style: text.displaySmall?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(LucideIcons.copy, color: context.colors.onPrimary),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _shareInvite(context, ref),
                  icon: const Icon(LucideIcons.share2),
                  label: const Text('Share invite'),
                ),
              ),
              if (isStudent) ...[
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => context.push(AppRoute.memberCard.path),
                    icon: const Icon(LucideIcons.idCard),
                    label: const Text('Member card'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _shareInvite(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider).value;
    final url = memberCardInstallUrl(
      ref.read(appUpdateConfigProvider).value?.playStoreUrl,
      user?.universityId ?? '',
      referralCode: summary.code,
    );
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Join me on Campus Assistant — notes, routines, notices and more for your campus. '
            'Use my code ${summary.code} when you sign up: $url',
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.summary});
  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(label: 'Joined', value: summary.invitedCount),
        const SizedBox(width: Spacing.sm),
        _Stat(label: 'Verified', value: summary.verifiedCount),
        const SizedBox(width: Spacing.sm),
        _Stat(label: 'Points earned', value: summary.pointsEarned),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: Spacing.xxs),
            Text(
              label,
              style: text.labelSmall?.copyWith(color: context.colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.summary});
  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final steps = [
      'Share your code or your member card with friends.',
      'They enter your code when signing up.',
      'Once their student profile is verified, you get '
          '${summary.referrerReward} points and they get ${summary.refereeReward}.',
    ];
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How it works', style: text.titleSmall),
          const SizedBox(height: Spacing.md),
          for (final (i, step) in steps.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: context.colors.primarySubtle,
                    child: Text(
                      '${i + 1}',
                      style: text.labelSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(child: Text(step, style: text.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ApplyCode extends ConsumerStatefulWidget {
  const _ApplyCode();

  @override
  ConsumerState<_ApplyCode> createState() => _ApplyCodeState();
}

class _ApplyCodeState extends ConsumerState<_ApplyCode> {
  final _controller = TextEditingController();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await applyReferralCode(ref, _controller.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
    if (error == null) {
      ref.invalidate(rewardBalanceProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Referral code applied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Have a friend\'s code?', style: text.titleSmall),
          const SizedBox(height: Spacing.xs),
          Text(
            'You can add one within 7 days of signing up.',
            style: text.bodySmall?.copyWith(color: context.colors.textMuted),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'e.g. K7M2QX',
                    errorText: _error,
                  ),
                  onSubmitted: (_) => _apply(),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              FilledButton(
                onPressed: _busy ? null : _apply,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CupertinoActivityIndicator(),
                      )
                    : const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
