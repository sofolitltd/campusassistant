import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/widgets/inline_search_bar.dart';
import '/features/student/presentation/providers/student_provider.dart';
import 'student_card.dart';

class BatchStudentsPage extends ConsumerStatefulWidget {
  const BatchStudentsPage({super.key, required this.batch});
  final String batch;

  @override
  ConsumerState<BatchStudentsPage> createState() => _BatchStudentsPageState();
}

class _BatchStudentsPageState extends ConsumerState<BatchStudentsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsByBatchProvider(widget.batch));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.batch),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () => context.pushNamed('allStudents'),
              child: const Text("All Students"),
            ),
          ),
        ],
      ),
      body: studentsAsync.when(
        data: (students) {
          final filteredStudents = students.where((s) {
            final query = _searchQuery.toLowerCase();
            return s.name.toLowerCase().contains(query) ||
                s.studentId.toLowerCase().contains(query) ||
                s.hall.toLowerCase().contains(query) ||
                s.blood.toLowerCase().contains(query);
          }).toList();

          return Column(
            children: [
              // Search bar + total count
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InlineSearchBar(
                      hintText: 'Search by name, id, hall or blood',
                      onChanged: (value) => setState(() => _searchQuery = value),
                      dense: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total students: ${filteredStudents.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Student list
              Expanded(
                child: filteredStudents.isEmpty
                    ? const Center(child: Text('No students found!'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: filteredStudents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => StudentCard(
                          studentModel: filteredStudents[index],
                          selectedBatch: widget.batch,
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
