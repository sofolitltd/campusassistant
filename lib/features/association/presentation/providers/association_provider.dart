import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '../../domain/entities/association.dart';
import '../../../university/presentation/providers/university_provider.dart';

part 'association_provider.g.dart';

/// All associations (district- and sub-district-scoped alike) for the
/// current user's own university — one flat list, no type split. Skips the
/// repository/usecase/dartz/cache layer entirely (no offline fallback for
/// this feature), matching the lighter pattern already used for club
/// sub-resources (events/posts/members).
@riverpod
Future<List<Association>> associationsList(Ref ref) async {
  final university = await ref.watch(myUniversityProvider.future);
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    ApiEndpoints.associationsByLocation,
    queryParameters: {'university_id': university.id},
  );
  final data = response.data as List;
  return data
      .map((e) => Association.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Associations that genuinely match the current student's home address —
/// "Suggested for you" on the associations tab. Reuses the same
/// /associations-by-location endpoint as [associationsListProvider] with an
/// added district_id filter (deliberately omitting sub_district_id from the
/// query itself, since the backend ANDs filters together and that would
/// exclude district-wide associations that don't target a specific upazila).
/// On top of that server-side filter, this provider then drops anything
/// that isn't actually relevant: associations the student already joined
/// or has a pending join request for, and sub-district-scoped associations
/// whose upazila doesn't match the student's own — a sub-district
/// association from elsewhere in the same district isn't a real match just
/// because the district matches.
final suggestedAssociationsProvider = FutureProvider<List<Association>>((
  ref,
) async {
  final userId = (await ref.watch(currentUserProvider.future))?.id;
  if (userId == null) return [];

  final student = await ref.watch(studentByUserIdProvider(userId).future);
  final address = student?.presentAddress;
  final districtId = address?.districtId;
  if (districtId == null) return [];

  final university = await ref.watch(myUniversityProvider.future);
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    ApiEndpoints.associationsByLocation,
    queryParameters: {'university_id': university.id, 'district_id': districtId},
  );
  final data = response.data as List;
  final associations = data
      .map((e) => Association.fromJson(e as Map<String, dynamic>))
      .toList();

  return associations.where((a) {
    if (a.isMember || a.isPendingMember) return false;
    if (a.associationType == 'sub_district') {
      return a.subDistrictId != null && a.subDistrictId == address?.subDistrictId;
    }
    return true;
  }).toList();
});

/// Associations the current user has formally joined — powers "My Joined
/// Associations". Distinct from a manage/ownership list (there is no
/// equivalent "MyAssociations" screen wired up yet; the backend's
/// GET /my/associations, which lists owned/co-managed associations, is
/// separate from this GET /my/associations/joined).
final myJoinedAssociationsProvider = FutureProvider<List<Association>>((
  ref,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/associations/joined');
  final data = response.data as List;
  return data
      .map((e) => Association.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Fetches a single association by ID — used when
/// AssociationDetailsPage is reached via a deep link (e.g. an association
/// event push notification) with no Association object already in hand.
@riverpod
Future<Association> associationById(Ref ref, String associationId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    '${ApiEndpoints.associations}/$associationId',
  );
  return Association.fromJson(response.data);
}

Future<void> followAssociation(WidgetRef ref, String associationId) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.post('${ApiEndpoints.associations}/$associationId/follow');
}

Future<void> unfollowAssociation(WidgetRef ref, String associationId) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('${ApiEndpoints.associations}/$associationId/follow');
}

Future<void> joinAssociation(WidgetRef ref, String associationId) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.post('${ApiEndpoints.associations}/$associationId/join');
}

Future<void> leaveAssociation(WidgetRef ref, String associationId) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('${ApiEndpoints.associations}/$associationId/join');
}

Future<Association> suggestAssociation(
  WidgetRef ref,
  Association association,
) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '${ApiEndpoints.associations}/suggest',
    data: association.toJson(),
  );
  return Association.fromJson(response.data);
}
