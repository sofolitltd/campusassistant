import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/association/presentation/providers/association_provider.dart';
import 'association_page.dart' show AssociationCard;

/// Lists the associations the current user has formally joined — distinct
/// from a "manage/owned" list (there is no such screen for associations
/// yet; the backend's separate GET /my/associations, listing owned/
/// co-managed associations, has no Flutter UI wired to it in this pass).
class JoinedAssociationsPage extends ConsumerWidget {
  const JoinedAssociationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinedAsync = ref.watch(myJoinedAssociationsProvider);

    return CustomHeaderLayout(
      title: 'Joined Associations',
      showSearchBar: false,
      body: joinedAsync.when(
        data: (associations) {
          if (associations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.landmark,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'You haven\'t joined any associations yet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse Associations and tap Join on one you like.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(myJoinedAssociationsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: associations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) =>
                  AssociationCard(association: associations[index]),
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
