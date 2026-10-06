import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/compact_shortcut_strip.dart';
import '/features/study/data/models/study_shortcut.dart';

/// The study page's resource links. Shares [CompactShortcutStrip] with the
/// home page's quick links so the two look identical.
class ResourceShortcutsBar extends StatelessWidget {
  final int bookmarkCount;
  final int downloadCount;

  const ResourceShortcutsBar({
    super.key,
    required this.bookmarkCount,
    required this.downloadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.md),
      child: CompactShortcutStrip(
        items: [
          for (final shortcut in allShortcuts)
            ShortcutItem(
              label: shortcut.name,
              icon: shortcut.icon,
              badge: switch (shortcut.imageUrl) {
                'bookmark' => bookmarkCount,
                'download' => downloadCount,
                _ => 0,
              },
              onTap: () {
                if (shortcut.isNamedRoute) {
                  context.pushNamed(shortcut.route);
                } else {
                  context.push(shortcut.route);
                }
              },
            ),
        ],
      ),
    );
  }
}
