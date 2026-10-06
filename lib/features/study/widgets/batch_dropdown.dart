import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import 'batch_tile.dart';
import '/core/widgets/inline_search_bar.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class BatchDropdown extends ConsumerWidget {
  final bool redBg;

  /// Fixed height, for rows where it has to line up with neighbouring controls.
  final double? height;
  const BatchDropdown({super.key, this.redBg = false, this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchesAsync = ref.watch(batchProviderStudy);
    final currentBatch = ref.watch(resolvedBatchProvider);
    final theme = Theme.of(context);

    final textColor = redBg
        ? context.colors.onPrimary
        : theme.colorScheme.onSurface;
    final borderColor = redBg
        ? context.colors.onPrimary.withValues(alpha: 0.4)
        : (theme.brightness == Brightness.dark
              ? context.colors.borderStrong
              : context.colors.borderStrong);

    return batchesAsync.when(
      data: (batches) {
        if (batches.isEmpty) return const SizedBox();
        final batch = currentBatch;

        return GestureDetector(
          onTap: () => _showBatchBottomSheet(context, ref, batches, batch),
          child: Container(
            height: height,
            alignment: height == null ? null : Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: redBg
                  ? context.colors.surface.withValues(alpha: 0.15)
                  : context.colors.surface,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(LucideIcons.users, size: 14, color: textColor),
                const SizedBox(width: Spacing.sm),
                Text(
                  batch?.name ?? 'All Batches',
                  style: TextStyle(
                    fontSize: FontSizeToken.md,
                    fontWeight: .w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(Icons.keyboard_arrow_down, size: 16, color: textColor),
              ],
            ),
          ),
        );
      },
      loading: () => SizedBox(
        width: 100,
        height: 32,
        child: Center(
          child: CupertinoActivityIndicator(
            color: redBg ? context.colors.onPrimary : null,
          ),
        ),
      ),
      error: (_, _) => const SizedBox(),
    );
  }

  void _showBatchBottomSheet(
    BuildContext context,
    WidgetRef ref,
    List<Batch> batches,
    Batch? currentBatch,
  ) {
    final theme = Theme.of(context);
    String searchText = '';

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
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredBatches = searchText.isEmpty
                ? batches
                : batches
                      .where(
                        (b) => b.name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                          'Select Batch',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: InlineSearchBar(
                      hintText: 'Search batch...',
                      onChanged: (v) => setState(() => searchText = v),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: Spacing.sm,
                      crossAxisSpacing: Spacing.sm,
                      childAspectRatio: 4.2,
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.xl,
                        0,
                        Spacing.xl,
                        Spacing.xl,
                      ),
                      children: [
                        if (searchText.isEmpty)
                          BatchTile(
                            grid: true,
                            title: 'All Batches',
                            isSelected: currentBatch == null,
                            onTap: () {
                              ref
                                  .read(selectedBatchNotifierProvider.notifier)
                                  .setAll();
                              Navigator.pop(context);
                            },
                          ),
                        ...filteredBatches.map(
                          (b) => BatchTile(
                            grid: true,
                            title: b.name,
                            isSelected: currentBatch?.id == b.id,
                            onTap: () {
                              ref
                                  .read(selectedBatchNotifierProvider.notifier)
                                  .setSelectedBatch(b);
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
      },
    );
  }
}
