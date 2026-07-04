import 'dart:ui';
import 'package:campusassistant/features/batch/domain/entities/batch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TabController? _tabController;

  @override
  void dispose() {
    _searchController.dispose();
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
                  const SizedBox(height: 12),
                  // Tabs stay at the top
                  _buildSmoothTabControl(displayBatches, isDark),
                  const SizedBox(height: 4),

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark 
                            ? Colors.black.withValues(alpha: 0.7) 
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search by name, ID, or hall...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 14, right: 10),
                            child: Icon(LucideIcons.search, size: 16, color: Colors.grey.shade400),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 40),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Icon(LucideIcons.circleX, size: 16, color: Colors.grey.shade400),
                                  ),
                                )
                              : null,
                          suffixIconConstraints: const BoxConstraints(maxHeight: 32),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                    ),
                  ),
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

  Widget _buildSmoothTabControl(List batches, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: AnimatedBuilder(
          animation: _tabController!.animation!,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(batches.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: index == batches.length - 1 ? 0 : 4),
                  child: _buildSmoothTab(batches[index].name, index, isDark),
                );
              }),
            );
          },
        ),
      ),
    );
  }


  Widget _buildSmoothTab(String label, int index, bool isDark) {
    final double animationValue = _tabController!.animation!.value;
    
    // Calculate progress for each tab based on its index
    final double distance = (index - animationValue).abs();
    final double progress = (1.0 - distance).clamp(0.0, 1.0);

    final Color activeColor = isDark ? Colors.white : Colors.black;
    final Color inactiveColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final Color activeTextColor = isDark ? Colors.black : Colors.white;
    final Color inactiveTextColor = Colors.grey.shade600;

    return GestureDetector(
      onTap: () => _tabController!.animateTo(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 30,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color.lerp(
              isDark ? Colors.white24 : Colors.grey.shade300,
              isDark ? Colors.white24 : Colors.grey.shade300,
              progress,
            )!,
            width: 1,
          ),
          boxShadow: progress > 0.5
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1 * progress),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Color.lerp(inactiveTextColor, activeTextColor, progress),
              fontWeight: progress > 0.5 ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }


}

