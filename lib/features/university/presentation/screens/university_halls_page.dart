import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/red_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../providers/university_provider.dart';

class UniversityHallsPage extends ConsumerWidget {
  const UniversityHallsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hallsAsync = ref.watch(hallsProvider);

    return RedHeaderLayout(
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(RadiusToken.sm),
          ),
          child: Icon(LucideIcons.hotel, size: 20, color: Colors.blue.shade700),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3B82F6).withValues(alpha: 0.1),
              Color(0xFF8B5CF6).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.blue.shade100,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),
              child: Icon(icon, color: Color(0xFF3B82F6), size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 13,
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
