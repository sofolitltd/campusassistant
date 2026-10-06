import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/feedback/presentation/providers/feedback_provider.dart';
import '/features/feedback/presentation/widgets/feedback_card.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class FeedbackPage extends ConsumerWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbacksAsync = ref.watch(myFeedbacksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Feedback'), centerTitle: true),
      body: feedbacksAsync.when(
        data: (feedbacks) {
          if (feedbacks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xxxl),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      LucideIcons.messageSquare,
                      size: 64,
                      color: context.colors.borderStrong,
                    ),
                    const SizedBox(height: Spacing.xl),
                    Text(
                      'No feedback yet',
                      style: TextStyle(
                        fontSize: FontSizeToken.xl,
                        fontWeight: .bold,
                        color: context.colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'Have a suggestion or found a bug?\nTap below to send us your feedback.',
                      textAlign: .center,
                      style: TextStyle(
                        fontSize: FontSizeToken.base,
                        color: context.colors.textSubtle,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxxl),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.push(AppRoute.createFeedback.path),
                      icon: const Icon(LucideIcons.plus),
                      label: const Text('Send Feedback'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, ControlToken.height),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myFeedbacksProvider);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
                Spacing.xxxl,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${feedbacks.length} submission${feedbacks.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: FontSizeToken.md,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          context.push(AppRoute.createFeedback.path),
                      icon: const Icon(LucideIcons.plus, size: 18),
                      label: const Text('New'),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                ...feedbacks.map((f) => FeedbackCard(feedback: f)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xxxl),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  size: 48,
                  color: context.colors.danger,
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  'Could not load feedback',
                  style: TextStyle(
                    fontSize: FontSizeToken.lg,
                    fontWeight: .bold,
                    color: context.colors.danger,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  e.toString(),
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: FontSizeToken.md,
                    color: context.colors.textSubtle,
                  ),
                ),
                const SizedBox(height: Spacing.xxl),
                ElevatedButton(
                  onPressed: () => ref.invalidate(myFeedbacksProvider),
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
