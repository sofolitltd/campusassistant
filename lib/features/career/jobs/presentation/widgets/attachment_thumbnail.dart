import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/core/network/api_endpoints.dart';
import 'job_image_gallery.dart' show PdfThumbnailWidget;

/// A card-sized leading thumbnail for a job/circular: the first attachment
/// (image, or a PDF's first page via [PdfThumbnailWidget]) if one exists,
/// otherwise [fallbackIcon] — same fallback every card already showed before
/// attachments were wired up, so cards with nothing attached look unchanged.
class AttachmentThumbnail extends StatelessWidget {
  final List<String> attachmentUrls;
  final double size;
  final IconData fallbackIcon;
  final Color background;
  final Color foreground;

  const AttachmentThumbnail({
    super.key,
    required this.attachmentUrls,
    required this.size,
    required this.fallbackIcon,
    required this.background,
    required this.foreground,
  });

  Widget _fallback() {
    return Container(
      width: size,
      height: 80,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(fallbackIcon, color: foreground),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (attachmentUrls.isEmpty) return _fallback();

    final url = attachmentUrls.first;
    final isPdf = url.toLowerCase().endsWith('.pdf');
    final resolvedUrl = ApiEndpoints.resolveImageUrl(url);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: isPdf
            ? PdfThumbnailWidget(url: resolvedUrl)
            : CachedNetworkImage(
                imageUrl: resolvedUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: background),
                errorWidget: (context, url, error) => _fallback(),
              ),
      ),
    );
  }
}
