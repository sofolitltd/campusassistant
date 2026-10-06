import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// A premium frosted-glass floating search bar with clear button.
///
/// Features a blurred backdrop effect, search icon prefix, dismiss (×) button,
/// and optional trailing widget (e.g. a dropdown or filter button).
///
/// ```dart
/// FloatingSearchBar(
///   hintText: 'Search by name, dept or designation...',
///   onChanged: (query) => ref.read(mySearchProvider.notifier).update(query),
///   trailing: _BloodGroupDropdown(...),
/// )
/// ```
class FloatingSearchBar extends StatefulWidget {
  const FloatingSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.trailing,
    this.debounceMilliseconds = 0,
  });

  /// Placeholder text shown inside the field.
  final String hintText;

  /// Called with the current query text after each change (or after debounce).
  final ValueChanged<String> onChanged;

  /// Optional widget placed after the search field (e.g. filter button/dropdown).
  final Widget? trailing;

  /// Debounce delay in milliseconds. 0 = fire immediately on each keystroke.
  final int debounceMilliseconds;

  @override
  State<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar> {
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
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusToken.xxl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(RadiusToken.xxl),
            border: Border.all(color: colors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: .center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: _onSearchChanged,
                  style: TextStyle(
                    fontSize: FontSizeToken.md,
                    color: colors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: colors.textSubtle,
                      fontSize: FontSizeToken.sm,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.md,
                        right: Spacing.sm,
                      ),
                      child: Icon(
                        LucideIcons.search,
                        size: 14,
                        color: colors.textMuted,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 32),
                    suffixIcon: _hasText
                        ? GestureDetector(
                            onTap: _onClear,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                              ),
                              child: Icon(
                                LucideIcons.circleX,
                                size: 14,
                                color: colors.textSubtle,
                              ),
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(maxHeight: 28),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: Spacing.md,
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null) ...[
                Container(height: 18, width: 1, color: colors.border),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
