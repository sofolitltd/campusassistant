import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// An inline search text field with a search icon and clear button.
///
/// Designed for use inside scrollable content (not floating).
///
/// ```dart
/// InlineSearchBar(
///   hintText: 'Search by name, id, hall or blood',
///   onChanged: (query) => setState(() => _searchQuery = query),
///   dense: true,
/// )
/// ```
class InlineSearchBar extends StatefulWidget {
  const InlineSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.dense = false,
    this.debounceMilliseconds = 0,
  });

  /// Placeholder text shown inside the field.
  final String hintText;

  /// Called with the current query text after each change (or after debounce).
  final ValueChanged<String> onChanged;

  /// When true renders a compact version with smaller padding.
  final bool dense;

  /// Debounce delay in milliseconds. 0 = fire immediately on each keystroke.
  final int debounceMilliseconds;

  @override
  State<InlineSearchBar> createState() => _InlineSearchBarState();
}

class _InlineSearchBarState extends State<InlineSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _hasText = value.isNotEmpty);
    if (widget.debounceMilliseconds > 0) {
      _debounce?.cancel();
      _debounce = Timer(
        Duration(milliseconds: widget.debounceMilliseconds),
        () => widget.onChanged(value),
      );
    } else {
      widget.onChanged(value);
    }
  }

  void _onClear() {
    _controller.clear();
    setState(() => _hasText = false);
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      style: TextStyle(
        fontSize: widget.dense ? 13 : 14,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        isDense: widget.dense,
        visualDensity: widget.dense
            ? VisualDensity.compact
            : VisualDensity.standard,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: widget.dense ? 12 : 13,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(
            LucideIcons.search,
            size: widget.dense ? 14 : 16,
            color: cs.onSurfaceVariant,
          ),
        ),
        prefixIconConstraints: widget.dense
            ? const BoxConstraints(minWidth: 32)
            : const BoxConstraints(minWidth: 40),
        suffixIcon: _hasText
            ? GestureDetector(
                onTap: _onClear,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    widget.dense ? Icons.clear : LucideIcons.circleX,
                    size: widget.dense ? 14 : 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.dense ? 6 : 8),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.dense ? 6 : 8),
          borderSide: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
