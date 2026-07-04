import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:campusassistant/core/providers/theme_provider.dart';
import 'section_header.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';

class ThemeSection extends ConsumerWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          SectionHeader(
            title: 'Appearance',
            subtitle: 'Manage app theme mode',
            icon: LucideIcons.palette,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).cardColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ThemeMode>(
                value: themeMode,
                isExpanded: true,
                icon: Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: cs.onSurface,
                ),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Row(
                      children: [
                        Icon(LucideIcons.monitor,
                            size: 18, color: cs.onSurface),
                        const SizedBox(width: 12),
                        const Text('System'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Row(
                      children: [
                        Icon(LucideIcons.sun, size: 18, color: cs.onSurface),
                        const SizedBox(width: 12),
                        const Text('Light'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Row(
                      children: [
                        Icon(LucideIcons.moon, size: 18, color: cs.onSurface),
                        const SizedBox(width: 12),
                        const Text('Dark'),
                      ],
                    ),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(themeProvider.notifier).setTheme(mode);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
