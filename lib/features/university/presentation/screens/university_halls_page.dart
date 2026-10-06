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

class UniversityHallsPage extends ConsumerStatefulWidget {
  const UniversityHallsPage({super.key});

  @override
  ConsumerState<UniversityHallsPage> createState() =>
      _UniversityHallsPageState();
}

class _UniversityHallsPageState extends ConsumerState<UniversityHallsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final hallsAsync = ref.watch(hallsProvider);

    return CustomHeaderLayout(
      title: 'Halls',
      searchAtBottom: true,
      searchHint: 'Search halls...',
      onSearchChanged: (value) => setState(() => _query = value),
      body: hallsAsync.when(
        data: (halls) {
          if (halls.isEmpty) {
            return const Center(child: Text('No halls found.'));
          }
          final q = _query.trim().toLowerCase();
          final filtered = q.isEmpty
              ? halls
              : halls.where((h) => h.toLowerCase().contains(q)).toList();

          return ListView(
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              Text(
                'Halls (${filtered.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
              ),
              const SizedBox(height: Spacing.lg),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xxl),
                  child: Center(
                    child: Text(
                      'No halls match "$_query"',
                      style: TextStyle(color: context.colors.textMuted),
                    ),
                  ),
                )
              else
                ...filtered.map((hall) => _HallCard(name: hall)),
            ],
          );
        },
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
          child: Icon(
            LucideIcons.hotel,
            size: 20,
            color: context.colors.primary,
          ),
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
