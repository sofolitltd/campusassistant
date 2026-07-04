import 'package:campusassistant/features/batch/domain/entities/batch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/widgets/pill_tab_bar.dart';
import '/core/widgets/floating_search_bar.dart';
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
        if (_tabController == null || _tabController!.length != displayBatches.length) {
          _tabController?.dispose();
          _tabController = TabController(length: displayBatches.length, vsync: this);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('All Students'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Tabs stay at the top
                  PillTabBar(
                    controller: _tabController!,
                    labels: displayBatches.map((b) => b.name).toList(),
                    scrollable: true,
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
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

                            return Column(
                              children: [
                                // Count display (Batch-specific)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
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
                                        'Found ${filteredStudents.length} Students',
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
                                // Student list
                                Expanded(
                                  child: filteredStudents.isEmpty
                                      ? const Center(child: Text('No students found!'))
                                      : ListView.separated(
                                          padding: const EdgeInsets.fromLTRB(
                                            16,
                                            8,
                                            16,
                                            100, // Extra padding for floating bar
                                          ),
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
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text(e.toString())),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Premium Floating Bottom Search Bar
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: FloatingSearchBar(
                  hintText: 'Search by name, ID, or hall...',
                  onChanged: (value) => setState(() => _searchQuery = value),
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


