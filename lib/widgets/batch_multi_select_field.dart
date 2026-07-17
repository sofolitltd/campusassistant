import 'package:flutter/material.dart';
import '/features/batch/domain/entities/batch.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class BatchMultiSelectField extends StatelessWidget {
  final List<Batch> batches;
  final List<String> selectedBatchIds;
  final Function(List<String>) onMappingChanged;
  final String label;

  const BatchMultiSelectField({
    super.key,
    required this.batches,
    required this.selectedBatchIds,
    required this.onMappingChanged,
    this.label = 'Target Batches',
  });

  void _showSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _BatchSelectorSheet(
          batches: batches,
          initialSelectedIds: selectedBatchIds,
          onSelected: onMappingChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedNames = batches
        .where((b) => selectedBatchIds.contains(b.id))
        .map((b) => b.name)
        .join(', ');

    return InkWell(
      onTap: () => _showSelector(context),
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          // prefixIcon: const Icon(Icons.groups),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          selectedNames.isEmpty ? 'Select Batches' : selectedNames,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: selectedNames.isEmpty ? Colors.grey : null),
        ),
      ),
    );
  }
}

class _BatchSelectorSheet extends StatefulWidget {
  final List<Batch> batches;
  final List<String> initialSelectedIds;
  final Function(List<String>) onSelected;

  const _BatchSelectorSheet({
    required this.batches,
    required this.initialSelectedIds,
    required this.onSelected,
  });

  @override
  State<_BatchSelectorSheet> createState() => _BatchSelectorSheetState();
}

class _BatchSelectorSheetState extends State<_BatchSelectorSheet> {
  late List<String> _selectedIds;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.initialSelectedIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBatches = widget.batches
        .where((b) => b.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Batches (${_selectedIds.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search batches...',
              prefixIcon: Padding(
                padding: .only(left: 8),
                child: const Icon(Icons.search, size: 20),
              ),

              prefixIconConstraints: const BoxConstraints(
                minWidth: 36, // Further reduced from 40
                minHeight: 48,
              ),
              fillColor: Colors.grey.shade100,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.clear),
                    )
                  : null,
              contentPadding: .only(left: 16),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          // const SizedBox(height: 8),
          // Selection Controls Row
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    for (var b in filteredBatches) {
                      if (!_selectedIds.contains(b.id)) {
                        _selectedIds.add(b.id);
                      }
                    }
                  });
                },
                child: const Text('Select all'),
              ),
              const Spacer(),
              if (_selectedIds.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _selectedIds.clear()),
                  child: const Text(
                    'Clear all',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredBatches.length,
              itemBuilder: (context, index) {
                final batch = filteredBatches[index];
                final isSelected = _selectedIds.contains(batch.id);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIds.remove(batch.id);
                      } else {
                        _selectedIds.add(batch.id);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedIds.add(batch.id);
                                } else {
                                  _selectedIds.remove(batch.id);
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            batch.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIds.isEmpty
                    ? Colors.grey
                    : Colors.black,
              ),
              onPressed: _selectedIds.isEmpty
                  ? null
                  : () {
                      widget.onSelected(_selectedIds);
                      Navigator.pop(context);
                    },
              child: _selectedIds.isEmpty
                  ? const Text('Add Batches')
                  : Text('Update Batches'),
            ),
          ),
        ],
      ),
    );
  }
}
