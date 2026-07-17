import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/providers/download_counter_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/red_header_layout.dart';
import '/features/resource/presentation/providers/downloads_provider.dart';
import '/features/resource/presentation/widgets/downloaded_resource_card.dart';

class DownloadedFilesPage extends ConsumerWidget {
  const DownloadedFilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadedFilesProvider);

    return RedHeaderLayout(
      title: 'Downloaded Files',
      showSearchBar: false,
      body: downloadsAsync.when(
        data: (files) {
          if (files.isEmpty) return _buildEmptyState(context);
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(downloadedFilesProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final file = files[index];
                return DownloadedResourceCard(
                  downloadedFile: file,
                  onDeleted: () {
                    ref.read(downloadedFilesProvider.notifier).refresh();
                    ref.invalidate(downloadCountProvider);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.folderOpen,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'No downloaded files found',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
