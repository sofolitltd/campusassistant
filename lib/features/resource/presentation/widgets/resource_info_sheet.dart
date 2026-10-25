import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/resource/domain/entities/resource.dart';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/resource/presentation/widgets/user_profile_dialog.dart';
import '/core/network/api_endpoints.dart';
import '/core/providers/is_pro_provider.dart';
import '/core/providers/perks_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/reward/presentation/widgets/reward_cost_indicator.dart';
import '/routes/app_route.dart';
import '/utils/date_formatters.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/widgets/app_network_image.dart';

class ResourceInfoSheet extends ConsumerStatefulWidget {
  final Resource resource;
  final ScrollController scrollController;

  /// Whether the file is already saved locally — gates which quick actions
  /// show, mirroring the popup menu on the resource/downloaded cards.
  final bool isDownloaded;
  final VoidCallback? onDownload;
  final VoidCallback? onSaveToDownloads;
  final VoidCallback? onShare;
  final VoidCallback? onDeleteLocally;
  final bool isBookmarked;
  final VoidCallback? onBookmarkToggle;

  const ResourceInfoSheet({
    super.key,
    required this.resource,
    required this.scrollController,
    this.isDownloaded = false,
    this.onDownload,
    this.onSaveToDownloads,
    this.onShare,
    this.onDeleteLocally,
    this.isBookmarked = false,
    this.onBookmarkToggle,
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
  int? _pendingRating;
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
        setState(() {
          _yourRating = yourRating;
          _pendingRating = yourRating;
        });
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
          _pendingRating = r.yourRating;
        });
        Fluttertoast.showToast(msg: 'Rating submitted');
      },
    );
    setState(() => _submittingRating = false);
  }

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;
    final scrollController = widget.scrollController;
    final isProContent = resource.accessLevel == 'pro';
    final isProUser = ref.watch(isProUserProvider);
    final isCoinFree = ref.watch(isCoinFreeProvider);
    final batchesAsync = ref.watch(
      batchesByDepartmentProvider(resource.departmentId),
    );

    final batchNameList = batchesAsync.when(
      data: (batches) {
        return resource.batches.map((id) {
          final batch = batches.where((b) => b.id == id).firstOrNull;
          return batch?.name ?? id;
        }).toList();
      },
      loading: () => const ['Loading...'],
      error: (_, _) => resource.batches,
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
        : 'N/A';
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
          // Drag handle + close button
          Row(
            children: [
              const SizedBox(width: 32),
              Expanded(
                child: Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: context.colors.borderStrong,
                      borderRadius: BorderRadius.circular(RadiusToken.xs),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),

          // Header
          Row(
            crossAxisAlignment: .start,
            children: [
              GestureDetector(
                // Thumbnail → full-screen viewer (pinch-to-zoom); only
                // tappable when there is an actual image to show.
                onTap: resource.thumbnailUrl.isNotEmpty
                    ? () => context.pushNamed(
                        AppRoute.imageViewer.name,
                        queryParameters: {
                          'title': resource.title,
                          'time': resource.createdAt != null
                              ? formatDateDdMmYyyy(resource.createdAt!)
                              : '',
                          'image': resource.thumbnailUrl,
                        },
                      )
                    : null,
                child: Container(
                  width: 110,
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                    border: Border.all(
                      color: context.colors.borderStrong,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusToken.sm - 1),
                    child: resource.thumbnailUrl.isNotEmpty
                        ? AppNetworkImage(
                            ApiEndpoints.resolveImageUrl(resource.thumbnailUrl),
                            fit: .cover,
                            placeholder: (context) => Center(
                              child: Icon(
                                _getIconForType(resource.type),
                                size: 44,
                                color: context.colors.primary,
                              ),
                            ),
                            errorBuilder: (context, _, _) => Center(
                              child: Icon(
                                _getIconForType(resource.type),
                                size: 44,
                                color: context.colors.primary,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              _getIconForType(resource.type),
                              size: 44,
                              color: context.colors.primary,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: SizedBox(
                  height: 128,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        resource.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: .bold),
                      ),
                      const SizedBox(height: Spacing.xs),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: .stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: context.colors.infoSubtle,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.full,
                                ),
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
                            const SizedBox(width: Spacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isProContent
                                    ? context.colors.warning.withValues(
                                        alpha: .15,
                                      )
                                    : context.colors.surfaceAlt,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.full,
                                ),
                                border: isProContent
                                    ? null
                                    : Border.all(color: context.colors.border),
                              ),
                              child: Row(
                                mainAxisSize: .min,
                                children: [
                                  if (isProContent) ...[
                                    Icon(
                                      LucideIcons.crown,
                                      size: 12,
                                      color: context.colors.warning,
                                    ),
                                    const SizedBox(width: Spacing.xs),
                                  ],
                                  Text(
                                    isProContent ? 'PRO' : 'BASIC',
                                    style: TextStyle(
                                      fontSize: FontSizeToken.xxs,
                                      fontWeight: .bold,
                                      color: isProContent
                                          ? context.colors.warning
                                          : context.colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            if (isCoinFree)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.sm,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.colors.successSubtle,
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.full,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: .min,
                                  children: [
                                    Icon(
                                      LucideIcons.checkCheck,
                                      size: 12,
                                      color: context.colors.success,
                                    ),
                                    const SizedBox(width: Spacing.xs),
                                    Text(
                                      isProUser ? 'FREE WITH PRO' : 'FREE NOW',
                                      style: TextStyle(
                                        fontSize: FontSizeToken.xxs,
                                        fontWeight: .bold,
                                        color: context.colors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              RewardCostIndicator(
                                resourceId: resource.id,
                                fileSizeBytes: resource.fileSizeBytes,
                              ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _buildQuickActions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
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
            batchNameList.join(', '),
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
          _buildSectionTitle(context, 'Statistics'),
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
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _buildStatCard(LucideIcons.star, 'Rating', ratingAvg),
              ),
            ],
          ),

          const SizedBox(height: Spacing.lg),
          _buildSectionTitle(
            context,
            'Rate This Resource',
            bottomSpacing: Spacing.xs,
          ),
          Row(
            children: [
              ...List.generate(5, (i) {
                final starValue = i + 1;
                final filled =
                    _pendingRating != null && starValue <= _pendingRating!;
                return IconButton(
                  onPressed: _submittingRating
                      ? null
                      : () => setState(() => _pendingRating = starValue),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: filled
                        ? AccentToken.amber
                        : context.colors.textSubtle,
                  ),
                );
              }),
              const Spacer(),
              if (_pendingRating != null && _pendingRating != _yourRating)
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: _submittingRating
                      ? null
                      : () => _submitRating(_pendingRating!),
                  child: _submittingRating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _yourRating == null
                              ? 'Submit Rating'
                              : 'Update Rating',
                          style: const TextStyle(fontSize: FontSizeToken.sm),
                        ),
                )
              else if (_yourRating != null)
                Text(
                  'You rated $_yourRating star${_yourRating == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textMuted,
                  ),
                )
              else
                Text(
                  'Tap a star to rate',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textSubtle,
                  ),
                ),
            ],
          ),

          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = <Widget>[
      if (widget.onBookmarkToggle != null)
        _quickAction(
          context,
          icon: widget.isBookmarked
              ? LucideIcons.bookmarkCheck
              : LucideIcons.bookmark,
          label: widget.isBookmarked ? 'Saved' : 'Bookmark',
          onPressed: widget.onBookmarkToggle!,
          color: widget.isBookmarked ? context.colors.primary : null,
        ),
      if (widget.onDownload != null)
        _quickAction(
          context,
          icon: widget.isDownloaded
              ? LucideIcons.fileText
              : LucideIcons.download,
          label: widget.isDownloaded ? 'Open' : 'Download',
          onPressed: widget.onDownload!,
        ),
      if (widget.isDownloaded && widget.onSaveToDownloads != null)
        _quickAction(
          context,
          icon: LucideIcons.cloudDownload,
          label: 'Save',
          onPressed: widget.onSaveToDownloads!,
        ),
      if (widget.onShare != null)
        _quickAction(
          context,
          icon: LucideIcons.share2,
          label: 'Share',
          onPressed: widget.onShare!,
        ),
      if (widget.isDownloaded && widget.onDeleteLocally != null)
        _quickAction(
          context,
          icon: LucideIcons.trash2,
          label: 'Delete',
          onPressed: widget.onDeleteLocally!,
          color: context.colors.danger,
        ),
    ];

    if (actions.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: Spacing.md, children: actions);
  }

  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final actionColor = color ?? context.colors.textMuted;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onPressed();
      },
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: actionColor),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.xxs,
              color: context.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    double bottomSpacing = Spacing.md,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontWeight: .bold, color: context.colors.text),
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
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: context.colors.textMuted),
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
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(icon, size: 20, color: context.colors.primary),
          const SizedBox(width: Spacing.md),
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
