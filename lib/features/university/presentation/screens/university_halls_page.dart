import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/university_provider.dart';
import '/core/theme/tokens/app_radius.dart';

class UniversityHallsPage extends ConsumerWidget {
  const UniversityHallsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hallsAsync = ref.watch(hallsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hall List'), centerTitle: true),
      body: hallsAsync.when(
        data: (halls) => halls.isEmpty
            ? const Center(child: Text('No halls found.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: halls.length,
                itemBuilder: (context, index) {
                  final hall = halls[index];
                  return _HallCard(name: hall);
                },
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
        // trailing: Icon(
        //   LucideIcons.chevronRight,
        //   size: 18,
        //   color: Colors.grey.shade400,
        // ),
        onTap: () {
          // Navigate to individual hall details if needed
        },
      ),
    );
  }
}
