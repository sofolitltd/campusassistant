import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '/features/subscription/presentation/providers/subscription_provider.dart'
    show userSubscriptionProvider;
import '/core/theme/tokens/app_radius.dart';

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
          margin: const EdgeInsets.only(top: 32),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: const Icon(
                    Icons.diamond_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pro User (${subscription.plan})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        end.isEmpty ? '$start - Life Time' : '$start - $end',
                        style: const TextStyle(color: Colors.black),
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
