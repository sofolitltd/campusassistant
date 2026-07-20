import '/features/batch/domain/entities/batch.dart';
import '/features/student/domain/entities/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/student/presentation/screens/student_card.dart';
import '/features/student/presentation/providers/student_provider.dart';

class AllStudentsPage extends ConsumerStatefulWidget {
  const AllStudentsPage({super.key});

  @override
  ConsumerState<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends ConsumerState<AllStudentsPage>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  TabController? _tabController;
  static const int _pageSize = 20;
  final Map<String, int> _currentPage = {};

  @override
  void dispose() {
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
          searchHint: 'Search by name, ID, or hall...',
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
      ),
    );

    return paginatedAsync.when(
      data: (paginated) {
        final totalCount = paginated.total;
        final students = paginated.students;

        final displayedStudents = _searchQuery.isEmpty
            ? _sortByRollNumber(students)
            : _sortByRollNumber(
                students.where((s) {
                  final query = _searchQuery.toLowerCase();
                  return s.name.toLowerCase().contains(query) ||
                      s.studentId.toLowerCase().contains(query) ||
                      s.hall.toLowerCase().contains(query) ||
                      s.batch.toLowerCase().contains(query) ||
                      s.session.toLowerCase().contains(query) ||
                      s.blood.toLowerCase().contains(query);
                }).toList(),
              );

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
      ),
    );

    return paginatedAsync.when(
      data: (paginated) {
        final totalCount = paginated.total;
        final students = paginated.students;

        // Client-side search within current page (or fetch all for search)
        final displayedStudents = _searchQuery.isEmpty
            ? _sortByRollNumber(students, ascending: true)
            : _sortByRollNumber(
                students.where((s) {
                  final query = _searchQuery.toLowerCase();
                  return s.name.toLowerCase().contains(query) ||
                      s.studentId.toLowerCase().contains(query) ||
                      s.hall.toLowerCase().contains(query) ||
                      s.batch.toLowerCase().contains(query) ||
                      s.session.toLowerCase().contains(query) ||
                      s.blood.toLowerCase().contains(query);
                }).toList(),
              );

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? LucideIcons.searchX : LucideIcons.users,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isNotEmpty ? 'No matches found' : 'No students found!',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blue.shade400 : Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Found ${students.length} Students',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 8, 16, totalPages > 1 ? 0 : 8),
            itemCount: totalPages > 1 ? students.length + 1 : students.length,
            separatorBuilder: (_, index) {
              if (index == students.length - 1 && totalPages > 1) {
                return const SizedBox(height: 0);
              }
              return const SizedBox(height: 12);
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Showing $startIndex-$endIndex of $totalItems',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPageButton(
                icon: Icons.chevron_left,
                isEnabled: currentPage > 1,
                isDark: isDark,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 4),
              ...pageNumbers.map(
                (page) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildPageNumberButton(
                    page: page,
                    isSelected: page == currentPage,
                    isDark: isDark,
                    onTap: () => onPageChanged(page),
                  ),
                ),
              ),
              const SizedBox(width: 4),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled
              ? (isDark ? Colors.white : Colors.black87)
              : Colors.grey.shade400,
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.blue.shade700 : Colors.blue.shade600)
              : (isDark ? Colors.grey.shade800 : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.blue.shade600
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
