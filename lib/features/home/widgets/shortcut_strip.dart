import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/mouse_wheel_horizontal_scroll.dart';
import '/core/widgets/section_card.dart';
import 'home_section.dart';

class _Shortcut {
  const _Shortcut(this.title, this.icon, this.route);
  final String title;
  final IconData icon;
  final String route;
}

const _shortcuts = [
  _Shortcut('Class\nRoutine', LucideIcons.calendarDays, '/routine'),
  _Shortcut('Alumni\nNetwork', LucideIcons.graduationCap, '/alumni'),
  _Shortcut('Emergency\nContacts', LucideIcons.siren, '/emergency'),
  _Shortcut('Transport\nServices', LucideIcons.tramFront, '/transport'),
  _Shortcut('Clubs &\nOrganizations', LucideIcons.club, '/club'),
  _Shortcut('Student\nAssociations', LucideIcons.landmark, '/association'),
  _Shortcut('Blood\nBank', LucideIcons.heartPulse, '/blood-bank'),
  _Shortcut('Lost &\nFound', LucideIcons.searchCheck, '/lost-found'),
];

/// Horizontally scrolling grid of quick links: two rows on phones, one row on
/// wide layouts. The height is derived from the card content and the user's
/// text scale rather than hard-coded, so large accessibility text can't clip
/// the labels.
class ShortcutStrip extends StatefulWidget {
  const ShortcutStrip({super.key});

  @override
  State<ShortcutStrip> createState() => _ShortcutStripState();
}

class _ShortcutStripState extends State<ShortcutStrip> {
  final _controller = ScrollController();

  static const double _cardWidth = 96;
  static const double _iconCircle = 36;
  static const double _labelSize = 12;
  static const double _labelHeight = 1.2;
  static const double _gap = Spacing.sm;
  static const double _vPad = Spacing.sm;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _cardHeight(double textScale) =>
      Spacing.sm * 2 +
      _iconCircle +
      Spacing.xs +
      2 * _labelSize * _labelHeight * textScale;

  @override
  Widget build(BuildContext context) {
    final textScale =
        MediaQuery.textScalerOf(
          context,
        ).scale(_labelSize).clamp(_labelSize, _labelSize * 1.5) /
        _labelSize;

    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = constraints.maxWidth >= 500 ? 1 : 2;
        final height =
            rows * _cardHeight(textScale) + (rows - 1) * _gap + _vPad * 2;

        return SizedBox(
          height: height,
          child: MouseWheelHorizontalScroll(
            controller: _controller,
            child: GridView.builder(
              controller: _controller,
              scrollDirection: .horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: homeInset,
                vertical: _vPad,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rows,
                mainAxisSpacing: _gap,
                crossAxisSpacing: _gap,
                mainAxisExtent: _cardWidth,
              ),
              itemCount: _shortcuts.length,
              itemBuilder: (context, i) => _ShortcutCard(
                shortcut: _shortcuts[i],
                iconCircle: _iconCircle,
                labelSize: _labelSize,
                labelHeight: _labelHeight,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.shortcut,
    required this.iconCircle,
    required this.labelSize,
    required this.labelHeight,
  });

  final _Shortcut shortcut;
  final double iconCircle;
  final double labelSize;
  final double labelHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SectionCard(
      radius: homeCardRadius,
      padding: const EdgeInsets.all(Spacing.sm),
      onTap: () => context.push(shortcut.route),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Container(
            width: iconCircle,
            height: iconCircle,
            decoration: BoxDecoration(
              color: colors.primarySubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(shortcut.icon, size: 22, color: colors.primary),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            shortcut.title,
            textAlign: .center,
            maxLines: 2,
            overflow: .ellipsis,
            style: TextStyle(
              fontSize: labelSize,
              height: labelHeight,
              fontWeight: .w500,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
