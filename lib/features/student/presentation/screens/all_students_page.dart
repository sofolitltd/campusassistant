import 'dart:async';

import '/features/batch/domain/entities/batch.dart';
import '/features/student/domain/entities/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/cache/cache_manager.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/student/presentation/screens/student_card.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class AllStudentsPage extends ConsumerStatefulWidget {
  const AllStudentsPage({super.key});

  @override
  ConsumerState<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends ConsumerState<AllStudentsPage>
    with TickerProviderStateMixin {
  // Sent to the server (name / student ID / phone / email). Client-side
  // filtering only saw the 20 rows of the current page.
  String _searchQuery = '';
  Timer? _searchDebounce;
  TabController? _tabController;
  static const int _pageSize = 20;
  final Map<String, int> _currentPage = {};

  /// Pull-to-refresh: drops the cached pages (they're served without hitting
  /// the network while fresh) and re-fetches the visible ones.
  Future<void> _refresh() async {
    await ref.read(cacheManagerProvider).invalidate('student_page');
    ref.invalidate(studentsWithTotalAllPaginatedProvider);
    ref.invalidate(studentsWithTotalByBatchPaginatedProvider);
    ref.invalidate(studentCountAllProvider);
    ref.invalidate(studentCountByBatchProvider);
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = value.trim();
        _currentPage.clear();
      });
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _tabController?.dispose();
    super.dispose();
  }

  int _getPage(String batchId) => _currentPage[batchId] ?? 1;

  void _setPage(String batchId, int page) {
    setState(() {
      _currentPage[batchId] = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final batchesAsync = ref.watch(batchProviderAll);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return batchesAsync.when(
      data: (batches) {
        if (batches.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Students'),
              centerTitle: true,
            ),
            body: const Center(child: Text('No batches found!')),
          );
        }
        // Sort batches descending: Batch 21, Batch 20, Batch 19...
        final sortedBatches = List<Batch>.from(batches)
          ..sort((a, b) => b.name.compareTo(a.name));

        // Insert "All" tab at the beginning
        final List<Batch> displayBatches = [
          Batch(
            id: 'all',
            name: 'All',
            slug: 'all',
            isStudying: true,
            departmentId: sortedBatches.first.departmentId,
            universityId: sortedBatches.first.universityId,
            sessions: [],
          ),
          ...sortedBatches,
        ];

        // Initialize or update TabController when batches data changes
        if (_tabController == null ||
            _tabController!.length != displayBatches.length) {
          _tabController?.dispose();
          _tabController = TabController(
            length: displayBatches.length,
            vsync: this,
          );
        }

        return CustomHeaderLayout(
          title: 'All Students',
          searchAtBottom: true,
          searchHint: 'Search by name, ID or phone...',
          onSearchChanged: _onSearchChanged,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.sm,
                ),
                child: SectionTabBar(
                  controller: _tabController!,
                  isScrollable: true,
                  tabs: displayBatches.map((b) {
                    // Lightweight count for tab label
                    final countAsync = b.id == 'all'
                        ? ref.watch(
                            studentCountAllProvider(
                              universityId: b.universityId,
                              departmentId: b.departmentId,
                            ),
                          )
                        : ref.watch(studentCountByBatchProvider(b.id));
                    final count = countAsync.maybeWhen(
                      data: (d) => d,
                      orElse: () => 0,
                    );
                    return Tab(text: count > 0 ? '${b.name} ($count)' : b.name);
                  }).toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController!,
                  children: displayBatches.map<Widget>((batch) {
                    // "All" tab: fetch all students (client-side pagination)
                    if (batch.id == 'all') {
                      return _buildAllTab(batch, isDark);
                    }

                    // Batch tabs: server-side pagination
                    return _buildBatchTab(batch, isDark);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('All Students'), centerTitle: true),
        body: const Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('All Students'), centerTitle: true),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  // ===========================================================================
  // "All" tab — server-side pagination (limit/offset)
  // ===========================================================================
  Widget _buildAllTab(Batch batch, bool isDark) {
    final currentPage = _getPage('all');
    final offset = (currentPage - 1) * _pageSize;

    final paginatedAsync = ref.watch(
      studentsWithTotalAllPaginatedProvider(
        universityId: batch.universityId,
        departmentId: batch.departmentId,
        limit: _pageSize,
        offset: offset,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      ),
    );

    return paginatedAsync.when(
      data: (paginated) {
        final totalCount = paginated.total;
        final students = paginated.students;

        final displayedStudents = _sortByRollNumber(students);

        if (displayedStudents.isEmpty && _searchQuery.isEmpty) {
          return _buildEmptyState(isDark);
        }

        final totalPages = totalCount > 0 ? (totalCount / _pageSize).ceil() : 0;
        final clampedPage = totalPages > 0
            ? currentPage.clamp(1, totalPages)
            : 1;
        final startIndex = (clampedPage - 1) * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, totalCount);

        return _buildStudentList(
          students: displayedStudents,
          batchName: batch.name,
          currentPage: clampedPage,
          totalPages: totalPages,
          totalItems: totalCount,
          startIndex: startIndex + 1,
          endIndex: endIndex,
          isDark: isDark,
          onPageChanged: (page) => _setPage('all', page),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, s) => Center(child: Text(e.toString())),
    );
  }

  // ===========================================================================
  // Batch tabs — server-side pagination (limit/offset)
  // ===========================================================================
  Widget _buildBatchTab(Batch batch, bool isDark) {
    final currentPage = _getPage(batch.id);
    final offset = (currentPage - 1) * _pageSize;

    // Single combined provider: returns students + total count together
    final paginatedAsync = ref.watch(
      studentsWithTotalByBatchPaginatedProvider(
        batchId: batch.id,
        limit: _pageSize,
        offset: offset,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      ),
    );

    return paginatedAsync.when(
      data: (paginated) {
        final totalCount = paginated.total;
        final students = paginated.students;

        // Client-side search within current page (or fetch all for search)
        final displayedStudents = _sortByRollNumber(students, ascending: true);

        if (displayedStudents.isEmpty && _searchQuery.isEmpty) {
          return _buildEmptyState(isDark);
        }

        final totalPages = totalCount > 0 ? (totalCount / _pageSize).ceil() : 0;
        final clampedPage = totalPages > 0
            ? currentPage.clamp(1, totalPages)
            : 1;
        final startIndex = (clampedPage - 1) * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, totalCount);

        return _buildStudentList(
          students: displayedStudents,
          batchName: batch.name,
          currentPage: clampedPage,
          totalPages: totalPages,
          totalItems: totalCount,
          startIndex: startIndex + 1,
          endIndex: endIndex,
          isDark: isDark,
          onPageChanged: (page) => _setPage(batch.id, page),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, s) => Center(child: Text(e.toString())),
    );
  }

  // ===========================================================================
  // Shared UI components
  // ===========================================================================
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? LucideIcons.searchX : LucideIcons.users,
            size: 48,
            color: context.colors.borderStrong,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            _searchQuery.isNotEmpty ? 'No matches found' : 'No students found!',
            style: TextStyle(
              color: context.colors.textSubtle,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList({
    required List<Student> students,
    required String batchName,
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int startIndex,
    required int endIndex,
    required bool isDark,
    required ValueChanged<int> onPageChanged,
  }) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.md,
              Spacing.lg,
              0,
            ),
            child: Row(
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
                  'Found ${students.length} Students',
                  style: TextStyle(
                    fontWeight: .w700,
                    fontSize: FontSizeToken.sm,
                    color: context.colors.text,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16, 8, 16, totalPages > 1 ? 0 : 8),
              itemCount: totalPages > 1 ? students.length + 1 : students.length,
              separatorBuilder: (_, index) {
                if (index == students.length - 1 && totalPages > 1) {
                  return const SizedBox(height: 0);
                }
                return const SizedBox(height: Spacing.md);
              },
              itemBuilder: (_, index) {
                if (totalPages > 1 && index == students.length) {
                  return _buildPagination(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    totalItems: totalItems,
                    startIndex: startIndex,
                    endIndex: endIndex,
                    isDark: isDark,
                    onPageChanged: onPageChanged,
                  );
                }
                return StudentCard(
                  studentModel: students[index],
                  selectedBatch: batchName,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Sort students by roll number
  /// `ascending: true` → oldest first (2501, 2502...) — used in batch tabs
  /// `ascending: false` → newest first (25040, 25039...) — used in "All" tab
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

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int startIndex,
    required int endIndex,
    required bool isDark,
    required ValueChanged<int> onPageChanged,
  }) {
    // Generate page numbers to display
    List<int> pageNumbers = [];
    if (totalPages <= 5) {
      pageNumbers = List.generate(totalPages, (i) => i + 1);
    } else {
      if (currentPage <= 3) {
        pageNumbers = [1, 2, 3, 4, 5];
      } else if (currentPage >= totalPages - 2) {
        pageNumbers = [
          totalPages - 4,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages,
        ];
      } else {
        pageNumbers = [
          currentPage - 2,
          currentPage - 1,
          currentPage,
          currentPage + 1,
          currentPage + 2,
        ];
      }
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
                isDark: isDark,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: Spacing.xs),
              ...pageNumbers.map(
                (page) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xxs),
                  child: _buildPageNumberButton(
                    page: page,
                    isSelected: page == currentPage,
                    isDark: isDark,
                    onTap: () => onPageChanged(page),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              _buildPageButton(
                icon: Icons.chevron_right,
                isEnabled: currentPage < totalPages,
                isDark: isDark,
                onTap: () => onPageChanged(currentPage + 1),
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
    required bool isDark,
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
          color: isEnabled ? (context.colors.text) : context.colors.textSubtle,
        ),
      ),
    );
  }

  Widget _buildPageNumberButton({
    required int page,
    required bool isSelected,
    required bool isDark,
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
                  : (context.colors.text),
            ),
          ),
        ),
      ),
    );
  }
}
