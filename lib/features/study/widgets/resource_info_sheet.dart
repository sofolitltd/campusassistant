import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/features/study/data/models/content_model.dart';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/resource/presentation/widgets/user_profile_dialog.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/utils/date_formatters.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class ResourceInfoSheet extends ConsumerWidget {
  final ContentModel contentModel;
  final ScrollController scrollController;

  const ResourceInfoSheet({
    super.key,
    required this.contentModel,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchesAsync = ref.watch(
      batchesByDepartmentProvider(contentModel.departmentId),
    );

    final batchNames = batchesAsync.when(
      data: (batches) {
        return contentModel.batches
            .map((id) {
              final batch = batches.where((b) => b.id == id).firstOrNull;
              return batch?.name ?? id;
            })
            .join(', ');
      },
      loading: () => 'Loading...',
      error: (_, _) => contentModel.batches.join(', '),
    );

    final metadata = contentModel.metadata ?? {};

    // Type specific extracted fields. Notes in this app store the teacher/creator
    // reference under `subtitle` (with an optional `subtitle_type` of 'Creator'),
    // not under `creator`/`teacher` — check all of them.
    final creator =
        metadata['subtitle']?.toString() ??
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
    final downloads = metadata['downloadCount']?.toString() ?? '--';
    final views = metadata['viewCount']?.toString() ?? '--';
    final ratingAvg = metadata['ratingAvg']?.toString() ?? '--';
    final pageCount = metadata['pageCount']?.toString() ?? '--';

    String fileSizeStr = '--';
    if (metadata['fileSizeBytes'] != null) {
      final bytes = int.tryParse(metadata['fileSizeBytes'].toString()) ?? 0;
      if (bytes > 1024 * 1024) {
        fileSizeStr = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      } else if (bytes > 1024) {
        fileSizeStr = '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        fileSizeStr = '$bytes B';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: ListView(
        controller: scrollController,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: Spacing.lg),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: context.colors.borderStrong,
                borderRadius: BorderRadius.circular(RadiusToken.xs),
              ),
            ),
          ),

          // Header
          Row(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AccentToken.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Center(
                  child: Icon(
                    _getIconForType(contentModel.contentType),
                    size: 30,
                    color: context.colors.primary,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      contentModel.contentTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.info,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                      ),
                      child: Text(
                        contentModel.contentType.toUpperCase(),
                        style: TextStyle(
                          fontSize: FontSizeToken.xxs,
                          fontWeight: .bold,
                          color: context.colors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          const Divider(),

          // Common Fields
          _buildSectionTitle(context, 'Basic Information'),
          _buildInfoRow(
            context,
            LucideIcons.user,
            'Uploaded By',
            contentModel.uploader,
            onTap: contentModel.creatorId != null
                ? () => showUserProfileDialog(
                    context,
                    userId: contentModel.creatorId,
                    fallbackName: contentModel.uploader,
                  )
                : null,
          ),
          _buildInfoRow(
            context,
            LucideIcons.calendar,
            'Upload Date',
            formatDateStringDdMmYyyy(contentModel.uploadDate),
          ),

          _buildInfoRow(
            context,
            LucideIcons.bookType,
            'Course Code',
            contentModel.courseCode,
          ),
          _buildInfoRow(
            context,
            LucideIcons.fileText,
            'Type',
            contentModel.contentSubtitleType,
          ),
          _buildInfoRow(
            context,
            LucideIcons.tag,
            'Subtitle',
            contentModel.contentSubtitle,
          ),
          _buildInfoRow(
            context,
            LucideIcons.users,
            'Target Batches',
            batchNames,
          ),

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(context, 'Type-Specific Details'),

          if (contentModel.contentType.toLowerCase().contains('note')) ...[
            _buildInfoRow(
              context,
              LucideIcons.bookOpen,
              'Lesson No',
              contentModel.lessonNo.toString(),
            ),
            _buildInfoRow(
              context,
              LucideIcons.graduationCap,
              'Creator',
              creator,
            ),
            _buildInfoRow(context, LucideIcons.bookOpen, 'Chapter', chapter),
          ] else if (contentModel.contentType.toLowerCase().contains(
            'book',
          )) ...[
            _buildInfoRow(context, LucideIcons.user, 'Author', author),
            _buildInfoRow(
              context,
              LucideIcons.building,
              'Publisher',
              publisher,
            ),
            _buildInfoRow(context, LucideIcons.book, 'Edition', edition),
          ] else if (contentModel.contentType.toLowerCase().contains(
            'question',
          )) ...[
            _buildInfoRow(
              context,
              LucideIcons.fileSpreadsheet,
              'Exam Type',
              examType,
            ),
          ] else if (contentModel.contentType.toLowerCase().contains(
            'syllabus',
          )) ...[
            _buildInfoRow(
              context,
              LucideIcons.calendar,
              'Academic Year',
              academicYear,
            ),
          ],

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(context, 'Stats'),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  LucideIcons.download,
                  'Downloads',
                  downloads,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _buildStatCard(context, LucideIcons.eye, 'Views', views),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  LucideIcons.hardDrive,
                  'File Size',
                  fileSizeStr,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _buildStatCard(
                  context,
                  LucideIcons.layers,
                  'Pages',
                  pageCount,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          _buildStatCard(context, LucideIcons.star, 'Rating', ratingAvg),

          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: .bold,
          color: context.colors.text,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Icon(icon, size: 18, color: context.colors.textSubtle),
            const SizedBox(width: Spacing.md),
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : 'Not provided',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: .w500,
                  color: onTap != null
                      ? context.colors.primary
                      : context.colors.text,
                ),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: Spacing.xs),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: context.colors.textSubtle,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colors.primary),
          const SizedBox(width: Spacing.sm),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: FontSizeToken.xs,
                  color: context.colors.textMuted,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: .bold,
                  fontSize: FontSizeToken.base,
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
