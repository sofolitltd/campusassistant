import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '/core/di.dart';
import '/features/community/data/models/community_post.dart';

final communityPostsProvider =
    StateNotifierProvider.family<CommunityPostsNotifier, List<CommunityPost>, String>(
      (ref, scope) => CommunityPostsNotifier(ref, scope),
    );

class CommunityPostsNotifier extends StateNotifier<List<CommunityPost>> {
  final Ref ref;
  final String scope;

  CommunityPostsNotifier(this.ref, this.scope) : super([]);

  Future<void> fetch() async {
    final repo = ref.read(communityRepositoryProvider);
    if (scope == 'liked') {
      state = await repo.getLikedPosts();
    } else if (scope == 'saved') {
      state = await repo.getSavedPosts();
    } else {
      state = await repo.getPosts(scope);
    }
  }

  void remove(String postId) {
    state = state.where((p) => p.id != postId).toList();
  }
}
