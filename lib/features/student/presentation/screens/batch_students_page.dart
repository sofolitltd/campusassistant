import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
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

    return CustomHeaderLayout(
      title: widget.batch,
      searchAtBottom: true,
      searchHint: 'Search by name, id, hall or blood',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Spacing.lg),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: context.colors.onPrimary,
            ),
            onPressed: () => context.pushNamed('allStudents'),
            child: const Text('All Students'),
          ),
        ),
      ],
      body: studentsAsync.when(
        data: (students) {
          final query = _searchQuery.trim().toLowerCase();
          final filteredStudents = students.where((s) {
            return s.name.toLowerCase().contains(query) ||
                s.studentId.toLowerCase().contains(query) ||
                s.hall.toLowerCase().contains(query) ||
                s.blood.toLowerCase().contains(query);
          }).toList();

          return Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.sm,
                ),
                child: Text(
                  'Students (${filteredStudents.length})',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
                ),
              ),
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
    );
  }
}
