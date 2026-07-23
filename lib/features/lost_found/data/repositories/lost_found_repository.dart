import 'dart:typed_data';

import '/core/network/api_client.dart';
import '../models/lost_found_category.dart';
import '../models/lost_found_claim.dart';
import '../models/lost_found_item.dart';

/// Talks to the Lost & Found Portal endpoints. Photos are uploaded to the
/// generic `/upload` endpoint first (same as merchant logos/marketplace
/// categories); the resulting URLs are then sent as plain JSON when
/// creating/updating an item, matching how ProductHandler expects them.
class LostFoundRepository {
  final ApiClient apiClient;

  LostFoundRepository(this.apiClient);

  Future<List<LostFoundCategory>> getCategories() async {
    final response = await apiClient.get('/lost-found-categories');
    final data = response.data;
    final items = data is List
        ? data
        : (data as Map<String, dynamic>)['data'] as List? ?? [];
    return items
        .map((e) => LostFoundCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LostFoundItem>> getItemsByLocation({
    required String universityId,
    required String departmentId,
    String? categoryId,
    String? type,
    String? search,
  }) async {
    final response = await apiClient.get(
      '/lost-found-items-by-location',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
        if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
        if (type != null && type.isNotEmpty) 'type': type,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final data = response.data;
    final items = data is Map<String, dynamic> ? data['data'] as List? ?? [] : data as List;
    return items
        .map((e) => LostFoundItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LostFoundItem>> getMyItems() async {
    final response = await apiClient.get('/my/lost-found-items');
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List? ?? [];
    return items
        .map((e) => LostFoundItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LostFoundItem> getItemById(String id) async {
    final response = await apiClient.get('/lost-found-items/$id');
    return LostFoundItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    final response = await apiClient.uploadBytes(
      '/upload',
      bytes: bytes,
      fileName: fileName,
      fieldName: 'image',
      data: {'folder': 'lost-found'},
    );
    return (response.data['file_url'] ?? response.data['url']) as String;
  }

  Future<LostFoundItem> createItem(
    LostFoundItem draft, {
    required String universityId,
    String? departmentId,
  }) async {
    final response = await apiClient.post(
      '/my/lost-found-items',
      data: draft.toCreateJson(
        targets: [
          {
            'university_id': universityId,
            'department_id': departmentId ?? '00000000-0000-0000-0000-000000000000',
          },
        ],
      ),
    );
    return LostFoundItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> resolveItem(String id) async {
    await apiClient.post('/my/lost-found-items/$id/resolve');
  }

  Future<void> deleteItem(String id) async {
    await apiClient.delete('/my/lost-found-items/$id');
  }

  Future<LostFoundClaim> createClaim(String itemId, {String message = ''}) async {
    final response = await apiClient.post(
      '/lost-found-items/$itemId/claims',
      data: {'message': message},
    );
    return LostFoundClaim.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<LostFoundClaim>> getClaimsForItem(String itemId) async {
    final response = await apiClient.get('/my/lost-found-items/$itemId/claims');
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List? ?? [];
    return items
        .map((e) => LostFoundClaim.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Accepts a claim on the caller's own item, and returns the raw
  /// conversation payload (opened via GetOrCreateConversation) so the caller
  /// can navigate straight to the chat with the claimant.
  Future<Map<String, dynamic>> acceptClaim(String itemId, String claimId) async {
    final response = await apiClient.post(
      '/my/lost-found-items/$itemId/claims/$claimId/accept',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> rejectClaim(String itemId, String claimId) async {
    await apiClient.post('/my/lost-found-items/$itemId/claims/$claimId/reject');
  }

  Future<void> reportItem(String itemId, String reason) async {
    await apiClient.post(
      '/lost-found-items/$itemId/report',
      data: {'reason': reason},
    );
  }
}
