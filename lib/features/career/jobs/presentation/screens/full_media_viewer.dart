import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/core/network/api_endpoints.dart';
import '../widgets/app_pdf_viewer.dart';

class FullPageMediaViewer extends StatefulWidget {
  final List<String> urls;
  final List<bool> isPdfList;
  final int initialIndex;
  final String title;
  final String organization;

  const FullPageMediaViewer({
    super.key,
    required this.urls,
    required this.isPdfList,
    required this.initialIndex,
    required this.title,
    required this.organization,
  });

  @override
  State<FullPageMediaViewer> createState() => _FullPageMediaViewerState();
}

class _FullPageMediaViewerState extends State<FullPageMediaViewer> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _downloadCurrentFile(BuildContext context) async {
    final url = ApiEndpoints.resolveImageUrl(widget.urls[_currentIndex]);
    final ext = widget.isPdfList[_currentIndex] ? 'pdf' : 'jpg';
    final fileName =
        '${widget.title.replaceAll(RegExp(r'[^\w]'), '_')}_$_currentIndex.$ext';
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.data);
      if (!mounted) return;
      if (!context.mounted) return;
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: widget.title),
      );
    } catch (e) {
      if (!mounted) return;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: cs.onSurface),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: cs.onSurface),
            tooltip: 'Download',
            onPressed: () => _downloadCurrentFile(context),
          ),
        ],
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, height: 1),
            ),
            Text(
              widget.organization,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.urls.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.urls.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == i
                            ? cs.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: _currentIndex == i
                              ? cs.primary
                              : cs.onSurfaceVariant.withValues(alpha: 0.4),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.urls.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, i) {
                  final isPdf = widget.isPdfList[i];
                  final url = widget.urls[i];
                  if (isPdf) {
                    return AppPdfViewer(url: ApiEndpoints.resolveImageUrl(url));
                  }
                  return Center(
                    child: InteractiveViewer(
                      child: CachedNetworkImage(
                        imageUrl: ApiEndpoints.resolveImageUrl(url),
                        fit: BoxFit.contain,
                        placeholder: (c, u) =>
                            const CupertinoActivityIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
