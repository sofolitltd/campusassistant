import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/syllabus/presentation/providers/syllabus_provider.dart';
import '/features/study/shortcut/syllabus/syllabus_card.dart';

class FullSyllabusPage extends ConsumerWidget {
  const FullSyllabusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syllabusAsync = ref.watch(syllabusPaginationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Full Syllabus'), centerTitle: true),
      body: syllabusAsync.when(
        data: (state) {
          if (state.syllabi.isEmpty) {
            return const Center(child: Text('No syllabi available'));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: state.syllabi.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) =>
                SyllabusCard(syllabus: state.syllabi[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
