import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_icons.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../screens/full_media_viewer.dart';
import 'app_pdf_viewer.dart';

/// In-memory cache for rendered PDF thumbnails so scrolling back doesn't re-download.
final Map<String, Uint8List> _pdfThumbnailCache = {};

/// Renders page 1 of a PDF as a thumbnail image.
class PdfThumbnailWidget extends StatefulWidget {
  final String url;
  const PdfThumbnailWidget({super.key, required this.url});

  @override
  State<PdfThumbnailWidget> createState() => _PdfThumbnailWidgetState();
}

class _PdfThumbnailWidgetState extends State<PdfThumbnailWidget> {
  Uint8List? _bytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    // Check cache first
    final cached = _pdfThumbnailCache[widget.url];
    if (cached != null) {
      if (mounted) setState(() { _bytes = cached; _isLoading = false; });
      return;
    }

    PdfDocument? document;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = "${widget.url.split('/').last.split('?').first}_thumb.pdf";
      final file = File('${dir.path}/$fileName');

      if (!await file.exists()) {
        final response = await http.get(Uri.parse(widget.url));
        if (response.statusCode != 200) {
          if (mounted) setState(() => _isLoading = false);
          return;
        }
        await file.writeAsBytes(response.bodyBytes);
      }

      document = await PdfDocument.openFile(file.path);
      final page = await document.getPage(1);
      final image = await page.render(width: 144, height: 200);
      await page.close();

      if (mounted) {
        setState(() {
          _bytes = image?.bytes;
          _isLoading = false;
        });
        if (image?.bytes != null) {
          _pdfThumbnailCache[widget.url] = image!.bytes;
        }
      }
    } catch (e) {
      debugPrint('PDF thumbnail error: $e');
      if (mounted) setState(() => _isLoading = false);
    } finally {
      document?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_isLoading) {
      return Container(
        color: cs.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      );
    }
    if (_bytes != null) {
      return Image.memory(_bytes!, fit: BoxFit.cover);
    }
    return Container(
      color: cs.surfaceContainerHighest,
      child: Icon(LucideIcons.fileText, size: IconSize.lg, color: cs.error),
    );
  }
}

class JobImageGallery extends StatefulWidget {
  final List<String> attachmentUrls;
  final int imageIndex;
  final ValueChanged<int> onPageChanged;
  final String title;
  final String organization;

  const JobImageGallery({
    super.key,
    required this.attachmentUrls,
    required this.imageIndex,
    required this.onPageChanged,
    required this.title,
    required this.organization,
  });

  @override
  State<JobImageGallery> createState() => _JobImageGalleryState();
}

class _JobImageGalleryState extends State<JobImageGallery> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.imageIndex);
  }

  @override
  void didUpdateWidget(JobImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageIndex != oldWidget.imageIndex) {
      _pageController.animateToPage(
        widget.imageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');

  String _resolveUrl(String url) => ApiEndpoints.resolveImageUrl(url);

  void _openFullPage(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (c, a, s) => FullPageMediaViewer(
          urls: widget.attachmentUrls,
          isPdfList: widget.attachmentUrls.map(_isPdf).toList(),
          initialIndex: index,
          title: widget.title,
          organization: widget.organization,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.attachmentUrls.length,
                onPageChanged: widget.onPageChanged,
                itemBuilder: (context, i) {
                  final url = widget.attachmentUrls[i];
                  final pdf = _isPdf(url);
                  return GestureDetector(
                    onTap: () => _openFullPage(context, i),
                    child: Hero(
                      tag: url,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (pdf)
                            AppPdfViewer(url: _resolveUrl(url))
                          else
                            Container(
                              color: cs.surfaceContainerHighest,
                              child: InteractiveViewer(
                                child: CachedNetworkImage(
                                  imageUrl: _resolveUrl(url),
                                  fit: BoxFit.contain,
                                  placeholder: (c, u) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (c, e, s) => Icon(
                                    LucideIcons.file,
                                    size: IconSize.xxl,
                                    color: cs.outline,
                                  ),
                                ),
                              ),
                            ),
                          if (pdf)
                            Positioned(
                              top: Spacing.sm,
                              right: Spacing.sm,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.sm,
                                  vertical: Spacing.xxs,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.errorContainer,
                                  borderRadius: RadiusToken.circular(RadiusToken.xs),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.fileText,
                                      size: IconSize.sm,
                                      color: cs.error,
                                    ),
                                    const SizedBox(width: Spacing.xxs),
                                    Text(
                                      'PDF',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: cs.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: Spacing.sm,
                            right: Spacing.sm,
                            child: Container(
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest.withValues(alpha: 0.85),
                                borderRadius: RadiusToken.circular(RadiusToken.full),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  LucideIcons.download,
                                  size: IconSize.md,
                                  color: cs.onSurface,
                                ),
                                tooltip: 'Download',
                                onPressed: () => _downloadFile(context, i),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn();
                },
              ),
              if (widget.attachmentUrls.length > 1)
                Positioned(
                  bottom: Spacing.xl,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.attachmentUrls.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.imageIndex == i
                              ? cs.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: widget.imageIndex == i
                                ? cs.primary
                                : cs.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(),
        if (widget.attachmentUrls.length > 1)
          Container(
            height: 72,
            margin: const EdgeInsets.only(top: Spacing.sm),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
              itemCount: widget.attachmentUrls.length,
              itemBuilder: (context, i) {
                final url = widget.attachmentUrls[i];
                final pdf = _isPdf(url);
                return GestureDetector(
                  onTap: () {
                    widget.onPageChanged(i);
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: Spacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: RadiusToken.circular(RadiusToken.md),
                      border: Border.all(
                        color: widget.imageIndex == i
                            ? cs.primary
                            : cs.outlineVariant,
                        width: widget.imageIndex == i ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (pdf)
                          PdfThumbnailWidget(url: _resolveUrl(url))
                        else
                          CachedNetworkImage(
                            imageUrl: _resolveUrl(url),
                            fit: BoxFit.cover,
                            placeholder: (c, u) =>
                                Container(color: cs.surfaceContainerHighest),
                          ),
                        if (pdf)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: cs.errorContainer,
                                borderRadius: RadiusToken.circular(2),
                              ),
                              child: Icon(
                                LucideIcons.fileText,
                                size: 10,
                                color: cs.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ).animate().scale(delay: (100 * i).ms);
              },
            ),
          ),
      ],
    );
  }

  Future<void> _downloadFile(BuildContext context, int index) async {
    final url = _resolveUrl(widget.attachmentUrls[index]);
    final isPdfFile = _isPdf(widget.attachmentUrls[index]);
    final ext = isPdfFile ? 'pdf' : 'jpg';
    final fileName =
        '${widget.title.replaceAll(RegExp(r'[^\w]'), '_')}_$index.$ext';
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.data);
      if (context.mounted) {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(file.path)], text: widget.title),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download error: $e')),
        );
      }
    }
  }
}