import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/widgets/inline_search_bar.dart';
import '/features/student/presentation/providers/student_provider.dart';
import 'student_card.dart';
import '/core/theme/tokens/app_spacing.dart';

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

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.batch),
            titleSpacing: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.md,
                  Spacing.lg,
                  Spacing.md,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
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
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.md,
                      Spacing.md,
                      Spacing.md,
                      Spacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        InlineSearchBar(
                          hintText: 'Search by name, id, hall or blood',
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          dense: true,
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          'Total students: ${filteredStudents.length}',
                          style: const TextStyle(fontWeight: .bold),
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
                              Spacing.lg,
                              Spacing.sm,
                              Spacing.lg,
                              Spacing.lg,
                            ),
                            itemCount: filteredStudents.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: Spacing.md),
                            itemBuilder: (_, index) => StudentCard(
                              studentModel: filteredStudents[index],
                              selectedBatch: widget.batch,
                            ),
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
}
