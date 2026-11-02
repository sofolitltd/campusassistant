import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/cache/cache_manager.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/app_loader.dart';
import '/core/widgets/glass_search_bar.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/features/student/presentation/screens/student_card.dart';

/// A server-paginated (20 per page) student list: one batch when [batchId]
/// is set, otherwise the whole department. [search] goes to the server
/// (name / student ID / phone / email); changing it returns to page 1.
///
/// [header] scrolls with the list (e.g. the batch cover photo).
class StudentPagedList extends ConsumerStatefulWidget {
  const StudentPagedList({
    super.key,
    this.batchId,
    this.universityId,
    this.departmentId,
    required this.batchName,
    this.search = '',
    this.header,
  });

  final String? batchId;
  final String? universityId;
  final String? departmentId;
  final String batchName;
  final String search;
  final Widget? header;

  @override
  ConsumerState<StudentPagedList> createState() => _StudentPagedListState();
}

class _StudentPagedListState extends ConsumerState<StudentPagedList> {
  static const int _pageSize = 20;
  int _page = 1;

  @override
  void didUpdateWidget(StudentPagedList old) {
    super.didUpdateWidget(old);
    if (old.search != widget.search || old.batchId != widget.batchId) {
      _page = 1;
    }
  }

  /// Pull-to-refresh: drops the cached pages (they're served without hitting
  /// the network while fresh) and re-fetches the visible ones.
  Future<void> _refresh() async {
    await ref.read(cacheManagerProvider).invalidate('student_page');
    ref.invalidate(studentsWithTotalAllPaginatedProvider);
    ref.invalidate(studentsWithTotalByBatchPaginatedProvider);
    ref.invalidate(studentCountAllProvider);
    ref.invalidate(studentCountByBatchProvider);
  }

  @override
  Widget build(BuildContext context) {
    final offset = (_page - 1) * _pageSize;
    final search = widget.search.isEmpty ? null : widget.search;
    final batchId = widget.batchId;
    final paginatedAsync = batchId != null
        ? ref.watch(
            studentsWithTotalByBatchPaginatedProvider(
              batchId: batchId,
              limit: _pageSize,
              offset: offset,
              search: search,
            ),
          )
        : ref.watch(
            studentsWithTotalAllPaginatedProvider(
              universityId: widget.universityId,
              departmentId: widget.departmentId,
              limit: _pageSize,
              offset: offset,
              search: search,
            ),
          );

    return paginatedAsync.when(
      data: (paginated) {
        final totalCount = paginated.total;
        // A batch reads oldest roll first (2501, 2502...); the whole
        // department newest first.
        final students = _sortByRollNumber(
          paginated.students,
          ascending: batchId != null,
        );

        final totalPages = totalCount > 0 ? (totalCount / _pageSize).ceil() : 0;
        final page = totalPages > 0 ? _page.clamp(1, totalPages) : 1;
        final startIndex = (page - 1) * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, totalCount);

        return _buildStudentList(
          students: students,
          currentPage: page,
          totalPages: totalPages,
          totalItems: totalCount,
          startIndex: startIndex + 1,
          endIndex: endIndex,
        );
      },
      loading: () => const Center(child: AppLoader()),
      error: (e, s) => Center(child: Text(e.toString())),
    );
  }

  Widget _buildEmptyState() {
    final searching = widget.search.isNotEmpty;
    return Column(
      mainAxisAlignment: .center,
      children: [
        Icon(
          searching ? LucideIcons.searchX : LucideIcons.users,
          size: 48,
          color: context.colors.borderStrong,
        ),
        const SizedBox(height: Spacing.md),
        Text(
          searching ? 'No matches found' : 'No students found!',
          style: TextStyle(color: context.colors.textSubtle, fontWeight: .w500),
        ),
      ],
    );
  }

  Widget _buildStudentList({
    required List<Student> students,
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int startIndex,
    required int endIndex,
  }) {
    final header = widget.header;
    final searching = widget.search.isNotEmpty;
    // Leading rows before the students: the header, the search result count.
    final leading = <Widget>[
      ?header,
      if (searching)
        Row(
          children: [
            Container(
              width: 3,
              height: 12,
              decoration: BoxDecoration(
                color: context.colors.info,
                borderRadius: BorderRadius.circular(RadiusToken.xs),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Text(
              'Found $totalItems Students',
              style: TextStyle(
                fontWeight: .w700,
                fontSize: FontSizeToken.sm,
                color: context.colors.text,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
    ];
    final hasPager = totalPages > 1;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.lg,
          Spacing.lg,
          GlassSearchBar.listBottomPadding(context),
        ),
        children: [
          for (final w in leading) ...[w, const SizedBox(height: Spacing.md)],
          if (students.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.xxxxl),
              child: _buildEmptyState(),
            ),
          for (var i = 0; i < students.length; i++) ...[
            if (i > 0) const SizedBox(height: Spacing.md),
            StudentCard(
              studentModel: students[i],
              selectedBatch: widget.batchName,
            ),
          ],
          if (hasPager)
            _buildPagination(
              currentPage: currentPage,
              totalPages: totalPages,
              totalItems: totalItems,
              startIndex: startIndex,
              endIndex: endIndex,
            ),
        ],
      ),
    );
  }

  /// `ascending: true` → oldest first (2501, 2502...)
  /// `ascending: false` → newest first (25040, 25039...)
  List<Student> _sortByRollNumber(
    List<Student> students, {
    bool ascending = false,
  }) {
    return List<Student>.from(students)..sort((a, b) {
      final numA = int.tryParse(a.studentId) ?? 0;
      final numB = int.tryParse(b.studentId) ?? 0;
      return ascending ? numA.compareTo(numB) : numB.compareTo(numA);
    });
  }

  void _goTo(int page) => setState(() => _page = page);

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int startIndex,
    required int endIndex,
  }) {
    List<int> pageNumbers;
    if (totalPages <= 5) {
      pageNumbers = List.generate(totalPages, (i) => i + 1);
    } else if (currentPage <= 3) {
      pageNumbers = [1, 2, 3, 4, 5];
    } else if (currentPage >= totalPages - 2) {
      pageNumbers = List.generate(5, (i) => totalPages - 4 + i);
    } else {
      pageNumbers = List.generate(5, (i) => currentPage - 2 + i);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: Column(
        children: [
          Text(
            'Showing $startIndex-$endIndex of $totalItems',
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              color: context.colors.textMuted,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: .center,
            children: [
              _buildPageButton(
                icon: Icons.chevron_left,
                isEnabled: currentPage > 1,
                onTap: () => _goTo(currentPage - 1),
              ),
              const SizedBox(width: Spacing.xs),
              ...pageNumbers.map(
                (page) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xxs),
                  child: _buildPageNumberButton(
                    page: page,
                    isSelected: page == currentPage,
                    onTap: () => _goTo(page),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              _buildPageButton(
                icon: Icons.chevron_right,
                isEnabled: currentPage < totalPages,
                onTap: () => _goTo(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.borderStrong),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled ? context.colors.text : context.colors.textSubtle,
        ),
      ),
    );
  }

  Widget _buildPageNumberButton({
    required int page,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary : context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.borderStrong,
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: FontSizeToken.md,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? context.colors.onPrimary
                  : context.colors.text,
            ),
          ),
        ),
      ),
    );
  }
}
