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

class DownloadedFilesPage extends ConsumerStatefulWidget {
  const DownloadedFilesPage({super.key});

  @override
  ConsumerState<DownloadedFilesPage> createState() =>
      _DownloadedFilesPageState();
}

class _DownloadedFilesPageState extends ConsumerState<DownloadedFilesPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final downloadsAsync = ref.watch(downloadedFilesProvider);
    final q = _query.trim().toLowerCase();

    return CustomHeaderLayout(
      title: 'Downloaded Files',
      showSearchBar: true,
      glassSearch: true,
      searchHint: 'Search downloaded files...',
      onSearchChanged: (v) => setState(() => _query = v),
      body: downloadsAsync.when(
        data: (allFiles) {
          if (allFiles.isEmpty) return _buildEmptyState(context);
          final files = q.isEmpty
              ? allFiles
              : allFiles.where((f) {
                  final r = f.resource;
                  return r.title.toLowerCase().contains(q) ||
                      r.courseCode.toLowerCase().contains(q) ||
                      r.courseTitle.toLowerCase().contains(q) ||
                      r.description.toLowerCase().contains(q);
                }).toList();
          if (files.isEmpty) return _buildNoMatches(context);
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

  Widget _buildNoMatches(BuildContext context) {
    return Center(
      child: Text(
        'No files match your search',
        style: TextStyle(color: context.colors.textMuted),
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
