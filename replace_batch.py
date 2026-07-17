import re

file_path = "lib//features//study/semester/presentation/screens/study_page.dart"
with open(file_path, "r") as f:
    content = f.read()

# Replace the row
row_pattern = """                                  // Title + toggle buttons
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 0, 16, 4),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Headline(title: 'Semesters/Years')),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.list_alt,
                                                color: !isGridView
                                                    ? theme.colorScheme.onSurface
                                                    : theme.colorScheme.onSurface.withValues(
                                                        alpha: 0.4,
                                                      ),
                                              ),
                                              onPressed: () => setState(() => isGridView = false),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.grid_view_outlined,
                                                color: isGridView
                                                    ? theme.colorScheme.onSurface
                                                    : theme.colorScheme.onSurface.withValues(
                                                        alpha: 0.4,
                                                      ),
                                              ),
                                              onPressed: () => setState(() => isGridView = true),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Batch dropdown
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _BatchDropdown(
                                          batchesAsync: batchesAsync,
                                          currentBatch: currentBatch,
                                          theme: theme,
                                        ),
                                      ],
                                    ),
                                  ),"""

new_row = """                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.list_alt,
                                                color: !isGridView
                                                    ? theme.colorScheme.onSurface
                                                    : theme.colorScheme.onSurface.withValues(
                                                        alpha: 0.4,
                                                      ),
                                              ),
                                              onPressed: () => setState(() => isGridView = false),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.grid_view_outlined,
                                                color: isGridView
                                                    ? theme.colorScheme.onSurface
                                                    : theme.colorScheme.onSurface.withValues(
                                                        alpha: 0.4,
                                                      ),
                                              ),
                                              onPressed: () => setState(() => isGridView = true),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        _BatchDropdown(
                                          batchesAsync: batchesAsync,
                                          currentBatch: currentBatch,
                                          theme: theme,
                                        ),
                                      ],
                                    ),
                                  ),"""

if row_pattern in content:
    content = content.replace(row_pattern, new_row)
else:
    print("Could not find row pattern")

new_batch_dropdown = """class _BatchDropdown extends ConsumerStatefulWidget {
  final AsyncValue<List<Batch>> batchesAsync;
  final Batch? currentBatch;
  final ThemeData theme;

  const _BatchDropdown({
    required this.batchesAsync,
    required this.currentBatch,
    required this.theme,
  });

  @override
  ConsumerState<_BatchDropdown> createState() => _BatchDropdownState();
}

class _BatchDropdownState extends ConsumerState<_BatchDropdown> {
  void _showBatchModal(BuildContext context, List<Batch> batches) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _BatchModalSheet(
        batches: batches,
        currentBatch: widget.currentBatch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.batchesAsync.when(
      data: (batches) {
        if (batches.isEmpty) return const Text("No batches");
        final batch = widget.currentBatch;
        
        return InkWell(
          onTap: () => _showBatchModal(context, batches),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: widget.theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  batch?.name ?? 'All Batches',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 110,
        height: 36,
        child: Center(child: CupertinoActivityIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => const Text("Error"),
    );
  }
}

class _BatchModalSheet extends ConsumerStatefulWidget {
  final List<Batch> batches;
  final Batch? currentBatch;

  const _BatchModalSheet({required this.batches, required this.currentBatch});

  @override
  ConsumerState<_BatchModalSheet> createState() => _BatchModalSheetState();
}

class _BatchModalSheetState extends ConsumerState<_BatchModalSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _filterText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredBatches = _filterText.isEmpty
        ? widget.batches
        : widget.batches
            .where((b) => b.name.toLowerCase().contains(_filterText.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Select Batch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search batch...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                    suffixIcon: _filterText.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _filterText = '');
                            },
                            child: Icon(
                              LucideIcons.circleX,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (v) => setState(() => _filterText = v),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredBatches.length + (_filterText.isEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_filterText.isEmpty && index == 0) {
                    final isSelected = widget.currentBatch == null;
                    return ListTile(
                      title: const Text('All Batches'),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
                      onTap: () {
                        ref.read(selectedBatchNotifierProvider.notifier).setAll();
                        Navigator.pop(context);
                      },
                    );
                  }

                  final batchIndex = _filterText.isEmpty ? index - 1 : index;
                  final batch = filteredBatches[batchIndex];
                  final isSelected = widget.currentBatch?.id == batch.id;
                  
                  return ListTile(
                    title: Text(batch.name),
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
                    onTap: () {
                      ref.read(selectedBatchNotifierProvider.notifier).setSelectedBatch(batch);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
"""

content = re.sub(r"class _BatchDropdown extends ConsumerWidget \{.*", new_batch_dropdown, content, flags=re.DOTALL)

with open(file_path, "w") as f:
    f.write(content)

print("Done")
