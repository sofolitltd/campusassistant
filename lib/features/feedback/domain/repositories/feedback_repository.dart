import '/features/feedback/domain/entities/feedback.dart';

abstract class FeedbackRepository {
  Future<List<FeedbackItem>> getMyFeedbacks();
  Future<FeedbackItem> createFeedback({
    required String category,
    required String subject,
    required String message,
  });
}
