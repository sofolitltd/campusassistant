import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/features/student/presentation/providers/student_provider.dart';
import 'student_card.dart';

class BatchStudentsPage extends ConsumerStatefulWidget {
  const BatchStudentsPage({super.key, required this.batch});
  final String batch;

  @override
  ConsumerState<BatchStudentsPage> createState() => _BatchStudentsPageState();
}

class _BatchStudentsPageState extends ConsumerState<BatchStudentsPage> {
  final TextEditingController _searchController = TextEditingController();
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
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        isDense: true,
                        visualDensity: VisualDensity.compact,
                        hintText: 'Search by name, id, hall or blood',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                child: const Icon(Icons.clear, size: 16),
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
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
