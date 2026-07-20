import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import 'batch_tile.dart';

class BatchDropdown extends ConsumerWidget {
  final bool redBg;
  const BatchDropdown({super.key, this.redBg = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchesAsync = ref.watch(batchProviderStudy);
    final currentBatch = ref.watch(resolvedBatchProvider);
    final theme = Theme.of(context);

    final textColor = redBg ? Colors.white : theme.colorScheme.onSurface;
    final borderColor = redBg
        ? Colors.white.withValues(alpha: 0.4)
        : (theme.brightness == Brightness.dark
              ? Colors.white24
              : Colors.grey.shade300);

    return batchesAsync.when(
      data: (batches) {
        if (batches.isEmpty) return const SizedBox();
        final batch = currentBatch;

        return GestureDetector(
          onTap: () => _showBatchBottomSheet(context, ref, batches, batch),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: redBg ? Colors.white.withValues(alpha: 0.15) : null,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.users, size: 14, color: textColor),
                const SizedBox(width: 6),
                Text(
                  batch?.name ?? 'All Batches',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 8),
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
          child: CupertinoActivityIndicator(color: redBg ? Colors.white : null),
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
    final isDark = theme.brightness == Brightness.dark;
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          'Select Batch',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchText = v),
                        decoration: InputDecoration(
                          hintText: 'Search batch...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            size: 18,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        if (searchText.isEmpty)
                          BatchTile(
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
