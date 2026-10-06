import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';

/// Fixed-size trailing slot for search fields: a clear (X) button while the
/// field has text, empty (or [trailing]) otherwise.
///
/// The slot is always [size] square, so the X appearing/disappearing never
/// changes the field's height or the width available to the text. Pair it with
/// [constraints] on `InputDecoration.suffixIconConstraints` — without that,
/// InputDecoration applies its own minimum and the slot resizes anyway.
class SearchClearSuffix extends StatelessWidget {
  const SearchClearSuffix({
    super.key,
    required this.visible,
    required this.onClear,
    this.trailing,
    this.size = defaultSize,
  });

  static const double defaultSize = 40;

  final bool visible;
  final VoidCallback onClear;

  /// Shown in the slot while there is nothing to clear (e.g. a filter button).
  final Widget? trailing;
  final double size;

  static BoxConstraints constraints([double size = defaultSize]) =>
      BoxConstraints.tightFor(width: size, height: size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: visible
          ? IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tightFor(width: size, height: size),
              icon: Icon(
                LucideIcons.x,
                size: 16,
                color: context.colors.textSubtle,
              ),
              onPressed: onClear,
            )
          : Center(child: trailing),
    );
  }
}
