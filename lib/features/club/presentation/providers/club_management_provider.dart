import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/club_event.dart';
import '../../data/models/club_model.dart';
import '../../data/models/club_post.dart';
import '../../data/models/club_user_summary.dart';
import '../../domain/entities/club.dart';

/// Public, read-only club sub-resources — light `FutureProvider`s, same
/// shape as `clubEventsProvider`, no dartz/repository ceremony needed since
/// these are simple GETs.
final clubPostsProvider = FutureProvider.family<List<ClubPost>, String>((
  ref,
  clubId,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/clubs/$clubId/posts');
  final data = response.data as List;
  return data.map((e) => ClubPost.fromJson(e as Map<String, dynamic>)).toList();
});

final clubMembersProvider = FutureProvider.family<List<ClubUserSummary>, String>((
  ref,
  clubId,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/clubs/$clubId/members');
  final data = response.data as List;
  return data
      .map((e) => ClubUserSummary.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Clubs the current user created or co-manages — powers "My Clubs".
/// `autoDispose` (default for `@riverpod`-less `FutureProvider`) is fine
/// here since it's a small, cheap-to-refetch list.
final myClubsProvider = FutureProvider<List<Club>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/clubs');
  final data = response.data as List;
  return data
      .map((e) => ClubModel.fromJson(e as Map<String, dynamic>).toEntity())
      .toList();
});

/// The pool of followers eligible to be promoted to manager (per product
/// decision: managers are promoted from followers, a separate pool from
/// the formal Members/Join roster).
Future<List<ClubUserSummary>> getFollowersForPromotion(
  WidgetRef ref,
  String clubId,
) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/my/clubs/$clubId/followers');
  final data = response.data as List;
  return data
      .map((e) => ClubUserSummary.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<List<ClubUserSummary>> getManagers(WidgetRef ref, String clubId) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/my/clubs/$clubId/managers');
  final data = response.data as List;
  return data
      .map((e) => ClubUserSummary.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<void> promoteManager(
  WidgetRef ref,
  String clubId,
  String userId,
  String role,
) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.post(
    '/my/clubs/$clubId/managers',
    data: {'user_id': userId, 'role': role},
  );
}

Future<void> removeManager(WidgetRef ref, String clubId, String userId) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/my/clubs/$clubId/managers/$userId');
}

/// Updates only the content-field whitelist the backend allows via
/// `/my/clubs/:id` (never is_active/is_verified — those stay admin-only).
Future<Club> updateMyClub(
  WidgetRef ref,
  String clubId,
  Map<String, dynamic> fields,
) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put('/my/clubs/$clubId', data: fields);
  return ClubModel.fromJson(response.data).toEntity();
}

Future<ClubEvent> createMyClubEvent(
  WidgetRef ref,
  String clubId, {
  required String title,
  required String description,
  required String location,
  required DateTime startAt,
  DateTime? endAt,
  required bool isPublished,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/clubs/$clubId/events',
    data: {
      'title': title,
      'description': description,
      'location': location,
      'start_at': startAt.toIso8601String(),
      if (endAt != null) 'end_at': endAt.toIso8601String(),
      'is_published': isPublished,
    },
  );
  return ClubEvent.fromJson(response.data);
}

Future<ClubPost> createClubPost(
  WidgetRef ref,
  String clubId, {
  required String title,
  required String body,
  String imageUrl = '',
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/clubs/$clubId/posts',
    data: {'title': title, 'body': body, 'image_url': imageUrl},
  );
  return ClubPost.fromJson(response.data);
}
