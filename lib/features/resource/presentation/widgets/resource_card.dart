import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/features/resource/domain/entities/resource.dart';
import '/widgets/pdf_viewer_page.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import 'resource_info_sheet.dart';

class ResourceCard extends ConsumerStatefulWidget {
  final Resource resource;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ResourceCard({
    super.key,
    required this.resource,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends ConsumerState<ResourceCard> {
  bool _isLoading = false;
  bool _isPaused = false;
  double _downloadProgress = 0;
  bool _isDownloaded = false;
  final bool _isBookmarked = false;
  String _localPath = '';
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _checkFileStatus();
    _checkBookmarkStatus();
  }

  Future<void> _checkFileStatus() async {
    final fileName = _getFileName();
    final directory = await getApplicationDocumentsDirectory();
    _localPath = '${directory.path}/$fileName';
    if (File(_localPath).existsSync()) {
      if (mounted) {
        setState(() {
          _isDownloaded = true;
        });
      }
    }
  }

  Future<void> _checkBookmarkStatus() async {
    // TODO: Implement bookmark check via API
  }

  String _getFileName() {
    final sanitizedTitle = widget.resource.title.replaceAll(
      RegExp('[^A-Za-z0-9]', dotAll: true),
      ' ',
    );
    final shortId = widget.resource.id.length > 5
        ? widget.resource.id.substring(0, 5)
        : widget.resource.id;
    return '${widget.resource.courseCode}-${widget.resource.lessonNo} ${sanitizedTitle}_${widget.resource.type}_$shortId.pdf';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profileAsync = ref.watch(userProvider);
    final profileData = profileAsync.value;

    List<String> contentBatches = List<String>.from(widget.resource.batches);
    contentBatches.sort((a, b) => b.compareTo(a));

    final isProUser = profileData?.information.status?.subscriber == 'pro';
    final isProContent = widget.resource.status == 'pro';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        color: theme.cardColor,
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
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            onTap: () async {
              if (kIsWeb) return;

              if (isProContent && !isProUser) {
                _showProDialog(context);
              } else {
                await _handleOpenContent();
              }
            },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        _buildThumbnail(isProContent),
                      const SizedBox(width: 12),
                      _buildDetails(context),
                    ],
                  ),
                ),
                Positioned(top: 0, right: 0, child: _buildPopupMenu()),
                Positioned(
                  bottom: 5,
                  right: 40,
                  child: Row(children: [_buildInfoButton(), _buildBookmark()]),
                ),
                Positioned(
                  bottom: 15,
                  right: 12,
                  child: _buildDownloadStatusAction(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(bool isProContent) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 80,
            height: 90,
            color: isDark
                ? theme.colorScheme.surface.withValues(alpha: 0.5)
                : Colors.blueAccent.shade100.withValues(alpha: 0.1),
            child: widget.resource.thumbnailUrl.isEmpty
                ? Icon(LucideIcons.fileText, color: theme.colorScheme.onSurface.withValues(alpha: 0.4), size: 30)
                : Image.network(
                    widget.resource.thumbnailUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, _) => Icon(
                      LucideIcons.fileText,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 30,
                    ),
                  ),
          ),
        ),
        if (isProContent)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.orange.withValues(alpha: .8),
              ),
              child: const Icon(
                LucideIcons.crown,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.fromLTRB(4, 3, 5, 3.5),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(2.5),
            ),
            child: Text(
              '${widget.resource.courseCode.toUpperCase()}: ${widget.resource.lessonNo}',
              style: const TextStyle(
                height: 1,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.resource.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.resource.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey.shade600,
                height: 1,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _buildMiniInfoTile(
                  context,
                  LucideIcons.hardDrive,
                  _getFileSizeStr(widget.resource.fileSizeBytes),
                ),
                const SizedBox(width: 8),
                _buildMiniInfoTile(
                  context,
                  LucideIcons.layers,
                  '${widget.resource.pageCount} Page',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu() {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: theme.cardColor,
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
      onSelected: (value) async {
        switch (value) {
          case 'download':
            await _handleOpenContent();
            break;
          case 'cancel':
            _handleCancelDownload();
            break;
          case 'save':
            await _saveToPublicDownloads();
            break;
          case 'share':
            await _handleShare();
            break;
          case 'open_with':
            await _handleOpenWith();
            break;
          case 'delete_local':
            await _handleDeleteLocally();
            break;
          case 'edit':
            widget.onEdit?.call();
            break;
          case 'delete':
            widget.onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (!_isDownloaded && !_isLoading)
          const PopupMenuItem(
            value: 'download',
            child: _PopupItem(icon: LucideIcons.download, text: 'Download'),
          ),
        if (_isLoading || _isPaused)
          const PopupMenuItem(
            value: 'cancel',
            child: _PopupItem(
              icon: LucideIcons.circleX,
              text: 'Cancel Download',
              isError: true,
            ),
          ),
        if (_isDownloaded)
          const PopupMenuItem(
            value: 'save',
            child: _PopupItem(
              icon: LucideIcons.cloudDownload,
              text: 'Save to Downloads',
            ),
          ),
        const PopupMenuItem(
          value: 'share',
          child: _PopupItem(icon: LucideIcons.share2, text: 'Share'),
        ),
        const PopupMenuItem(
          value: 'open_with',
          child: _PopupItem(icon: LucideIcons.externalLink, text: 'Open with'),
        ),
        if (_isDownloaded)
          const PopupMenuItem(
            value: 'delete_local',
            child: _PopupItem(
              icon: LucideIcons.trash2,
              text: 'Delete Locally',
              isError: true,
            ),
          ),
        if (widget.onEdit != null)
          const PopupMenuItem(
            value: 'edit',
            child: _PopupItem(icon: LucideIcons.pencil, text: 'Edit Resource'),
          ),
        if (widget.onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: _PopupItem(
              icon: LucideIcons.trash2,
              text: 'Delete Resource',
              isError: true,
            ),
          ),
      ],
    );
  }

  Widget _buildDownloadStatusAction() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (_isLoading || _isPaused) {
      return Container(
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.blueGrey.shade50,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                LucideIcons.circleX,
                size: 18,
                color: Colors.red,
              ),
              onPressed: _handleCancelDownload,
            ),
            IconButton(
              icon: Icon(
                _isPaused ? LucideIcons.play : LucideIcons.pause,
                size: 18,
                color: Colors.teal,
              ),
              onPressed: () => _isPaused ? _resumeDownload() : _pauseDownload(),
            ),
            _buildCircularProgress(),
          ],
        ),
      );
    }
    if (_isDownloaded) {
      return Icon(LucideIcons.circleCheck, color: Colors.green, size: 20);
    }
    return GestureDetector(
      onTap: _handleOpenContent,
      child: Icon(
        LucideIcons.circleArrowDown,
        color: theme.colorScheme.primary,
        size: 20,
      ),
    );
  }

  Widget _buildCircularProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
          SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              value: _downloadProgress,
              strokeWidth: 3,
              backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            ),
          ),
        Text(
          '${(_downloadProgress * 100).toInt()}%',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBookmark() {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: _handleBookmarkToggle,
      icon: Icon(
        _isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
        color: _isBookmarked ? Colors.teal : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 18,
      ),
    );
  }

  Widget _buildInfoButton() {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: _showInfoBottomSheet,
      icon: Icon(LucideIcons.info, color: theme.colorScheme.onSurface.withValues(alpha: 0.4), size: 18),
    );
  }

  Widget _buildMiniInfoTile(BuildContext context, IconData icon, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface.withValues(alpha: 0.5) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSizeStr(int bytes) {
    if (bytes <= 0) return '0.0 MB';
    if (bytes > 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes > 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ResourceInfoSheet(
          resource: widget.resource,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showProDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pro Feature'),
        content: const Text('This content is for Pro subscribers only.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleOpenContent() async {
    if (!_isDownloaded) await _downloadIfNeeded();
    if (_isDownloaded && _localPath.isNotEmpty) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerPage(
              filePath: _localPath,
              url: widget.resource.fileUrl,
              title: widget.resource.title,
            ),
          ),
        );
      }
    }
  }

  Future<void> _downloadIfNeeded() async {
    if (_isDownloaded || _isLoading) return;
    setState(() {
      _isLoading = true;
      _isPaused = false;
    });
    _cancelToken = CancelToken();
    final success = await _downloadFile(widget.resource.fileUrl, _localPath);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isDownloaded = success;
      });
    }
  }

  Future<bool> _downloadFile(String url, String path) async {
    try {
      await Dio().download(
        url,
        path,
        cancelToken: _cancelToken,
        onReceiveProgress: (count, total) {
          if (total != -1 && mounted) {
            setState(() {
              _downloadProgress = count / total;
            });
          }
        },
      );
      return true;
    } catch (e) {
      log('Download error: $e');
      return false;
    }
  }

  void _pauseDownload() {
    _cancelToken?.cancel("pause");
    if (mounted) {
      setState(() {
        _isPaused = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _resumeDownload() async {
    if (mounted) {
      setState(() {
        _isPaused = false;
        _isLoading = true;
      });
    }
    _cancelToken = CancelToken();
    final success = await _downloadFile(widget.resource.fileUrl, _localPath);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isDownloaded = success;
      });
    }
  }

  void _handleCancelDownload() {
    _cancelToken?.cancel("cancel");
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isPaused = false;
        _downloadProgress = 0;
      });
    }
  }

  Future<void> _handleShare() async {
    if (!_isDownloaded) await _downloadIfNeeded();
    if (_isDownloaded && _localPath.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(_localPath)],
          text: widget.resource.title,
        ),
      );
    }
  }

  Future<void> _handleOpenWith() async {
    if (!_isDownloaded) await _downloadIfNeeded();
    if (_isDownloaded && _localPath.isNotEmpty) {
      await OpenFilex.open(_localPath);
    }
  }

  Future<void> _handleDeleteLocally() async {
    try {
      final file = File(_localPath);
      if (file.existsSync()) {
        await file.delete();
        if (mounted) {
          setState(() {
            _isDownloaded = false;
            _downloadProgress = 0;
          });
        }
        Fluttertoast.showToast(msg: 'File deleted locally');
      }
    } catch (e) {
      log('Delete error: $e');
    }
  }

  Future<void> _saveToPublicDownloads() async {
    try {
      if (!_isDownloaded) return;
      final file = File(_localPath);
      Directory? dir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download/Campus Assistant')
          : await getDownloadsDirectory();
      if (dir != null) {
        await dir.create(recursive: true);
        await file.copy('${dir.path}/${_getFileName()}');
        Fluttertoast.showToast(msg: 'Saved to Downloads');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving: $e');
    }
  }

  Future<void> _handleBookmarkToggle() async {
    Fluttertoast.showToast(msg: 'Bookmark feature coming soon');
  }
}

class _PopupItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isError;
  const _PopupItem({
    required this.icon,
    required this.text,
    this.isError = false,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: isError ? Colors.red : null),
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(fontSize: 13, color: isError ? Colors.red : null),
      ),
    ],
  );
}
