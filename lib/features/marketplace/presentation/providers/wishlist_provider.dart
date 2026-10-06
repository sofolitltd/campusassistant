import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/product.dart';

/// Ids of the products the signed-in user has saved. Toggling is optimistic:
/// the heart flips at once and flips back if the request fails.
class WishlistIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final uid = ref.watch(userProvider.select((u) => u.value?.uid));
    if (uid != null) _load();
    return {};
  }

  Future<void> _load() async {
    try {
      final response = await ref.read(apiClientProvider).get('/my/wishlist/ids');
      final ids = ((response.data as Map<String, dynamic>)['data'] as List? ?? []).cast<String>();
      if (ref.mounted) state = {...state, ...ids};
    } catch (_) {}
  }

  bool contains(String productId) => state.contains(productId);

  /// Returns false when the request failed and the change was rolled back.
  Future<bool> toggle(String productId) async {
    final api = ref.read(apiClientProvider);
    final wasSaved = state.contains(productId);
    state = wasSaved ? ({...state}..remove(productId)) : {...state, productId};
    try {
      if (wasSaved) {
        await api.delete('/my/wishlist/$productId');
      } else {
        await api.put('/my/wishlist/$productId');
      }
      return true;
    } catch (_) {
      if (ref.mounted) state = wasSaved ? {...state, productId} : ({...state}..remove(productId));
      return false;
    }
  }
}

final wishlistIdsProvider = NotifierProvider<WishlistIdsNotifier, Set<String>>(WishlistIdsNotifier.new);

/// The saved products themselves, newest first. Refetches when the saved set changes.
final wishlistProductsProvider = FutureProvider<List<Product>>((ref) async {
  ref.watch(wishlistIdsProvider.select((s) => s.length));
  final response = await ref.watch(apiClientProvider).get('/my/wishlist');
  final data = (response.data as Map<String, dynamic>)['data'] as List? ?? [];
  return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
});
