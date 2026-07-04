import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/research_model.dart';

final researchSearchQueryProvider =
    NotifierProvider<ResearchSearchNotifier, String>(ResearchSearchNotifier.new);

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
  // DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  final bool _isLoading = false;

  @override
  Future<List<ResearchModel>> build() async {
    // Temporary placeholder - returns empty list
    return [];
    // return _loadNextPage(initial: true);
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoading) return;
    // await _loadNextPage();
  }

  // Future<List<ResearchModel>> _loadNextPage({bool initial = false}) async {
  //   _isLoading = true;

  //   final user = ref.read(userProvider).value;
  //   if (user == null) {
  //     _isLoading = false;
  //     return [];
  //   }

  //   try {
  //     Query query = FirebaseFirestore.instance
  //         .collection('researches')
  //         .where('university', isEqualTo: user.university)
  //         .where('department', isEqualTo: user.department)
  //         .limit(_limit);

  //     if (_lastDocument != null) {
  //       query = query.startAfterDocument(_lastDocument!);
  //     }

  //     final snapshot = await query.get();
  //     final currentData = state.value ?? [];

  //     if (snapshot.docs.isNotEmpty) {
  //       _lastDocument = snapshot.docs.last;
  //       if (snapshot.docs.length < _limit) _hasMore = false;

  //       final newItems = snapshot.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         data['id'] = doc.id;
  //         return ResearchModel.fromJson(data);
  //       }).toList();

  //       final newData = [...currentData, ...newItems];
  //       state = AsyncValue.data(newData);
  //     } else {
  //       _hasMore = false;
  //       if (initial && currentData.isEmpty) state = AsyncValue.data([]);
  //     }
  //   } catch (e, st) {
  //     print('❌ Error loading research: $e');
  //     _isLoading = false;
  //     if (initial) state = AsyncValue.error(e, st);
  //   } finally {
  //     _isLoading = false;
  //   }

  //   return state.value ?? [];
  // }

  Future<void> refresh() async {
    // _lastDocument = null;
    _hasMore = true;
    state = const AsyncValue.data([]);
    // _loadNextPage(initial: true);
  }

  bool get hasMore => _hasMore;
}
