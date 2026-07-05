import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/red_header_layout.dart';

class DownloadedFilesPage extends StatefulWidget {
  const DownloadedFilesPage({super.key});

  @override
  State<DownloadedFilesPage> createState() => _DownloadedFilesPageState();
}

class _DownloadedFilesPageState extends State<DownloadedFilesPage> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> allFiles = directory.listSync();

      _files = allFiles.where((file) => file.path.endsWith('.pdf')).toList();

      _files.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );
    } catch (e) {
      debugPrint('Error loading files: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    try {
      await file.delete();
      _loadFiles();
      Fluttertoast.showToast(msg: 'File deleted');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting file');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RedHeaderLayout(
      title: 'Downloaded Files',
      showSearchBar: false,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final file = _files[index];
                final fileName = file.path.split('/').last;
                final stats = file.statSync();
                final sizeMb = (stats.size / (1024 * 1024)).toStringAsFixed(2);

                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.blueGrey.shade50,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () => OpenFilex.open(file.path),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                                    ),
                                    child: Icon(
                                      LucideIcons.fileText,
                                      color: isDark ? Colors.red.shade200 : Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fileName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          '$sizeMb MB • ${stats.modified.day}/${stats.modified.month}/${stats.modified.year}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          right: -4,
                          top: -4,
                          child: PopupMenuButton<String>(
                            color: theme.cardColor,
                            icon: Icon(LucideIcons.ellipsisVertical, size: 18),
                            onSelected: (value) async {
                              if (value == 'share') {
                                await SharePlus.instance.share(
                                  ShareParams(
                                    files: [XFile(file.path)],
                                    text: fileName,
                                  ),
                                );
                              } else if (value == 'delete') {
                                _showDeleteDialog(file);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'share',
                                height: 36,
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.share2, size: 16),
                                    SizedBox(width: 8),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                height: 36,
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.trash2,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
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

  void _showDeleteDialog(FileSystemEntity file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File?'),
        content: const Text(
          'This will permanently remove the file from your local storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteFile(file);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
