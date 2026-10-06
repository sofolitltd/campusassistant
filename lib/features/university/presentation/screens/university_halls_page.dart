import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../providers/university_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class UniversityHallsPage extends ConsumerWidget {
  const UniversityHallsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hallsAsync = ref.watch(hallsProvider);

    return CustomHeaderLayout(
      title: 'Hall List',
      showSearchBar: false,
      body: hallsAsync.when(
        data: (halls) => halls.isEmpty
            ? const Center(child: Text('No halls found.'))
            : Column(
                children: [
                  _TotalCountBanner(
                    count: halls.length,
                    label: 'Total Halls',
                    icon: LucideIcons.home,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.lg,
                        0,
                        Spacing.lg,
                        Spacing.lg,
                      ),
                      itemCount: halls.length,
                      itemBuilder: (context, index) {
                        final hall = halls[index];
                        return _HallCard(name: hall);
                      },
                    ),
                  ),
                ],
              ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }
}

class _HallCard extends StatelessWidget {
  final String name;

  const _HallCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.xs,
        ),
        leading: Container(
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            color: context.colors.surfaceAlt,
            borderRadius: BorderRadius.circular(RadiusToken.sm),
          ),
          child: Icon(LucideIcons.hotel, size: 20, color: context.colors.info),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: .bold, fontSize: FontSizeToken.lg),
        ),
        onTap: () {},
      ),
    );
  }
}

class _TotalCountBanner extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;

  const _TotalCountBanner({
    required this.count,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 0),
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AccentToken.blue.withValues(alpha: 0.1),
              AccentToken.violet.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.info),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AccentToken.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),
              child: Icon(icon, color: AccentToken.blue, size: 22),
            ),
            const SizedBox(width: Spacing.lg),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '$count',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: .bold,
                    color: AccentToken.blue,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: context.colors.textMuted,
                    fontSize: FontSizeToken.md,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
