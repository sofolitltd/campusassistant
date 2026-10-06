import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/subscription/domain/entities/subscription.dart';
import '/features/subscription/presentation/providers/subscription_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/widgets/section_card.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  SubscriptionPlan? selectedPlan;
  final _couponController = TextEditingController();
  String? _appliedCoupon;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return CustomHeaderLayout(
      title: 'Premium Access',
      showSearchBar: false,
      body: userAsync.when(
        data: (user) {
          final params = (
            universityId: user.university,
            departmentId: user.department,
          );
          final plansAsync = ref.watch(subscriptionPlansProvider(params));

          return plansAsync.when(
            data: (plans) {
              void refresh() {
                ref.invalidate(subscriptionPlansProvider(params));
                ref.invalidate(userSubscriptionProvider(user.uid));
              }

              return plans.isEmpty
                  ? _scrollableCentered(_buildEmptyState(), refresh)
                  : RefreshIndicator(
                      onRefresh: () async => refresh(),
                      child: _buildContent(context, plans, user.uid),
                    );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => _scrollableCentered(
              _buildErrorState(e.toString()),
              () => ref.invalidate(subscriptionPlansProvider(params)),
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }

  /// Scrollable (so pull-to-refresh works) and vertically centred in the
  /// available space — not a hard-coded 500px box that left the message
  /// floating at an arbitrary height.
  Widget _scrollableCentered(Widget child, VoidCallback onRefresh) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final colors = context.colors;
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(LucideIcons.packageSearch, size: 56, color: colors.textSubtle),
        const SizedBox(height: Spacing.md),
        Text(
          'No plans available right now.',
          style: TextStyle(color: colors.textMuted, fontSize: FontSizeToken.lg),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Text(
        'Something went wrong. Pull down to retry.\n$error',
        textAlign: .center,
        style: TextStyle(color: context.colors.textMuted),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<SubscriptionPlan> plans,
    String uid,
  ) {
    if (selectedPlan == null && plans.isNotEmpty) {
      selectedPlan = plans.first;
    }

    // Same rhythm as the other list pages: Spacing.lg on every side, plus
    // the bottom safe area so the CTA clears the gesture bar.
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.lg,
        Spacing.lg,
        Spacing.lg + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _buildHeroCard(context),
          const SizedBox(height: Spacing.xl),
          _buildCurrentPlanCard(uid),
          const SizedBox(height: Spacing.xl),
          _buildSectionHeader('Choose Your Plan'),
          const SizedBox(height: Spacing.md),
          _buildPlansSelector(context, plans),
          const SizedBox(height: Spacing.xl),
          _buildPaymentSection(),
          const SizedBox(height: Spacing.xl),
          _buildCouponSection(),
          const SizedBox(height: Spacing.xxl),
          _buildSubscribeButton(context),
        ],
      ),
    );
  }

  /// Full-width banner with a single brand gradient behind all its content.
  Widget _buildHeroCard(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      child: SectionCard(
        radius: RadiusToken.lg,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primaryPressed],
        ),
        borderColor: Colors.transparent,
        shadow: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm + 2,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(RadiusToken.full),
              ),
              child: Text(
                'PRO ACCESS',
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: .bold,
                  fontSize: FontSizeToken.xs,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Unlock Your Full Potential',
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: FontSizeToken.xxl,
                fontWeight: .bold,
                height: 1.15,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Enjoy ad-free experience and exclusive features.',
              style: TextStyle(
                color: colors.onPrimary.withValues(alpha: 0.85),
                fontSize: FontSizeToken.md,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the user's current package and its validity, or that they have
  /// none. A null `endDate` means a lifetime plan.
  Widget _buildCurrentPlanCard(String uid) {
    final colors = context.colors;
    final subAsync = ref.watch(userSubscriptionProvider(uid));

    // (icon, tint, title, detail) for each state.
    Widget card({
      required IconData icon,
      required Color accent,
      required Color tint,
      required String title,
      required String detail,
    }) {
      return SizedBox(
        width: double.infinity,
        child: SectionCard(
          radius: RadiusToken.lg,
          color: tint,
          borderColor: Colors.transparent,
          shadow: false,
          child: Row(
            children: [
              Icon(icon, size: 24, color: accent),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: FontSizeToken.lg,
                        fontWeight: .w600,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      detail,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: FontSizeToken.sm,
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

    return subAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.lg),
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (sub) {
        final fmt = DateFormat('MMM dd, yyyy');
        final end = sub?.endDate;
        final expired = end != null && end.isBefore(DateTime.now());

        if (sub == null) {
          return card(
            icon: LucideIcons.lock,
            accent: colors.textMuted,
            tint: colors.surface,
            title: 'No active package',
            detail: 'You are on the free plan. Pick a plan below to go Pro.',
          );
        }
        if (expired) {
          return card(
            icon: LucideIcons.clockAlert,
            accent: colors.danger,
            tint: colors.surface,
            title: '${sub.plan} expired',
            detail: 'Expired on ${fmt.format(end)}. Renew below.',
          );
        }
        final daysLeft = end?.difference(DateTime.now()).inDays;
        return card(
          icon: LucideIcons.crown,
          accent: colors.success,
          tint: colors.successSubtle,
          title: 'Current package: ${sub.plan}',
          detail: end == null
              ? 'Lifetime access'
              : 'Valid until ${fmt.format(end)} · $daysLeft days left',
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: .w700,
        color: context.colors.text,
      ),
    );
  }

  Widget _buildPlansSelector(
    BuildContext context,
    List<SubscriptionPlan> plans,
  ) {
    return Column(
      children: [
        for (final plan in plans)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm + 2),
            child: _buildPlanCard(context, plan, selectedPlan?.id == plan.id),
          ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    SubscriptionPlan plan,
    bool isSelected,
  ) {
    final colors = context.colors;
    final accessLine = plan.isLifetime
        ? 'Lifetime access'
        : 'Access until ${DateFormat('MMM dd, yyyy').format(DateTime.now().add(Duration(days: plan.durationDays)))}';

    // Flat, 1px card; selection is shown by tint + border colour + the
    // radio mark, not by a thicker border and drop shadow.
    return SectionCard(
      radius: RadiusToken.lg,
      shadow: false,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      color: isSelected ? colors.primarySubtle : colors.surface,
      borderColor: isSelected ? colors.primary : colors.border,
      onTap: () => setState(() => selectedPlan = plan),
      child: Row(
        children: [
          Icon(
            isSelected ? LucideIcons.circleCheck : LucideIcons.circle,
            size: 20,
            color: isSelected ? colors.primary : colors.borderStrong,
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  plan.title,
                  style: TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.lg,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      plan.isLifetime
                          ? LucideIcons.infinity
                          : LucideIcons.calendarDays,
                      size: 13,
                      color: colors.textMuted,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Flexible(
                      child: Text(
                        accessLine,
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          Column(
            crossAxisAlignment: .end,
            children: [
              // Old and new price share one baseline-aligned row.
              Row(
                mainAxisSize: .min,
                crossAxisAlignment: .baseline,
                textBaseline: .alphabetic,
                children: [
                  if (plan.discount > 0) ...[
                    Text(
                      '৳${plan.mainPrice}',
                      style: TextStyle(
                        color: colors.textSubtle,
                        fontSize: FontSizeToken.sm,
                        decoration: .lineThrough,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                  ],
                  Text(
                    '৳${plan.price}',
                    style: TextStyle(
                      fontWeight: .w800,
                      fontSize: FontSizeToken.xl,
                      color: isSelected ? colors.primary : colors.text,
                    ),
                  ),
                ],
              ),
              if (plan.discount > 0)
                Text(
                  '${plan.discount}% OFF · Save ৳${plan.savedAmount}',
                  textAlign: .end,
                  style: TextStyle(
                    color: colors.success,
                    fontSize: FontSizeToken.xs,
                    fontWeight: .w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        _buildSectionHeader('Payment Method'),
        const SizedBox(height: Spacing.md),
        SectionCard(
          radius: RadiusToken.lg,
          shadow: false,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          child: Row(
            children: [
              Image.asset('assets/images/bkash_logo.png', height: 26),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Text(
                  'bKash Payment',
                  style: TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.lg,
                    color: colors.text,
                  ),
                ),
              ),
              Icon(LucideIcons.circleCheck, color: colors.primary, size: 22),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSection() {
    final colors = context.colors;
    final applied = _appliedCoupon != null;
    return SectionCard(
      radius: RadiusToken.lg,
      shadow: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _buildSectionHeader('Have a coupon?'),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                // Border, fill and padding come from the app-wide input theme.
                child: TextField(
                  controller: _couponController,
                  enabled: !applied,
                  decoration: const InputDecoration(
                    hintText: 'Enter coupon code',
                    prefixIcon: Icon(LucideIcons.tag, size: 20),
                  ),
                  textCapitalization: .characters,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _applyCoupon(),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // The theme's min width is infinite; a Row needs a finite one.
                  minimumSize: const Size(88, ControlToken.height),
                ),
                onPressed: (applied || _couponController.text.trim().isEmpty)
                    ? null
                    : _applyCoupon,
                child: const Text('Apply'),
              ),
            ],
          ),
          // Cancel only exists once a coupon has been applied.
          if (applied) ...[
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Icon(LucideIcons.circleCheck, size: 16, color: colors.success),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    'Coupon $_appliedCoupon applied',
                    style: TextStyle(
                      color: colors.success,
                      fontSize: FontSizeToken.sm,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _cancelCoupon,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xs),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: colors.danger,
                        fontSize: FontSizeToken.sm,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _appliedCoupon = code);
  }

  void _cancelCoupon() {
    FocusScope.of(context).unfocus();
    setState(() {
      _appliedCoupon = null;
      _couponController.clear();
    });
  }

  Widget _buildSubscribeButton(BuildContext context) {
    // Inherits the app-wide elevatedButtonTheme (brand teal, RadiusToken.lg,
    // bold label) instead of a one-off style, so it matches every other
    // primary CTA button in the app.
    return SizedBox(
      width: double.infinity,
      height: ControlToken.height,
      child: ElevatedButton(
        onPressed: selectedPlan == null
            ? null
            : () => _handleSubscribe(context),
        child: const Text('Activate Premium'),
      ),
    );
  }

  void _handleSubscribe(BuildContext context) {
    if (selectedPlan == null) return;

    // plan_title/amount are display-only on PaymentPage — the actual charge
    // is always computed server-side from plan_id, never trusted from here.
    final params = <String, String>{
      'plan_id': selectedPlan!.id,
      'plan_title': selectedPlan!.title,
      'amount': selectedPlan!.price.toString(),
    };
    final coupon = _appliedCoupon;
    if (coupon != null && coupon.isNotEmpty) {
      params['coupon_code'] = coupon;
    }
    context.pushNamed(AppRoute.payment.name, queryParameters: params);
  }
}
