import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/core/widgets/app_loader.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/presentation/widgets/batch_cover.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/features/student/presentation/widgets/student_paged_list.dart';

/// Irregular students in a batch (count only, limit=1); regular = total −
/// this. Null when it can't be fetched (offline), and the header then
/// leaves the regular/irregular split out.
final _irregularCountProvider = FutureProvider.autoDispose.family<int?, String>(
  (ref, batchId) async {
    try {
      final response = await ref
          .watch(apiClientProvider)
          .get(
            ApiEndpoints.students,
            queryParameters: {
              'batch_id': batchId,
              'is_regular': 'false',
              'include_history': 'true',
              'limit': '1',
            },
          );
      return (response.data as Map<String, dynamic>)['count'] as int?;
    } catch (_) {
      return null;
    }
  },
);

/// One batch's students (opened from a card on [AllStudentsPage]), under the
/// batch cover with its details laid over it. [batch] is the batch id, or
/// [all] for every student of the department in one list (the "All" button).
class BatchStudentsPage extends ConsumerStatefulWidget {
  const BatchStudentsPage({super.key, required this.batch});
  final String batch;

  static const all = 'all';

  @override
  ConsumerState<BatchStudentsPage> createState() => _BatchStudentsPageState();
}

class _BatchStudentsPageState extends ConsumerState<BatchStudentsPage> {
  String _searchQuery = '';
  Timer? _searchDebounce;

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim());
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final batches = ref.watch(batchProviderAll).value;
    if (widget.batch == BatchStudentsPage.all) {
      // The department comes from its batches (all in the user's department).
      final first = batches?.firstOrNull;
      return CustomHeaderLayout(
        title: 'All Students',
        searchAtBottom: true,
        searchHint: 'Search by name, ID or phone...',
        onSearchChanged: _onSearchChanged,
        body: first == null
            ? const Center(child: AppLoader())
            : StudentPagedList(
                universityId: first.universityId,
                departmentId: first.departmentId,
                batchName: 'All',
                search: _searchQuery,
              ),
      );
    }

    final batch = batches?.where((b) => b.id == widget.batch).firstOrNull;

    return CustomHeaderLayout(
      title: batch?.name ?? 'Students',
      searchAtBottom: true,
      searchHint: 'Search by name, ID or phone...',
      onSearchChanged: _onSearchChanged,
      body: StudentPagedList(
        batchId: widget.batch,
        batchName: batch?.name ?? '',
        search: _searchQuery,
        header: batch == null || _searchQuery.isNotEmpty
            ? null
            : BatchCoverHeader(
                batch: batch,
                total: ref.watch(studentCountByBatchProvider(batch.id)).value,
                irregular: ref.watch(_irregularCountProvider(batch.id)).value,
              ),
      ),
    );
  }
}
