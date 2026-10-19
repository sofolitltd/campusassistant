import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/inline_search_bar.dart';
import '/features/study/widgets/batch_tile.dart';

/// Same layout as the study page's batch picker ([BatchDropdown]): title +
/// close, search bar, then a two-column grid with an "All" tile first.
void showFilterPickerSheet(
  BuildContext context, {
  required String title,
  required String searchHint,
  required String allLabel,
  required List<String> options,
  required String? selected,
  required ValueChanged<String?> onSelected,
}) {
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
          final q = searchText.trim().toLowerCase();
          final filtered = q.isEmpty
              ? options
              : options.where((o) => o.toLowerCase().contains(q)).toList();

          void pick(String? value) {
            onSelected(value);
            Navigator.pop(context);
          }

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
                        title,
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
                    hintText: searchHint,
                    onChanged: (v) => setState(() => searchText = v),
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Expanded(
                  child: filtered.isEmpty && q.isNotEmpty
                      ? Center(
                          child: Text(
                            'No matches',
                            style: TextStyle(color: context.colors.textMuted),
                          ),
                        )
                      : GridView.count(
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
                            if (q.isEmpty)
                              BatchTile(
                                grid: true,
                                title: allLabel,
                                isSelected: selected == null,
                                onTap: () => pick(null),
                              ),
                            ...filtered.map(
                              (o) => BatchTile(
                                grid: true,
                                title: o,
                                isSelected: selected == o,
                                onTap: () => pick(o),
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
