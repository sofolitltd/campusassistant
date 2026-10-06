import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/features/feedback/data/repositories/feedback_repository.dart';
import '/features/feedback/domain/entities/feedback.dart';
import '/features/feedback/domain/repositories/feedback_repository.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeedbackRepositoryImpl(apiClient);
});

final myFeedbacksProvider = FutureProvider<List<FeedbackItem>>((ref) async {
  final repo = ref.watch(feedbackRepositoryProvider);
  return repo.getMyFeedbacks();
});
