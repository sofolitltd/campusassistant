/// A product review as returned by `/my/products/:id/reviews`.
class Review {
  final String id;
  final String productId;
  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime createdAt;
  final String sellerReply;
  final DateTime? sellerRepliedAt;
  final bool mine;

  Review({
    required this.id,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.createdAt,
    required this.sellerReply,
    this.sellerRepliedAt,
    required this.mine,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as String? ?? '',
    productId: json['product_id'] as String? ?? '',
    rating: json['rating'] as int? ?? 0,
    comment: json['comment'] as String? ?? '',
    reviewerName: json['reviewer_name'] as String? ?? 'Student',
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '')?.toLocal() ?? DateTime.now(),
    sellerReply: json['seller_reply'] as String? ?? '',
    sellerRepliedAt: DateTime.tryParse(json['seller_replied_at'] as String? ?? '')?.toLocal(),
    mine: json['mine'] as bool? ?? false,
  );
}

class ReviewSummary {
  final double average;
  final int count;
  final Map<int, int> distribution; // star → count

  const ReviewSummary({required this.average, required this.count, required this.distribution});

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    final raw = json['distribution'] as Map<String, dynamic>? ?? {};
    return ReviewSummary(
      average: (json['average'] as num?)?.toDouble() ?? 0,
      count: json['count'] as int? ?? 0,
      distribution: {for (var s = 1; s <= 5; s++) s: (raw['$s'] as num?)?.toInt() ?? 0},
    );
  }
}

class ProductReviews {
  final ReviewSummary summary;
  final List<Review> reviews;
  final int total;
  final Review? myReview;
  final bool canReview;

  const ProductReviews({
    required this.summary,
    required this.reviews,
    required this.total,
    this.myReview,
    required this.canReview,
  });

  factory ProductReviews.fromJson(Map<String, dynamic> json) => ProductReviews(
    summary: ReviewSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
    reviews: (json['reviews'] as List? ?? []).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList(),
    total: (json['total'] as num?)?.toInt() ?? 0,
    myReview: json['my_review'] == null ? null : Review.fromJson(json['my_review'] as Map<String, dynamic>),
    canReview: json['can_review'] as bool? ?? false,
  );
}

/// One line of a delivered order, with the buyer's rating if they left one.
class ReviewableItem {
  final String productId;
  final String productTitle;
  final int? myRating;
  const ReviewableItem({required this.productId, required this.productTitle, this.myRating});

  factory ReviewableItem.fromJson(Map<String, dynamic> json) => ReviewableItem(
    productId: json['product_id'] as String? ?? '',
    productTitle: json['product_title'] as String? ?? '',
    myRating: json['my_rating'] as int?,
  );
}
