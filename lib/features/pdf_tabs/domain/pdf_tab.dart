/// A single open-PDF tab in the Chrome-style tab strip ([PdfTabsPage]).
///
/// [url] is the stable identity used to dedupe/activate/close tabs — it's
/// the same key [PdfViewerPage] already uses to persist last-read-page
/// progress, so reopening a resource always resolves to the same tab.
class PdfTab {
  final String resourceId;
  final String filePath;
  final String url;
  final String title;
  final String? thumbnailUrl;
  final String? courseCode;
  final int? lessonNo;

  const PdfTab({
    required this.resourceId,
    required this.filePath,
    required this.url,
    required this.title,
    this.thumbnailUrl,
    this.courseCode,
    this.lessonNo,
  });
}
