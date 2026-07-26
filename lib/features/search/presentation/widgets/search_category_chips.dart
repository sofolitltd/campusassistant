import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/app_colors.dart';
import '../providers/search_provider.dart';

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
    final primaryColor = Theme.of(context).appColors.primaryColor;

    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (key, label) = _categories[index];
          final isSelected = selected == key;
          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) =>
                ref.read(searchCategoryProvider.notifier).state = key,
            selectedColor: primaryColor,
            labelStyle: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : null,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
