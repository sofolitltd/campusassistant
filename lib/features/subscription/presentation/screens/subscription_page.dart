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
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  SubscriptionPlan? selectedPlan;

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
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(subscriptionPlansProvider(params));
                },
                child: plans.isEmpty
                    ? _buildEmptyState()
                    : _buildContent(context, plans),
              );
            },
            loading: () =>
                const Center(child: CupertinoActivityIndicator(radius: 20)),
            error: (e, _) => _buildErrorState(e.toString(), params),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.packageSearch, size: 64, color: Colors.grey),
              SizedBox(height: Spacing.lg),
              Text(
                "No plans available right now.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, dynamic params) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(subscriptionPlansProvider(params));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 500,
          child: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<SubscriptionPlan> plans) {
    if (selectedPlan == null && plans.isNotEmpty) {
      selectedPlan = plans.first;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildHeroCard(context),
          const SizedBox(height: 24),
          _buildSectionHeader('Choose Your Plan'),
          const SizedBox(height: 12),
          _buildPlansSelector(context, plans),
          const SizedBox(height: 24),
          _buildPaymentSection(),
          const SizedBox(height: 32),
          _buildSubscribeButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade900, Colors.teal.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'PRO ACCESS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Unlock Your Full Potential',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy ad-free experience and exclusive features.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildPlansSelector(
    BuildContext context,
    List<SubscriptionPlan> plans,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: plans.map((plan) {
        final isSelected = selectedPlan?.id == plan.id;
        final String accessLine;
        if (plan.isLifetime) {
          accessLine = 'Lifetime access';
        } else {
          final expiryDate = DateTime.now().add(
            Duration(days: plan.durationDays),
          );
          accessLine =
              'Access until ${DateFormat('MMM dd, yyyy').format(expiryDate)}';
        }

        return GestureDetector(
          onTap: () => setState(() => selectedPlan = plan),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.04)
                  : Colors.white,
              borderRadius: BorderRadius.circular(RadiusToken.sm),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            plan.isLifetime
                                ? LucideIcons.infinity
                                : LucideIcons.calendarDays,
                            size: 13,
                            color: isSelected
                                ? primaryColor
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            accessLine,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? primaryColor
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (plan.discount > 0)
                      Text(
                        '৳${plan.mainPrice}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      '৳${plan.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    if (plan.discount > 0)
                      Text(
                        '${plan.discount}% OFF · Save ৳${plan.savedAmount}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Payment Method'),
        const SizedBox(height: Spacing.lg),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Image.asset('assets/images/bkash_logo.png', height: 26),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'bKash Payment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Icon(
                LucideIcons.circleCheck,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscribeButton(BuildContext context) {
    // Inherits the app-wide elevatedButtonTheme (brand teal, RadiusToken.lg,
    // bold label) instead of a one-off style, so it matches every other
    // primary CTA button in the app.
    return SizedBox(
      width: double.infinity,
      height: 52,
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
    final params = {
      'plan_id': selectedPlan!.id,
      'plan_title': selectedPlan!.title,
      'amount': selectedPlan!.price.toString(),
    };
    context.pushNamed(AppRoute.payment.name, queryParameters: params);
  }
}
