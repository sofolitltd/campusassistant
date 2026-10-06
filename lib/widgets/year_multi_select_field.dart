import '/core/theme/tokens/app_radius.dart';
import 'package:flutter/material.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class YearMultiSelectField extends StatelessWidget {
  final List<String> years;
  final List<String> selectedYears;
  final Function(List<String>) onSelected;
  final String label;

  const YearMultiSelectField({
    super.key,
    required this.years,
    required this.selectedYears,
    required this.onSelected,
    this.label = 'Select Years',
  });

  void _showSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _YearSelectorSheet(
          years: years,
          initialSelected: selectedYears,
          onSelected: onSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedText = selectedYears.join(', ');

    return InkWell(
      onTap: () => _showSelector(context),
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
        ),
        child: Text(
          selectedText.isEmpty ? 'Select Academic Years' : selectedText,
          maxLines: 1,
          overflow: .ellipsis,
          style: TextStyle(
            color: selectedText.isEmpty ? context.colors.textSubtle : null,
          ),
        ),
      ),
    );
  }
}

class _YearSelectorSheet extends StatefulWidget {
  final List<String> years;
  final List<String> initialSelected;
  final Function(List<String>) onSelected;

  const _YearSelectorSheet({
    required this.years,
    required this.initialSelected,
    required this.onSelected,
  });

  @override
  State<_YearSelectorSheet> createState() => _YearSelectorSheetState();
}

class _YearSelectorSheetState extends State<_YearSelectorSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: Spacing.lg),
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(RadiusToken.xs),
            ),
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Select Years (${_selected.length})',
                style: const TextStyle(
                  fontWeight: .bold,
                  fontSize: FontSizeToken.xl,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.years.length,
              itemBuilder: (context, index) {
                final year = widget.years[index];
                final isSelected = _selected.contains(year);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(year);
                      } else {
                        _selected.add(year);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primarySubtle
                          : context.colors.surface,
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.border,
                      ),
                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                    ),
                    child: Text(
                      year,
                      style: TextStyle(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.text,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Spacing.lg),
          SizedBox(
            width: double.infinity,
            height: ControlToken.height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
              ),
              onPressed: () {
                widget.onSelected(_selected);
                Navigator.pop(context);
              },
              child: const Text('Confirm selection'),
            ),
          ),
        ],
      ),
    );
  }
}
