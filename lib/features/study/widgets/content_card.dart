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

import 'package:uuid/uuid.dart';

import '../data/models/content_model.dart';
import '/widgets/pdf_viewer_page.dart';
import '/core/ads/download_ad_gate.dart';
import '/core/providers/is_pro_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/bookmark/domain/entities/bookmark.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import 'resource_info_sheet.dart';

class ContentCard extends ConsumerStatefulWidget {
  final ContentModel contentModel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContentCard({
    super.key,
    required this.contentModel,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends ConsumerState<ContentCard> {
  bool _isLoading = false;
  bool _isPaused = false;
  double _downloadProgress = 0;
  bool _isDownloaded = false;
  bool _isBookmarked = false;
  String? _bookmarkId;
  String _localPath = '';
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _checkFileStatus();
  }

  Future<void> _checkFileStatus() async {
    // No local filesystem on web — path_provider has no web implementation.
    // "Downloaded" isn't a meaningful state there; content just streams.
    if (kIsWeb) return;
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

  String _getFileName() {
    return '${widget.contentModel.courseCode}-${widget.contentModel.lessonNo} ${widget.contentModel.contentTitle.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.contentModel.contentSubtitle}_${widget.contentModel.contentId.toString().substring(0, 5)}.pdf';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profileAsync = ref.watch(userProvider);
    final profileData = profileAsync.value;

    List<String> contentBatches = List<String>.from(
      widget.contentModel.batches,
    );
    contentBatches.sort((a, b) => b.compareTo(a));

    final isProUser = ref.watch(isProUserProvider);
    final isProContent = widget.contentModel.status == 'pro';

    final userId = profileData?.uid ?? '';
    ref.listen(userBookmarksProvider(userId), (_, next) {
      if (userId.isEmpty) return;
      next.whenOrNull(
        data: (bookmarks) {
          final match = bookmarks.where(
            (b) =>
                b.entityType == 'resource' &&
                b.entityId == widget.contentModel.contentId,
          );
          final found = match.isNotEmpty;
          if (found != _isBookmarked ||
              (found && _bookmarkId != match.first.id)) {
            if (mounted) {
              setState(() {
                _isBookmarked = found;
                _bookmarkId = found ? match.first.id : null;
              });
            }
          }
        },
      );
    });

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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            onTap: () async {
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
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          //
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: 80,
                              height: 90,
                              color: isDark
                                  ? theme.colorScheme.surface.withValues(
                                      alpha: 0.5,
                                    )
                                  : Colors.blueAccent.shade100.withValues(
                                      alpha: 0.1,
                                    ),
                              child: widget.contentModel.imageUrl == ''
                                  ? Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Image.network(
                                      ApiEndpoints.resolveImageUrl(
                                        widget.contentModel.imageUrl,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),

                          //
                          if (isProContent)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: .all(2.5),
                                decoration: BoxDecoration(
                                  shape: .rectangle,
                                  borderRadius: .circular(4),
                                  color: Colors.orange.withValues(alpha: .8),
                                ),
                                child: const Icon(
                                  LucideIcons.crown,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),

                          //
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
                                widget.contentModel.contentType.toLowerCase() ==
                                        "notes"
                                    ? '${widget.contentModel.courseCode.toUpperCase()}: ${widget.contentModel.lessonNo}'
                                    : widget.contentModel.courseCode
                                          .toUpperCase(),
                                style: theme.textTheme.bodySmall!.copyWith(
                                  height: 1,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      //
                      Expanded(
                        child: SizedBox(
                          height: 95,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.contentModel.contentTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.contentModel.contentSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  height: 1,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  _buildMiniInfoTile(
                                    context,
                                    LucideIcons.hardDrive,
                                    _getFileSizeStr(
                                      widget
                                          .contentModel
                                          .metadata?['fileSizeBytes'],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildMiniInfoTile(
                                    context,
                                    LucideIcons.layers,
                                    '${widget.contentModel.metadata?['pageCount'] ?? 0} Page',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //
                Positioned(top: 0, right: 0, child: _buildPopupMenu()),

                //
                Positioned(
                  bottom: 5,
                  right: 40,
                  child: Row(children: [_buildInfoButton(), _buildBookmark()]),
                ),

                //
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

  Widget _buildPopupMenu() {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: theme.cardColor,
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      constraints: const BoxConstraints(minWidth: 140),
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
      onSelected: (value) async {
        switch (value) {
          case 'download':
            await _handleOpenContent();
            break;
          case 'cancel':
            _handleCancelDownload();
            break;
          case 'save_to_downloads':
            await _saveToPublicDownloads();
            break;
          case 'share':
            await _handleShare();
            break;
          case 'open_with':
            await _handleOpenWith();
            break;
          case 'delete':
            await _handleDelete();
            break;
          case 'admin_edit':
            widget.onEdit?.call();
            break;
          case 'admin_delete':
            widget.onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (!_isDownloaded && !_isLoading && !_isPaused)
          PopupMenuItem(
            value: 'download',
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(kIsWeb ? LucideIcons.eye : LucideIcons.download, size: 16),
                const SizedBox(width: 8),
                Text(
                  kIsWeb ? 'View' : 'Download',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        if (_isLoading || _isPaused)
          const PopupMenuItem(
            value: 'cancel',
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.circleX, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Cancel Download',
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ],
            ),
          ),
        if (_isDownloaded)
          const PopupMenuItem(
            value: 'save_to_downloads',
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.cloudDownload, size: 16),
                SizedBox(width: 8),
                Text('Save to Downloads', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'share',
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(LucideIcons.share2, size: 16),
              SizedBox(width: 8),
              Text('Share', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        if (!kIsWeb)
          const PopupMenuItem(
            value: 'open_with',
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.externalLink, size: 16),
                SizedBox(width: 8),
                Text('Open with', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        if (_isDownloaded)
          const PopupMenuItem(
            value: 'delete',
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Delete Locally',
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ],
            ),
          ),
        if (widget.onEdit != null)
          const PopupMenuItem(
            value: 'admin_edit',
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.pencil, size: 16),
                SizedBox(width: 8),
                Text('Edit Resource', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        if (widget.onDelete != null)
          const PopupMenuItem(
            value: 'admin_delete',
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Delete Resource',
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ],
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
        padding: .only(right: 10),
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
              onPressed: _handleCancelDownload,
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(
                LucideIcons.circleX,
                size: 18,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                if (_isPaused) {
                  _resumeDownload();
                } else {
                  _pauseDownload();
                }
              },
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              icon: Icon(
                _isPaused ? LucideIcons.play : LucideIcons.pause,
                size: 18,
                color: Colors.teal,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    value: _downloadProgress,
                    strokeWidth: 3,
                    backgroundColor: theme.colorScheme.surface.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                Text(
                  '${(_downloadProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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

  Widget _buildBookmark() {
    final theme = Theme.of(context);
    return IconButton(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: _handleBookmarkToggle,
      icon: Icon(
        _isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
        color: _isBookmarked
            ? Colors.teal
            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 18,
      ),
    );
  }

  Widget _buildInfoButton() {
    final theme = Theme.of(context);
    return IconButton(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: _showInfoBottomSheet,
      icon: Icon(
        LucideIcons.info,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 18,
      ),
    );
  }

  Widget _buildMiniInfoTile(BuildContext context, IconData icon, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : Colors.grey.shade50,
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
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSizeStr(dynamic fileSizeBytes) {
    if (fileSizeBytes == null) return '--';
    final int bytes = int.tryParse(fileSizeBytes.toString()) ?? 0;
    if (bytes <= 0) return '0.0 MB';
    if (bytes > 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes > 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '$bytes B';
    }
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return ResourceInfoSheet(
              contentModel: widget.contentModel,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  //
  Future<void> _handleBookmarkToggle() async {
    final userAsync = ref.read(userProvider);
    final userId = userAsync.value?.uid ?? '';
    if (userId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please login to bookmark');
      return;
    }

    if (_isBookmarked && _bookmarkId != null) {
      final repo = ref.read(bookmarkRepositoryProvider);
      final result = await repo.removeBookmark(_bookmarkId!);
      result.fold(
        (failure) => Fluttertoast.showToast(msg: 'Failed to remove bookmark'),
        (_) {
          if (mounted) {
            setState(() {
              _isBookmarked = false;
              _bookmarkId = null;
            });
          }
          ref.invalidate(userBookmarksProvider);
          Fluttertoast.showToast(msg: 'Bookmark removed');
        },
      );
    } else {
      final bookmark = Bookmark(
        id: Uuid().v4(),
        userId: userId,
        entityType: 'resource',
        entityId: widget.contentModel.contentId,
      );
      final repo = ref.read(bookmarkRepositoryProvider);
      final result = await repo.addBookmark(bookmark);
      result.fold(
        (failure) => Fluttertoast.showToast(msg: 'Failed to add bookmark'),
        (_) {
          if (mounted) {
            setState(() {
              _isBookmarked = true;
              _bookmarkId = bookmark.id;
            });
          }
          ref.invalidate(userBookmarksProvider);
          Fluttertoast.showToast(msg: 'Bookmarked');
        },
      );
    }
  }

  //
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
    // No local file to attach on web — share the link instead.
    if (kIsWeb) {
      await SharePlus.instance.share(
        ShareParams(
          text:
              '${widget.contentModel.contentTitle}\n${widget.contentModel.fileUrl}',
        ),
      );
      return;
    }

    if (!_isDownloaded) await _downloadIfNeeded();
    if (_isDownloaded && _localPath.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(_localPath)],
          text: widget.contentModel.contentTitle,
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

  Future<void> _handleDelete() async {
    try {
      final file = File(_localPath);
      if (file.existsSync()) {
        await file.delete();
        if (mounted) {
          setState(() {
            _isDownloaded = false;
            _isPaused = false;
            _isLoading = false;
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
      final fileName = _getFileName();
      Directory? downloadsDirectory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download/Campus Assistant')
          : await getDownloadsDirectory();
      if (downloadsDirectory != null) {
        await downloadsDirectory.create(recursive: true);
        await file.copy('${downloadsDirectory.path}/$fileName');
        Fluttertoast.showToast(msg: 'Saved to Downloads folder');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving: $e');
    }
  }

  Future<void> _downloadIfNeeded() async {
    // No local filesystem on web — nothing to download to, and the ad gate
    // below relies on google_mobile_ads, which has no web implementation.
    if (kIsWeb) return;
    if (_isDownloaded || _isLoading) return;

    final shouldDownload = await showDownloadAdGate(context, ref);
    if (!shouldDownload || !mounted) return;

    setState(() {
      _isLoading = true;
      _isPaused = false;
    });
    _cancelToken = CancelToken();
    final success = await _downloadFile(
      widget.contentModel.fileUrl,
      _localPath,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _isDownloaded = true;
          _isPaused = false;
        }
      });
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
    final success = await _downloadFile(
      widget.contentModel.fileUrl,
      _localPath,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _isDownloaded = true;
          _isPaused = false;
        }
      });
    }
  }

  Future<void> _handleOpenContent() async {
    // Web streams the PDF straight from the URL (see PdfViewerPage) — no
    // local download step needed or possible.
    if (kIsWeb) {
      _openInAppViewer();
      return;
    }

    if (_isDownloaded) {
      _openInAppViewer();
      return;
    }

    // Routes through the same gated path _downloadIfNeeded uses (rather
    // than downloading inline here) so the ad gate can't be bypassed by
    // opening a card directly instead of using its download button.
    await _downloadIfNeeded();
    if (_isDownloaded) _openInAppViewer();
  }

  void _openInAppViewer() {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            filePath: _localPath,
            title: widget.contentModel.contentTitle,
            url: widget.contentModel.fileUrl,
          ),
        ),
      );
    }
  }

  Future<bool> _downloadFile(String url, String savePath) async {
    RandomAccessFile? raf;
    try {
      final file = File(savePath);
      int start = 0;
      if (file.existsSync()) {
        start = await file.length();
      }

      final response = await Dio().get<ResponseBody>(
        url,
        cancelToken: _cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          followRedirects: false,
          headers: start > 0 ? {"range": "bytes=$start-"} : {},
          validateStatus: (status) =>
              status != null && (status == 200 || status == 206),
        ),
      );

      if (response.statusCode == 206) {
        raf = await file.open(mode: FileMode.append);
      } else {
        start = 0;
        raf = await file.open(mode: FileMode.write);
      }

      int received = start;
      int contentLength = int.parse(
        response.headers.value('content-length') ?? '0',
      );
      int total = contentLength + start;

      final stream = response.data!.stream;
      await for (final chunk in stream) {
        await raf.writeFrom(chunk);
        received += chunk.length;
        if (mounted && total > 0) {
          setState(() {
            _downloadProgress = received / total;
          });
        }
      }

      await raf.close();
      return true;
    } catch (e) {
      if (raf != null) {
        try {
          await raf.close();
        } catch (_) {}
      }

      if (e is DioException && CancelToken.isCancel(e)) {
        if (e.message == "pause") {
          Fluttertoast.showToast(msg: 'Download paused');
        } else {
          Fluttertoast.showToast(msg: 'Download cancelled');
          final file = File(savePath);
          if (file.existsSync()) await file.delete();
        }
      } else {
        log('Download error: $e');
        Fluttertoast.showToast(msg: 'Download failed');
      }
      return false;
    }
  }

  void _showProDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.sm),
        ),
        title: const Text(
          "Pro Content 🔒",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("This file is available only for Pro members."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Become Pro"),
          ),
        ],
      ),
    );
  }
}
