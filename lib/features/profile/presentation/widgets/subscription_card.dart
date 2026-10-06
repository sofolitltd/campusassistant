import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '/features/subscription/presentation/providers/subscription_provider.dart'
    show userSubscriptionProvider;
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

class SubscriptionCard extends ConsumerWidget {
  final String uid;

  const SubscriptionCard({super.key, required this.uid});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(userSubscriptionProvider(uid));

    return subscriptionAsync.when(
      data: (subscription) {
        if (subscription == null) return const SizedBox();

        final start = _formatDate(subscription.startDate);
        final end = _formatDate(subscription.endDate);

        return Container(
          margin: const EdgeInsets.only(top: Spacing.xxxl),
          decoration: BoxDecoration(
            color: context.colors.warning,
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            border: Border.all(color: context.colors.warning),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.sm),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: context.colors.warning,
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: Icon(
                    Icons.diamond_outlined,
                    color: context.colors.onPrimary,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "Pro User (${subscription.plan})",
                        style: TextStyle(
                          fontWeight: .bold,
                          color: context.colors.text,
                        ),
                      ),
                      Text(
                        end.isEmpty ? '$start - Life Time' : '$start - $end',
                        style: TextStyle(color: context.colors.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
