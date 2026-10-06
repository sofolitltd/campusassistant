import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/widgets/glass_surface.dart';
import '/core/widgets/search_clear_suffix.dart';

/// Bottom-docked search field in the iOS-26 style: a [GlassSurface] capsule,
/// optionally followed by a glass circle [action], floating above the safe
/// area (and the keyboard, since the page resizes).
class GlassSearchBar extends StatelessWidget {
  const GlassSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
    this.trailing,
    this.action,
    this.atTop = false,
  });

  /// Sits at the top of a page: no safe-area inset, and the gap is below.
  final bool atTop;

  final TextEditingController controller;
  final String hint;
  final Widget? trailing;
  final Widget? action;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const none = InputBorder.none;

    final bar = Padding(
      padding: atTop
          ? const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              Spacing.sm,
            )
          : const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.sm,
              Spacing.lg,
              Spacing.sm,
            ),
      child: Row(
        children: [
          Expanded(
            child: GlassSurface(
              // A Row (not InputDecoration prefix/suffix) so the icon, text
              // and trailing slot all centre on the capsule's midline.
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: Spacing.lg),
                  Icon(LucideIcons.search, color: colors.textMuted, size: 20),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      textInputAction: TextInputAction.search,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: FontSizeToken.lg,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: colors.textSubtle,
                          fontSize: FontSizeToken.lg,
                        ),
                        filled: false,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                        border: none,
                        enabledBorder: none,
                        focusedBorder: none,
                        disabledBorder: none,
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, _) => SearchClearSuffix(
                      visible: value.text.isNotEmpty,
                      trailing: trailing,
                      onClear: () {
                        controller.clear();
                        if (onClear != null) {
                          onClear!();
                        } else {
                          onChanged?.call('');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                ],
              ),
            ),
          ),
          if (action != null) ...[const SizedBox(width: Spacing.sm), action!],
        ],
      ),
    );
    if (atTop) return bar;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: Spacing.sm),
      child: bar,
    );
  }
}

/// A glass circle (same surface as the search capsule) holding an icon, for
/// [CustomHeaderLayout.searchAction]. Shows a small dot when [active].
class GlassCircleButton extends StatelessWidget {
  const GlassCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: GlassSurface(
          width: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: active ? colors.primary : colors.textMuted,
              ),
              if (active)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A self-contained [GlassSearchBar]: owns its text controller and optionally
/// debounces [onChanged]. Drop it at the bottom of a page's `Column`, under the
/// list it filters.
class GlassSearchDock extends StatefulWidget {
  const GlassSearchDock({
    super.key,
    required this.hint,
    required this.onChanged,
    this.action,
    this.debounceMilliseconds = 0,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final Widget? action;
  final int debounceMilliseconds;

  @override
  State<GlassSearchDock> createState() => _GlassSearchDockState();
}

class _GlassSearchDockState extends State<GlassSearchDock> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _changed(String value) {
    if (widget.debounceMilliseconds <= 0) {
      widget.onChanged(value);
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(
      Duration(milliseconds: widget.debounceMilliseconds),
      () => widget.onChanged(value),
    );
  }

  @override
  Widget build(BuildContext context) => GlassSearchBar(
    controller: _controller,
    hint: widget.hint,
    action: widget.action,
    onChanged: _changed,
    onClear: () {
      _debounce?.cancel();
      widget.onChanged('');
    },
  );
}
