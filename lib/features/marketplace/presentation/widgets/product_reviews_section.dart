import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../../data/models/review.dart';
import '../providers/reviews_provider.dart';
import 'rating_widgets.dart';
import 'review_sheet.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Ratings summary + reviews on the product page. Buyers who received the
/// product also get a Write/Edit button.
class ProductReviewsSection extends ConsumerWidget {
  final String productId;
  final String productTitle;
  const ProductReviewsSection({super.key, required this.productId, required this.productTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(productReviewsProvider(productId));

    return async.when(
      loading: () => const SizedBox(height: 60),
      error: (_, _) => const SizedBox.shrink(),
      data: (data) {
        final s = data.summary;
        if (s.count == 0 && !data.canReview) {
          return Padding(
            padding: const EdgeInsets.only(top: Spacing.xl),
            child: Text('No reviews yet', style: TextStyle(color: c.textSubtle)),
          );
        }
        final shown = data.reviews.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.xxl),
            Row(
              children: [
                Text('Ratings & reviews', style: TextStyle(fontSize: FontSizeToken.lg, fontWeight: FontWeight.w800, color: c.text)),
                const Spacer(),
                if (data.canReview)
                  TextButton(
                    onPressed: () => showReviewSheet(
                      context,
                      productId: productId,
                      productTitle: productTitle,
                      existing: data.myReview,
                    ),
                    child: Text(data.myReview == null ? 'Write a review' : 'Edit yours'),
                  ),
              ],
            ),
            if (s.count > 0) ...[
              const SizedBox(height: Spacing.sm),
              _Summary(summary: s),
              const SizedBox(height: Spacing.md),
              for (final r in shown) _ReviewTile(review: r),
              if (data.total > shown.length)
                TextButton(
                  onPressed: () => _showAll(context, data),
                  child: Text('See all ${data.total} reviews'),
                ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Text('Be the first to review this product.', style: TextStyle(color: c.textMuted)),
              ),
          ],
        );
      },
    );
  }

  void _showAll(BuildContext context, ProductReviews data) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(Spacing.xl, 0, Spacing.xl, Spacing.xxl),
          children: [
            _Summary(summary: data.summary),
            const SizedBox(height: Spacing.md),
            for (final r in data.reviews) _ReviewTile(review: r),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final ReviewSummary summary;
  const _Summary({required this.summary});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Column(
          children: [
            Text(summary.average.toStringAsFixed(1),
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: c.text, height: 1)),
            const SizedBox(height: Spacing.xs),
            StarRow(rating: summary.average, size: 14),
            const SizedBox(height: Spacing.xs),
            Text('${summary.count} ${summary.count == 1 ? 'review' : 'reviews'}',
                style: TextStyle(fontSize: FontSizeToken.xs, color: c.textSubtle)),
          ],
        ),
        const SizedBox(width: Spacing.xl),
        Expanded(
          child: Column(
            children: [
              for (var star = 5; star >= 1; star--)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
                  child: Row(
                    children: [
                      SizedBox(width: 12, child: Text('$star', style: TextStyle(fontSize: FontSizeToken.xs, color: c.textMuted))),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.full),
                          child: LinearProgressIndicator(
                            value: summary.count == 0 ? 0 : (summary.distribution[star] ?? 0) / summary.count,
                            minHeight: 6,
                            backgroundColor: c.surfaceAlt,
                            valueColor: AlwaysStoppedAnimation(c.warning),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: review.mine ? c.primary.withValues(alpha: 0.5) : c.border),
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
                  review.mine ? 'You' : review.reviewerName,
                  style: TextStyle(fontSize: FontSizeToken.sm, fontWeight: FontWeight.w700, color: c.text),
                ),
              ),
              Text(DateFormat.yMMMd().format(review.createdAt), style: TextStyle(fontSize: FontSizeToken.xs, color: c.textSubtle)),
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
              decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(RadiusToken.md)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller replied', style: TextStyle(fontSize: FontSizeToken.xs, fontWeight: FontWeight.w700, color: c.primary)),
                  const SizedBox(height: Spacing.xxs),
                  Text(review.sellerReply, style: TextStyle(fontSize: 12.5, color: c.textMuted, height: 1.4)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
