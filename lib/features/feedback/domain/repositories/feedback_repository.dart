import 'dart:typed_data';

import '/features/feedback/domain/entities/feedback.dart';

abstract class FeedbackRepository {
  Future<List<FeedbackItem>> getMyFeedbacks();
  Future<FeedbackItem> createFeedback({
    required String category,
    required String subject,
    required String message,
    List<String> imageUrls = const [],
  });

  /// Uploads one (already compressed) screenshot and returns its URL.
  Future<String> uploadImage(Uint8List bytes);
}
