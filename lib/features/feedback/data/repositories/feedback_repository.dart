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
        .map((e) =>
            FeedbackItemModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<FeedbackItem> createFeedback({
    required String category,
    required String subject,
    required String message,
  }) async {
    final response = await apiClient.post(
      '/feedback',
      data: {
        'category': category,
        'subject': subject,
        'message': message,
      },
    );
    final model =
        FeedbackItemModel.fromJson(response.data as Map<String, dynamic>);
    return model.toEntity();
  }
}
