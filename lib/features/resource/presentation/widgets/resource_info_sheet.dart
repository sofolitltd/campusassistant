import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class ResourceInfoSheet extends ConsumerWidget {
  final Resource resource;
  final ScrollController scrollController;

  const ResourceInfoSheet({
    super.key,
    required this.resource,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchesAsync = ref.watch(
      batchesByDepartmentProvider(resource.departmentId),
    );

    final batchNames = batchesAsync.when(
      data: (batches) {
        return resource.batches
            .map((id) {
              final batch = batches.where((b) => b.id == id).firstOrNull;
              return batch?.name ?? id;
            })
            .join(', ');
      },
      loading: () => 'Loading...',
      error: (_, _) => resource.batches.join(', '),
    );

    final metadata = resource.metadata;

    // Type specific extracted fields
    final creator =
        metadata['creator']?.toString() ??
        metadata['teacher']?.toString() ??
        'N/A';
    final chapter = metadata['chapter']?.toString() ?? 'N/A';
    final author = metadata['author']?.toString() ?? 'N/A';
    final publisher = metadata['publisher']?.toString() ?? 'N/A';
    final edition = metadata['edition']?.toString() ?? 'N/A';
    final examType = metadata['exam_type']?.toString() ?? 'N/A';
    final academicYear = metadata['academic_year']?.toString() ?? 'N/A';

    // Stats
    final downloads = resource.downloadCount.toString();
    final views = resource.viewCount.toString();
    final ratingAvg = resource.ratingAvg.toStringAsFixed(1);
    final pageCount = resource.pageCount.toString();

    String fileSizeStr = '--';
    final bytes = resource.fileSizeBytes;
    if (bytes > 1024 * 1024) {
      fileSizeStr = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes > 1024) {
      fileSizeStr = '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes > 0) {
      fileSizeStr = '$bytes B';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView(
        controller: scrollController,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: resource.thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: resource.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, _) => Center(
                          child: Icon(
                            _getIconForType(resource.type),
                            size: 28,
                            color: Colors.teal,
                          ),
                        ),
                        errorWidget: (context, _, _) => Center(
                          child: Icon(
                            _getIconForType(resource.type),
                            size: 28,
                            color: Colors.teal,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          _getIconForType(resource.type),
                          size: 28,
                          color: Colors.teal,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                      ),
                      child: Text(
                        resource.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),

          // Common Fields
          _buildSectionTitle(context, 'Basic Information'),
          _buildInfoRow(LucideIcons.user, 'Uploaded By', resource.uploaderName),
          _buildInfoRow(
            LucideIcons.calendar,
            'Upload Date',
            resource.createdAt != null
                ? resource.createdAt!.toString().split(' ')[0]
                : 'N/A',
          ),

          _buildInfoRow(
            LucideIcons.bookType,
            'Course Code',
            resource.courseCode,
          ),
          _buildInfoRow(LucideIcons.tag, 'Description', resource.description),
          _buildInfoRow(LucideIcons.users, 'Target Batches', batchNames),

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(context, 'Type-Specific Details'),

          if (resource.type.toLowerCase().contains('note')) ...[
            _buildInfoRow(
              LucideIcons.bookOpen,
              'Lesson No',
              resource.lessonNo.toString(),
            ),
            _buildInfoRow(LucideIcons.graduationCap, 'Creator', creator),
            _buildInfoRow(LucideIcons.bookOpen, 'Chapter', chapter),
          ] else if (resource.type.toLowerCase().contains('book')) ...[
            _buildInfoRow(LucideIcons.user, 'Author', author),
            _buildInfoRow(LucideIcons.building, 'Publisher', publisher),
            _buildInfoRow(LucideIcons.book, 'Edition', edition),
          ] else if (resource.type.toLowerCase().contains('question')) ...[
            _buildInfoRow(LucideIcons.fileSpreadsheet, 'Exam Type', examType),
          ] else if (resource.type.toLowerCase().contains('syllabus')) ...[
            _buildInfoRow(LucideIcons.calendar, 'Academic Year', academicYear),
          ],

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(context, 'Stats'),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  LucideIcons.download,
                  'Downloads',
                  downloads,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard(LucideIcons.eye, 'Views', views)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  LucideIcons.hardDrive,
                  'File Size',
                  fileSizeStr,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(LucideIcons.layers, 'Pages', pageCount),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStatCard(LucideIcons.star, 'Rating', ratingAvg),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not provided',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    final t = type.toLowerCase();
    if (t.contains('note')) return LucideIcons.fileText;
    if (t.contains('book')) return LucideIcons.bookOpen;
    if (t.contains('question')) return LucideIcons.fileSpreadsheet;
    if (t.contains('syllabus')) return LucideIcons.clipboardList;
    return LucideIcons.file;
  }
}
