import 'package:campusassistant/features/batch/domain/entities/batch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/red_header_layout.dart';
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

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
        // Sort batches from latest to oldest
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

        return RedHeaderLayout(
          title: 'All Students',
          searchHint: 'Search by name, ID, or hall...',
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: SectionTabBar(
                  controller: _tabController!,
                  tabs: displayBatches
                      .map((b) => Tab(text: b.name))
                      .toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController!,
                  children: displayBatches.map<Widget>((batch) {
              final studentsAsync = batch.id == 'all'
                  ? ref.watch(allStudentsProvider(
                      universityId: batch.universityId,
                      departmentId: batch.departmentId,
                    ))
                  : ref.watch(studentsByBatchProvider(batch.id));

              return studentsAsync.when(
                data: (students) {
                  // Filter students by search query
                  final filteredStudents = students.where((s) {
                    final query = _searchQuery.toLowerCase();
                    return s.name.toLowerCase().contains(query) ||
                        s.studentId.toLowerCase().contains(query) ||
                        s.hall.toLowerCase().contains(query) ||
                        s.batch.toLowerCase().contains(query) ||
                        s.session.toLowerCase().contains(query) ||
                        s.blood.toLowerCase().contains(query);
                  }).toList();

                  if (filteredStudents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isNotEmpty
                                ? LucideIcons.searchX
                                : LucideIcons.users,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No matches found'
                                : 'No students found!',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

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
                                  color: isDark
                                      ? Colors.blue.shade400
                                      : Colors.blue.shade700,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Found ${filteredStudents.length} Students',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: filteredStudents.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, index) => StudentCard(
                            studentModel: filteredStudents[index],
                            selectedBatch: batch.name,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text(e.toString())),
              );
            }).toList(),
                ),
              ),
            ],
          ),
        );
      },

      loading: () => Scaffold(
        appBar: AppBar(title: const Text('All Students'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('All Students'), centerTitle: true),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
