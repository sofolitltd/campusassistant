import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/features/club/data/models/club_user_summary.dart';
import '../../data/models/association_event.dart';
import '../../data/models/association_post.dart';
import '../../domain/entities/association.dart';

/// Public, read-only association sub-resources — mirrors clubPostsProvider/
/// clubMembersProvider. Reuses ClubUserSummary directly since the backend's
/// /associations/:id/members and /my/associations/:id/managers return the
/// exact same {user_id, first_name, last_name, avatar_url, role} shape as
/// clubs — no association-specific fields, so no reason to duplicate it.
final associationPostsProvider =
    FutureProvider.family<List<AssociationPost>, String>((
      ref,
      associationId,
    ) async {
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '${ApiEndpoints.associations}/$associationId/posts',
      );
      final data = response.data as List;
      return data
          .map((e) => AssociationPost.fromJson(e as Map<String, dynamic>))
          .toList();
    });

final associationMembersProvider =
    FutureProvider.family<List<ClubUserSummary>, String>((
      ref,
      associationId,
    ) async {
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '${ApiEndpoints.associations}/$associationId/members',
      );
      final data = response.data as List;
      return data
          .map((e) => ClubUserSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    });

/// Associations the current user created or co-manages — powers "My
/// Associations".
final myAssociationsProvider = FutureProvider<List<Association>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/associations');
  final data = response.data as List;
  return data
      .map((e) => Association.fromJson(e as Map<String, dynamic>))
      .toList();
});

Future<List<ClubUserSummary>> getAssociationFollowersForPromotion(
  WidgetRef ref,
  String associationId,
) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get(
    '/my/associations/$associationId/followers',
  );
  final data = response.data as List;
  return data
      .map((e) => ClubUserSummary.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<List<ClubUserSummary>> getAssociationManagers(
  WidgetRef ref,
  String associationId,
) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get(
    '/my/associations/$associationId/managers',
  );
  final data = response.data as List;
  return data
      .map((e) => ClubUserSummary.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<void> promoteAssociationManager(
  WidgetRef ref,
  String associationId,
  String userId,
  String role,
) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.post(
    '/my/associations/$associationId/managers',
    data: {'user_id': userId, 'role': role},
  );
}

Future<void> removeAssociationManager(
  WidgetRef ref,
  String associationId,
  String userId,
) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/my/associations/$associationId/managers/$userId');
}

/// Updates only the content-field whitelist the backend allows via
/// /my/associations/:id (never is_active/is_verified/university_id/
/// district_id/sub_district_id/association_type — those stay admin-only).
Future<Association> updateMyAssociation(
  WidgetRef ref,
  String associationId,
  Map<String, dynamic> fields,
) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put(
    '/my/associations/$associationId',
    data: fields,
  );
  return Association.fromJson(response.data);
}

Future<AssociationEvent> createMyAssociationEvent(
  WidgetRef ref,
  String associationId, {
  required String title,
  required String description,
  required String location,
  required DateTime startAt,
  DateTime? endAt,
  required bool isPublished,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/associations/$associationId/events',
    data: {
      'title': title,
      'description': description,
      'location': location,
      'start_at': startAt.toIso8601String(),
      if (endAt != null) 'end_at': endAt.toIso8601String(),
      'is_published': isPublished,
    },
  );
  return AssociationEvent.fromJson(response.data);
}

Future<AssociationPost> createAssociationPost(
  WidgetRef ref,
  String associationId, {
  required String title,
  required String body,
  String imageUrl = '',
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/associations/$associationId/posts',
    data: {'title': title, 'body': body, 'image_url': imageUrl},
  );
  return AssociationPost.fromJson(response.data);
}
