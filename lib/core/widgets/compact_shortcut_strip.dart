import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/mouse_wheel_horizontal_scroll.dart';
import '/core/widgets/section_card.dart';

class ShortcutItem {
  const ShortcutItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.badge = 0,
  });

  /// Up to two lines; a `\n` splits them.
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  /// Shown as a small count on the icon when greater than zero.
  final int badge;
}

/// Compact horizontally-scrolling row (or two rows) of quick links, used by
/// both the home and study pages so they stay identical.
///
/// Tiles stretch to fill the full width: the number that fit is worked out
/// from a minimum tile width, then each is widened so there is no leftover gap
/// at the right edge. If there are more tiles than fit, the rest scroll in.
///
/// Each tile is a small icon-over-label card (about 80px tall). The strip's
/// height is derived from the tile content and the user's text scale, never
/// hard-coded, so large text can't overflow it.
class CompactShortcutStrip extends StatefulWidget {
  const CompactShortcutStrip({
    super.key,
    required this.items,
    this.maxRows = 1,
    this.horizontalInset = Spacing.lg,
    this.topPad = _defaultVPad,
  });

  final List<ShortcutItem> items;

  /// Rows on narrow screens; wide layouts always use one row.
  final int maxRows;
  final double horizontalInset;

  /// Space above the first row; the space below is always the default.
  final double topPad;

  static const double _defaultVPad = Spacing.xs;

  @override
  State<CompactShortcutStrip> createState() => _CompactShortcutStripState();
}

class _CompactShortcutStripState extends State<CompactShortcutStrip> {
  final _controller = ScrollController();

  // Narrowest a tile may get; the real width is stretched from this so a
  // whole number of tiles exactly fills the available width.
  static const double _minTileWidth = 76;
  static const double _iconCircle = 30;
  static const double _labelSize = 11;
  static const double _labelHeight = 1.15;
  static const double _tilePadTop = 10;
  static const double _tilePadBottom = 6;
  static const double _iconGap = 7;
  static const double _gap = Spacing.sm;
  static const double _vPad = CompactShortcutStrip._defaultVPad;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _tileHeight(double textScale) {
    // Line boxes round up to whole pixels, so round each line up too.
    final text = 2 * (_labelSize * _labelHeight * textScale).ceilToDouble();
    // + 2 for SectionCard's 1px border on each side.
    return _tilePadTop + _tilePadBottom + _iconCircle + _iconGap + text + 2;
  }

  @override
  Widget build(BuildContext context) {
    final textScale =
        MediaQuery.textScalerOf(
          context,
        ).scale(_labelSize).clamp(_labelSize, _labelSize * 1.5) /
        _labelSize;

    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = constraints.maxWidth >= 500 ? 1 : widget.maxRows;
        final available = constraints.maxWidth - widget.horizontalInset * 2;
        final fit = ((available + _gap) / (_minTileWidth + _gap)).floor();
        final columns = fit
            .clamp(1, (widget.items.length / rows).ceil())
            .toInt();
        final tileWidth = (available - (columns - 1) * _gap) / columns;
        final tileHeight = _tileHeight(textScale);
        final height =
            rows * tileHeight + (rows - 1) * _gap + widget.topPad + _vPad;

        return SizedBox(
          height: height,
          // Labels scale with the user's text size, but only up to the same
          // cap the height above is computed with.
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: MouseWheelHorizontalScroll(
              controller: _controller,
              child: GridView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(
                  widget.horizontalInset,
                  widget.topPad,
                  widget.horizontalInset,
                  _vPad,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rows,
                  mainAxisSpacing: _gap,
                  crossAxisSpacing: _gap,
                  mainAxisExtent: tileWidth,
                ),
                itemCount: widget.items.length,
                itemBuilder: (context, i) => _ShortcutTile(
                  item: widget.items[i],
                  iconCircle: _iconCircle,
                  labelSize: _labelSize,
                  labelHeight: _labelHeight,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.item,
    required this.iconCircle,
    required this.labelSize,
    required this.labelHeight,
  });

  final ShortcutItem item;
  final double iconCircle;
  final double labelSize;
  final double labelHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SectionCard(
      radius: RadiusToken.lg,
      shadow: false,
      padding: const EdgeInsets.fromLTRB(
        Spacing.xs,
        _CompactShortcutStripState._tilePadTop,
        Spacing.xs,
        _CompactShortcutStripState._tilePadBottom,
      ),
      onTap: item.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: iconCircle,
                height: iconCircle,
                decoration: BoxDecoration(
                  color: colors.primarySubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 17, color: colors.primary),
              ),
              if (item.badge > 0)
                Positioned(
                  right: -5,
                  top: -4,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 15,
                      minHeight: 15,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.danger,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.surface, width: 1.5),
                    ),
                    child: Text(
                      item.badge > 99 ? '99+' : '${item.badge}',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 9,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: _CompactShortcutStripState._iconGap),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: labelSize,
              height: labelHeight,
              fontWeight: FontWeight.normal,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
