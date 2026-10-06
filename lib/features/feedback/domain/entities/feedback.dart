import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback.freezed.dart';

@freezed
abstract class FeedbackItem with _$FeedbackItem {
  const factory FeedbackItem({
    required String id,
    required String category,
    required String subject,
    required String message,
    String? attachmentUrl,
    @Default('pending') String status,
    String? adminReply,
    String? repliedAt,
    String? createdAt,
    String? updatedAt,
  }) = _FeedbackItem;
}
