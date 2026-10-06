import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/providers/download_counter_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/resource/presentation/providers/downloads_provider.dart';
import '/features/resource/presentation/widgets/downloaded_resource_card.dart';
import '/core/theme/app_colors.dart';

class DownloadedFilesPage extends ConsumerWidget {
  const DownloadedFilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadedFilesProvider);

    return CustomHeaderLayout(
      title: 'Downloaded Files',
      showSearchBar: false,
      body: downloadsAsync.when(
        data: (files) {
          if (files.isEmpty) return _buildEmptyState(context);
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(downloadedFilesProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(Spacing.lg),
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
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
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            LucideIcons.folderOpen,
            size: 64,
            color: context.colors.borderStrong,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'No downloaded files found',
            style: TextStyle(
              color: context.colors.textMuted,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }
}
