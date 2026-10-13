import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;
import 'package:url_launcher/url_launcher.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Overflow menu for [PdfViewerPage]: save/share/open-with on native,
/// open-in-browser/share-link on web (no local filesystem there).
class PdfViewerActionsMenu extends StatelessWidget {
  const PdfViewerActionsMenu({
    super.key,
    required this.filePath,
    required this.url,
    required this.title,
  });

  final String filePath;
  final String url;
  final String title;

  Future<void> _saveToDownloads() async {
    try {
      final file = File(filePath);
      final fileName = filePath.split('/').last;

      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory(
          '/storage/emulated/0/Download/Campus Assistant',
        );
      } else {
        downloadsDirectory = await getDownloadsDirectory();
      }

      if (downloadsDirectory != null) {
        await downloadsDirectory.create(recursive: true);
        final newPath = '${downloadsDirectory.path}/$fileName';
        await file.copy(newPath);
        Fluttertoast.showToast(msg: 'Saved to Downloads/Campus Assistant');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: context.colors.surface,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 160),
      icon: const Icon(LucideIcons.ellipsisVertical, size: 20),
      onSelected: (value) async {
        switch (value) {
          case 'save':
            await _saveToDownloads();
          case 'share':
            await SharePlus.instance.share(
              ShareParams(files: [XFile(filePath)], text: title),
            );
          case 'open_with':
            await OpenFilex.open(filePath);
          case 'open_browser':
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          case 'share_link':
            await SharePlus.instance.share(ShareParams(text: '$title\n$url'));
        }
      },
      itemBuilder: (context) => kIsWeb
          ? [
              // Web has no local filesystem — no save/share-file/open-with,
              // just the browser-native equivalents.
              const PopupMenuItem(
                value: 'open_browser',
                height: 36,
                child: _MenuRow(
                  icon: LucideIcons.externalLink,
                  label: 'Open in Browser',
                ),
              ),
              const PopupMenuItem(
                value: 'share_link',
                height: 36,
                child: _MenuRow(icon: LucideIcons.share2, label: 'Share Link'),
              ),
            ]
          : [
              const PopupMenuItem(
                value: 'save',
                height: 36,
                child: _MenuRow(
                  icon: LucideIcons.download,
                  label: 'Save to Downloads',
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                height: 36,
                child: _MenuRow(icon: LucideIcons.share2, label: 'Share'),
              ),
              const PopupMenuItem(
                value: 'open_with',
                height: 36,
                child: _MenuRow(
                  icon: LucideIcons.externalLink,
                  label: 'Open with',
                ),
              ),
            ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.text;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: Spacing.md),
        Text(
          label,
          style: TextStyle(fontSize: FontSizeToken.md, color: color),
        ),
      ],
    );
  }
}
