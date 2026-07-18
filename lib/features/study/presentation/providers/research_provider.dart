import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/resource/presentation/providers/resource_provider.dart';
import '../../../../features/resource/domain/entities/resource.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/research_model.dart';

final researchSearchQueryProvider =
    NotifierProvider<ResearchSearchNotifier, String>(
      ResearchSearchNotifier.new,
    );

class ResearchSearchNotifier extends Notifier<String> {
  @override
  String build() => "";
  @override
  set state(String value) => super.state = value;
}

final researchPaginationProvider =
    AsyncNotifierProvider<ResearchPaginationNotifier, List<ResearchModel>>(
      ResearchPaginationNotifier.new,
    );

class ResearchPaginationNotifier extends AsyncNotifier<List<ResearchModel>> {
  bool _hasMore = true;
  bool _isLoading = false;
  static const int _limit = 20;

  @override
  Future<List<ResearchModel>> build() async {
    _hasMore = true;
    _isLoading = false;
    return _load(offset: 0);
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoading) return;
    final current = state.asData?.value ?? [];
    if (current.isEmpty) return;
    _isLoading = true;
    try {
      final newItems = await _load(offset: current.length);
      if (newItems.isNotEmpty) {
        state = AsyncValue.data([...current, ...newItems]);
      }
    } catch (e) {
      debugPrint('[ResearchRepo] loadNextPage error: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<List<ResearchModel>> _load({required int offset}) async {
    final user = await ref.watch(userProvider.future);

    final searchQuery = ref.read(researchSearchQueryProvider);
    final repo = ref.read(resourceRepositoryProvider);
    final result = await repo.getResources(
      universityId: user.information.universityId ?? '',
      departmentId: user.information.departmentId ?? '',
      type: 'research',
      search: searchQuery.isEmpty ? null : searchQuery,
      limit: _limit,
      offset: offset,
    );

    return result.fold(
      (failure) {
        debugPrint('[ResearchRepo] Error loading: $failure');
        return [];
      },
      (paginated) {
        _hasMore = offset + _limit < paginated.total;
        return paginated.resources.map(_toResearchModel).toList();
      },
    );
  }

  ResearchModel _toResearchModel(Resource resource) {
    return ResearchModel(
      id: resource.id,
      author: resource.description,
      department: resource.batches.isNotEmpty ? resource.batches.first : '',
      fileUrl: resource.fileUrl,
      title: resource.title,
      type: resource.courseCode,
      university: resource.universityId,
      uploadDate: resource.createdAt?.toIso8601String() ?? '',
      webUrl: resource.fileUrl,
    );
  }

  Future<void> refresh() async {
    _hasMore = true;
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _load(offset: 0));
  }

  bool get hasMore => _hasMore;
}
