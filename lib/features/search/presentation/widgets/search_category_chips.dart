import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/widgets/app_choice_chip.dart';
import '../providers/search_provider.dart';
import '/core/theme/tokens/app_spacing.dart';

const _categories = <(String key, String label)>[
  ('all', 'All'),
  ('note', 'Notes'),
  ('book', 'Books'),
  ('question', 'Questions'),
  ('syllabus', 'Syllabus'),
  ('video', 'Video'),
  ('notice', 'Notices'),
  ('course', 'Courses'),
  ('club', 'Clubs'),
  ('association', 'Associations'),
  ('teacher', 'Teachers'),
  ('staff', 'Staff'),
  ('marketplace', 'Marketplace'),
  ('lost_found', 'Lost & Found'),
  ('career', 'Career'),
];

class SearchCategoryChips extends ConsumerWidget {
  const SearchCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(searchCategoryProvider);

    return SizedBox(
      height: AppChoiceChip.rowHeight,
      child: ListView.separated(
        scrollDirection: .horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          final (key, label) = _categories[index];
          return AppChoiceChip(
            label: label,
            selected: selected == key,
            onTap: () => ref.read(searchCategoryProvider.notifier).state = key,
          );
        },
      ),
    );
  }
}
