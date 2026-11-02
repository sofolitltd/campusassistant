import 'dart:typed_data';

import '/core/network/api_client.dart';
import '/features/feedback/data/models/feedback_model.dart';
import '/features/feedback/domain/entities/feedback.dart';
import '/features/feedback/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final ApiClient apiClient;

  FeedbackRepositoryImpl(this.apiClient);

  @override
  Future<List<FeedbackItem>> getMyFeedbacks() async {
    final response = await apiClient.get('/feedback/my');
    final data = response.data as List<dynamic>;
    return data
        .map(
          (e) =>
              FeedbackItemModel.fromJson(e as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  @override
  Future<FeedbackItem> createFeedback({
    required String category,
    required String subject,
    required String message,
    List<String> imageUrls = const [],
  }) async {
    final response = await apiClient.post(
      '/feedback',
      data: {
        'category': category,
        'subject': subject,
        'message': message,
        if (imageUrls.isNotEmpty) 'image_urls': imageUrls,
      },
    );
    final model = FeedbackItemModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    return model.toEntity();
  }

  @override
  Future<String> uploadImage(Uint8List bytes) async {
    // compressCommunityImage returns small originals untouched, so a PNG
    // screenshot can arrive here as-is — name it to match its bytes.
    final isPng = bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50;
    final response = await apiClient.uploadBytes(
      '/upload',
      bytes: bytes,
      fileName:
          'feedback_${DateTime.now().millisecondsSinceEpoch}.${isPng ? 'png' : 'jpg'}',
      fieldName: 'image',
      data: {'folder': 'feedback'},
    );
    return (response.data['file_url'] ?? response.data['url']) as String;
  }
}
