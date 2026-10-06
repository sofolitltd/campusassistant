import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/resource/presentation/widgets/user_profile_dialog.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/utils/date_formatters.dart';
import '/core/theme/tokens/app_font_size.dart';

class ResourceInfoSheet extends ConsumerStatefulWidget {
  final Resource resource;
  final ScrollController scrollController;

  const ResourceInfoSheet({
    super.key,
    required this.resource,
    required this.scrollController,
  });

  @override
  ConsumerState<ResourceInfoSheet> createState() => _ResourceInfoSheetState();
}

class _ResourceInfoSheetState extends ConsumerState<ResourceInfoSheet> {
  late double _ratingAvg = widget.resource.ratingAvg;
  late int _ratingCount = widget.resource.ratingCount;
  late int _downloadCount = widget.resource.downloadCount;
  late int _viewCount = widget.resource.viewCount;
  int? _yourRating;
  bool _submittingRating = false;

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  // widget.resource is a snapshot from whichever list fetch produced it, so
  // download/view/rating counts and the user's own rating can be stale by
  // the time this sheet is opened — refresh them from the server on open.
  Future<void> _refreshStats() async {
    final repo = ref.read(resourceRepositoryProvider);

    final resourceResult = await repo.getResourceById(widget.resource.id);
    if (mounted) {
      resourceResult.fold((_) {}, (fresh) {
        setState(() {
          _downloadCount = fresh.downloadCount;
          _viewCount = fresh.viewCount;
          _ratingAvg = fresh.ratingAvg;
          _ratingCount = fresh.ratingCount;
        });
      });
    }

    final ratingResult = await repo.getMyRating(widget.resource.id);
    if (mounted) {
      ratingResult.fold((_) {}, (yourRating) {
        setState(() => _yourRating = yourRating);
      });
    }
  }

  Future<void> _submitRating(int stars) async {
    if (_submittingRating) return;
    setState(() => _submittingRating = true);

    final result = await ref
        .read(resourceRepositoryProvider)
        .rateResource(widget.resource.id, stars);

    if (!mounted) return;
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: 'Failed to submit rating');
      },
      (r) {
        setState(() {
          _ratingAvg = r.ratingAvg;
          _ratingCount = r.ratingCount;
          _yourRating = r.yourRating;
        });
      },
    );
    setState(() => _submittingRating = false);
  }

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;
    final scrollController = widget.scrollController;
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
    final downloads = _downloadCount.toString();
    final views = _viewCount.toString();
    final ratingAvg = _ratingCount > 0
        ? '${_ratingAvg.toStringAsFixed(1)} ($_ratingCount)'
        : 'No ratings yet';
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
                width: 70,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                  border: Border.all(
                    color: context.colors.borderStrong,
                    width: 1,
                  ),
                ),
                clipBehavior: .antiAlias,
                child: resource.thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: ApiEndpoints.resolveImageUrl(
                          resource.thumbnailUrl,
                        ),
                        fit: .cover,
                        placeholder: (context, _) => Center(
                          child: Icon(
                            _getIconForType(resource.type),
                            size: 28,
                            color: context.colors.primary,
                          ),
                        ),
                        errorWidget: (context, _, _) => Center(
                          child: Icon(
                            _getIconForType(resource.type),
                            size: 28,
                            color: context.colors.primary,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          _getIconForType(resource.type),
                          size: 28,
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
                      resource.title,
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
                        resource.type.toUpperCase(),
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
            resource.creator ?? 'N/A',
            onTap: resource.creatorId != null
                ? () => showUserProfileDialog(
                    context,
                    userId: resource.creatorId,
                    fallbackName: resource.creator ?? '',
                  )
                : null,
          ),
          _buildInfoRow(
            context,
            LucideIcons.calendar,
            'Upload Date',
            resource.createdAt != null
                ? formatDateDdMmYyyy(resource.createdAt!)
                : 'N/A',
          ),

          _buildInfoRow(
            context,
            LucideIcons.bookType,
            'Course Code',
            resource.courseCode,
          ),
          _buildInfoRow(
            context,
            LucideIcons.tag,
            'Description',
            resource.description,
          ),
          _buildInfoRow(
            context,
            LucideIcons.users,
            'Target Batches',
            batchNames,
          ),

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(context, 'Type-Specific Details'),

          if (resource.type.toLowerCase().contains('note')) ...[
            _buildInfoRow(
              context,
              LucideIcons.bookOpen,
              'Lesson No',
              resource.lessonNo.toString(),
            ),
            _buildInfoRow(
              context,
              LucideIcons.graduationCap,
              'Creator',
              creator,
            ),
            _buildInfoRow(context, LucideIcons.bookOpen, 'Chapter', chapter),
          ] else if (resource.type.toLowerCase().contains('book')) ...[
            _buildInfoRow(context, LucideIcons.user, 'Author', author),
            _buildInfoRow(
              context,
              LucideIcons.building,
              'Publisher',
              publisher,
            ),
            _buildInfoRow(context, LucideIcons.book, 'Edition', edition),
          ] else if (resource.type.toLowerCase().contains('question')) ...[
            _buildInfoRow(
              context,
              LucideIcons.fileSpreadsheet,
              'Exam Type',
              examType,
            ),
          ] else if (resource.type.toLowerCase().contains('syllabus')) ...[
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
                  LucideIcons.download,
                  'Downloads',
                  downloads,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(child: _buildStatCard(LucideIcons.eye, 'Views', views)),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  LucideIcons.hardDrive,
                  'File Size',
                  fileSizeStr,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _buildStatCard(LucideIcons.layers, 'Pages', pageCount),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          _buildStatCard(LucideIcons.star, 'Rating', ratingAvg),

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(context, 'Rate This Resource'),
          Row(
            mainAxisAlignment: .center,
            children: List.generate(5, (i) {
              final starValue = i + 1;
              final filled = _yourRating != null && starValue <= _yourRating!;
              return IconButton(
                onPressed: _submittingRating
                    ? null
                    : () => _submitRating(starValue),
                icon: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: filled
                      ? context.colors.warning
                      : context.colors.textSubtle,
                ),
              );
            }),
          ),

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

  Widget _buildStatCard(IconData icon, String label, String value) {
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
