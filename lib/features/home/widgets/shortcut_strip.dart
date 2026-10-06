import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/compact_shortcut_strip.dart';
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

/// The home page's quick links: two compact rows on phones, one on wide
/// layouts. Shares [CompactShortcutStrip] with the study page.
class ShortcutStrip extends StatelessWidget {
  const ShortcutStrip({super.key});

  @override
  Widget build(BuildContext context) => CompactShortcutStrip(
    maxRows: 2,
    horizontalInset: homeInset,
    topPad: 0,
    items: [
      for (final s in _shortcuts)
        ShortcutItem(
          label: s.title,
          icon: s.icon,
          onTap: () => context.push(s.route),
        ),
    ],
  );
}
