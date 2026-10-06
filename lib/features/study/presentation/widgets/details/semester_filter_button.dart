import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/study/levels/domain/entities/semester.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/features/study/widgets/batch_tile.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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

    return GestureDetector(
      onTap: () => _showSemesterSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: redBg ? context.colors.surface.withValues(alpha: 0.15) : null,
          border: Border.all(
            color: redBg
                ? context.colors.onPrimary.withValues(alpha: 0.4)
                : context.colors.borderStrong,
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.graduationCap,
              size: 14,
              color: redBg
                  ? context.colors.onPrimary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: Spacing.sm),
            Text(
              selectedSemester?.name ?? 'Level',
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .w500,
                color: redBg
                    ? context.colors.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: redBg
                  ? context.colors.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  void _showSemesterSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.only(top: Spacing.md),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.borderStrong,
                    borderRadius: BorderRadius.circular(RadiusToken.xs),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      'Select Level',
                      style: TextStyle(
                        fontSize: FontSizeToken.xl,
                        fontWeight: .bold,
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
              const SizedBox(height: Spacing.lg),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
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
