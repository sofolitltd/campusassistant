import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/lost_found_category.dart';
import '../../data/models/lost_found_claim.dart';
import '../../data/models/lost_found_item.dart';

enum LostFoundFeedTab { lost, found, myPosts }

final lostFoundCategoriesProvider =
    FutureProvider<List<LostFoundCategory>>((ref) async {
  final repo = ref.watch(lostFoundRepositoryProvider);
  return repo.getCategories();
});

/// Narrows the feed to the viewer's own university/department (same
/// global-or-targeted scoping model as Product/Skill), plus an optional
/// category filter.
final lostFoundFeedProvider = FutureProvider.family<List<LostFoundItem>,
    ({LostFoundFeedTab tab, String? categoryId, String? search})>(
  (ref, params) async {
    final repo = ref.watch(lostFoundRepositoryProvider);

    if (params.tab == LostFoundFeedTab.myPosts) {
      return repo.getMyItems();
    }

    final profile = await ref.watch(userProvider.future);
    return repo.getItemsByLocation(
      universityId: profile.university,
      departmentId: profile.department,
      categoryId: params.categoryId,
      type: params.tab == LostFoundFeedTab.found ? 'found' : 'lost',
      search: params.search,
    );
  },
);

final lostFoundItemDetailProvider =
    FutureProvider.family<LostFoundItem, String>((ref, itemId) async {
  final repo = ref.watch(lostFoundRepositoryProvider);
  return repo.getItemById(itemId);
});

final lostFoundClaimsProvider =
    FutureProvider.family<List<LostFoundClaim>, String>((ref, itemId) async {
  final repo = ref.watch(lostFoundRepositoryProvider);
  return repo.getClaimsForItem(itemId);
});

/// Bumped after any mutation (create/claim/accept/reject/resolve) so feed and
/// detail providers refetch, same pattern as CommunityRefreshNotifier.
class LostFoundRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

final lostFoundRefreshProvider =
    NotifierProvider<LostFoundRefreshNotifier, int>(LostFoundRefreshNotifier.new);

class LostFoundActions {
  final Ref ref;
  LostFoundActions(this.ref);

  Future<LostFoundItem> createItem({
    required LostFoundType type,
    required String title,
    required String description,
    String? categoryId,
    required String location,
    DateTime? eventDate,
    List<Uint8List> images = const [],
  }) async {
    final repo = ref.read(lostFoundRepositoryProvider);
    final profile = await ref.read(userProvider.future);

    final imageUrls = <String>[];
    for (var i = 0; i < images.length; i++) {
      imageUrls.add(await repo.uploadImage(images[i], 'lost_found_$i.jpg'));
    }

    final draft = LostFoundItem(
      id: '',
      type: type,
      title: title,
      description: description,
      categoryId: categoryId,
      imageUrls: imageUrls,
      location: location,
      eventDate: eventDate,
      status: LostFoundStatus.open,
      posterId: profile.uid,
      createdAt: DateTime.now(),
    );

    final created = await repo.createItem(
      draft,
      universityId: profile.university,
      departmentId: profile.department,
    );
    ref.read(lostFoundRefreshProvider.notifier).bump();
    return created;
  }

  Future<void> resolveItem(String itemId) async {
    await ref.read(lostFoundRepositoryProvider).resolveItem(itemId);
    ref.read(lostFoundRefreshProvider.notifier).bump();
  }

  Future<void> deleteItem(String itemId) async {
    await ref.read(lostFoundRepositoryProvider).deleteItem(itemId);
    ref.read(lostFoundRefreshProvider.notifier).bump();
  }

  Future<void> claimItem(String itemId, {String message = ''}) async {
    await ref.read(lostFoundRepositoryProvider).createClaim(itemId, message: message);
    ref.read(lostFoundRefreshProvider.notifier).bump();
  }

  /// Returns the opened/reused conversation id so the caller can navigate to
  /// the chat screen with the claimant.
  Future<String?> acceptClaim(String itemId, String claimId) async {
    final result = await ref.read(lostFoundRepositoryProvider).acceptClaim(itemId, claimId);
    ref.read(lostFoundRefreshProvider.notifier).bump();
    final conversation = result['conversation'] as Map<String, dynamic>?;
    return conversation?['id'] as String?;
  }

  Future<void> rejectClaim(String itemId, String claimId) async {
    await ref.read(lostFoundRepositoryProvider).rejectClaim(itemId, claimId);
    ref.read(lostFoundRefreshProvider.notifier).bump();
  }

  Future<void> reportItem(String itemId, String reason) async {
    await ref.read(lostFoundRepositoryProvider).reportItem(itemId, reason);
  }
}

final lostFoundActionsProvider = Provider<LostFoundActions>((ref) {
  return LostFoundActions(ref);
});
