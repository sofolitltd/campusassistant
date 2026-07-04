import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;
  final String title;
  final String url;

  const PdfViewerPage({
    super.key,
    required this.filePath,
    required this.title,
    required this.url,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late File _pdfFile;
  bool _showAppBar = true;
  bool _isLandscape = false;

  @override
  void initState() {
    super.initState();
    _pdfFile = File(widget.filePath);
  }

  void _toggleAppBar() {
    setState(() {
      _showAppBar = !_showAppBar;
    });
  }

  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
    });
    if (_isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              titleSpacing: 0,
              backgroundColor: Colors.white.withValues(alpha: 0.95),
              surfaceTintColor: Colors.white,
              title: Text(
                widget.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isLandscape
                        ? LucideIcons.rotateCcwSquare
                        : LucideIcons.rotateCwSquare,
                    size: 20,
                  ),
                  onPressed: _toggleOrientation,
                  tooltip: _isLandscape ? 'Portrait' : 'Landscape',
                ),
                _buildPopupMenu(),
              ],
            )
          : null,
      body: SafeArea(
        top: true, // Always reserve space for the status bar
        bottom: false,
        child: SfPdfViewer.file(
          _pdfFile,
          key: _pdfViewerKey,
          onTap: (details) => _toggleAppBar(),
          canShowScrollHead: true,
          canShowPaginationDialog: true,
          pageSpacing: 4,
        ),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      color: Colors.white,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 160),
      icon: const Icon(LucideIcons.ellipsisVertical, size: 20),
      onSelected: (value) async {
        switch (value) {
          case 'save':
            await _saveToDownloads();
            break;
          case 'share':
            await SharePlus.instance.share(
              ShareParams(
                files: [XFile(widget.filePath)],
                text: widget.title,
              ),
            );
            break;
          case 'open_with':
            await OpenFilex.open(widget.filePath);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'save',
          height: 36,
          child: Row(
            children: [
              Icon(LucideIcons.download, size: 18),
              SizedBox(width: 10),
              Text('Save to Downloads', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'share',
          height: 36,
          child: Row(
            children: [
              Icon(LucideIcons.share2, size: 18),
              SizedBox(width: 10),
              Text('Share', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'open_with',
          height: 36,
          child: Row(
            children: [
              Icon(LucideIcons.externalLink, size: 18),
              SizedBox(width: 10),
              Text('Open with', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveToDownloads() async {
    try {
      final file = File(widget.filePath);
      final fileName = widget.filePath.split('/').last;

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
}
