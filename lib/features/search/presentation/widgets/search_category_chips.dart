import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/app_colors.dart';
import '../providers/search_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
    final primaryColor = context.colors.primary;

    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: .horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
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
              fontSize: FontSizeToken.sm,
              color: isSelected ? context.colors.onPrimary : null,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: 0,
            ),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
