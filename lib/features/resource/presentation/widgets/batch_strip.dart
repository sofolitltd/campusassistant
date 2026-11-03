import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

/// [child] (a card) with a strip hanging under it listing the batches the
/// resource is on. The strip is the card's width less 1px a side, and its
/// background reaches up behind the card, so it fills the card's rounded
/// bottom corners and reads as coming out from under it.
class BatchStrip extends StatelessWidget {
  const BatchStrip({super.key, required this.child, required this.names});

  final Widget child;
  final List<String> names;

  /// How far the strip's background reaches up behind the card; more than
  /// any card corner radius.
  static const _tuck = 24.0;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: context.colors.border);
    return Stack(
      children: [
        Positioned(
          left: 1,
          right: 1,
          top: _tuck,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.infoSubtle,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(RadiusToken.md),
              ),
              border: Border(left: border, right: border, bottom: border),
            ),
          ),
        ),
        Column(
          mainAxisSize: .min,
          children: [
            child,
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                Spacing.xs + 2,
                Spacing.md,
                Spacing.xs + 2,
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                      LucideIcons.users,
                      size: 12,
                      color: context.colors.info,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      names.join(' · '),
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontSize: FontSizeToken.xs,
                        fontWeight: .w600,
                        color: context.colors.info,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
