import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../../../data/models/review.dart';
import '../../providers/seller_provider.dart';
import '../../widgets/rating_widgets.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Reviews customers left on this business's products, with a reply action.
class SellerReviewsTab extends ConsumerWidget {
  final String merchantId;
  const SellerReviewsTab({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(merchantReviewsProvider(merchantId));
    return async.when(
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (_, _) => Center(
        child: Text(
          'Could not load reviews.',
          style: TextStyle(color: c.textSubtle),
        ),
      ),
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xxxl),
              child: Text(
                'No reviews yet. Buyers can review a product once their order is delivered.',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textSubtle),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(merchantReviewsProvider(merchantId));
            await ref.read(merchantReviewsProvider(merchantId).future);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Spacing.lg),
            itemCount: reviews.length,
            itemBuilder: (context, i) =>
                _SellerReviewCard(review: reviews[i], merchantId: merchantId),
          ),
        );
      },
    );
  }
}

class _SellerReviewCard extends ConsumerWidget {
  final Review review;
  final String merchantId;
  const _SellerReviewCard({required this.review, required this.merchantId});

  Future<void> _reply(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: review.sellerReply);
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          review.sellerReply.isEmpty ? 'Reply to review' : 'Edit your reply',
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 1000,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Thank them, or explain what you will do about it',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Post Reply'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || !context.mounted) return;
    try {
      await replyToReview(
        ref,
        merchantId: merchantId,
        reviewId: review.id,
        reply: text,
      );
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiErrorMessage(err))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StarRow(rating: review.rating.toDouble(), size: 14),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    fontWeight: FontWeight.w700,
                    color: c.text,
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMd().format(review.createdAt),
                style: TextStyle(
                  fontSize: FontSizeToken.xs,
                  color: c.textSubtle,
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Text(review.comment, style: TextStyle(color: c.text, height: 1.4)),
          ],
          if (review.sellerReply.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: c.surfaceAlt,
                borderRadius: BorderRadius.circular(RadiusToken.md),
              ),
              child: Text(
                'You: ${review.sellerReply}',
                style: TextStyle(
                  fontSize: 12.5,
                  color: c.textMuted,
                  height: 1.4,
                ),
              ),
            ),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _reply(context, ref),
              child: Text(review.sellerReply.isEmpty ? 'Reply' : 'Edit reply'),
            ),
          ),
        ],
      ),
    );
  }
}
