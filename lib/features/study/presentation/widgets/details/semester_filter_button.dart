import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/study/levels/domain/entities/semester.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/features/study/widgets/batch_tile.dart';

class SemesterFilterButton extends ConsumerWidget {
  final SelectedSemester? selectedSemester;
  final List<Semester> semesters;
  final bool redBg;

  const SemesterFilterButton({
    super.key,
    required this.selectedSemester,
    required this.semesters,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showSemesterSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: redBg ? Colors.white.withValues(alpha: 0.15) : null,
          border: Border.all(
            color: redBg
                ? Colors.white.withValues(alpha: 0.4)
                : isDark
                ? Colors.white24
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.graduationCap,
              size: 14,
              color: redBg ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              selectedSemester?.name ?? 'Level',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: redBg ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            if (selectedSemester != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  ref.read(selectedSemesterNotifierProvider.notifier).clear();
                },
                child: Icon(
                  LucideIcons.circleX,
                  size: 12,
                  color: redBg ? Colors.white70 : Colors.red.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSemesterSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Level',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        LucideIcons.x,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    BatchTile(
                      title: 'All Levels',
                      isSelected: selectedSemester == null,
                      onTap: () {
                        ref
                            .read(selectedSemesterNotifierProvider.notifier)
                            .clear();
                        Navigator.pop(context);
                      },
                    ),
                    ...semesters.map(
                      (semester) => BatchTile(
                        title: semester.name,
                        isSelected: selectedSemester?.id == semester.id,
                        onTap: () {
                          ref
                              .read(selectedSemesterNotifierProvider.notifier)
                              .setFromSemester(semester);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
