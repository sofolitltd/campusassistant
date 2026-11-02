import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/presentation/providers/program_provider.dart';

/// A batch's 16:9 cover photo, or — when it has none, or it fails to load —
/// a teal panel with the batch number ([showNumber] false leaves it plain,
/// for when text is laid over it).
///
/// Decodes at the size it's drawn (width × device pixel ratio), not the
/// upload's 1280px, so a grid of covers stays light on memory.
class BatchCoverImage extends StatelessWidget {
  const BatchCoverImage({
    super.key,
    required this.batch,
    this.showNumber = true,
  });

  final Batch batch;
  final bool showNumber;

  @override
  Widget build(BuildContext context) {
    final url = ApiEndpoints.resolveImageUrl(batch.imageUrl);
    final panel = _BatchNumberPanel(batch: batch, showNumber: showNumber);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: url.isEmpty
          ? panel
          : LayoutBuilder(
              builder: (context, constraints) {
                final dpr = MediaQuery.devicePixelRatioOf(context);
                final width = constraints.maxWidth;
                return CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  memCacheWidth: width.isFinite ? (width * dpr).round() : null,
                  fadeInDuration: const Duration(milliseconds: 150),
                  placeholder: (_, _) => panel,
                  errorWidget: (_, _, _) => panel,
                );
              },
            ),
    );
  }
}

class _BatchNumberPanel extends StatelessWidget {
  const _BatchNumberPanel({required this.batch, required this.showNumber});

  final Batch batch;
  final bool showNumber;

  @override
  Widget build(BuildContext context) {
    final number = batchNumber(batch);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.colors.primary, context.colors.primaryPressed],
        ),
      ),
      child: !showNumber
          ? null
          : Center(
              child: Text(
                number > 0 ? '$number' : batchShortName(batch),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: .w900,
                  color: context.colors.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ),
    );
  }
}

/// A batch tile for the students page: cover on top, then just the name and
/// the student count — the grid is narrow, the rest is on the batch page.
class BatchCoverCard extends StatelessWidget {
  const BatchCoverCard({
    super.key,
    required this.batch,
    required this.studentCount,
    required this.isMine,
    required this.onTap,
  });

  final Batch batch;
  final int? studentCount;
  final bool isMine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = studentCount;
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(RadiusToken.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.lg),
            border: Border.all(
              color: isMine ? context.colors.primary : context.colors.border,
              width: isMine ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Stack(
                children: [
                  BatchCoverImage(batch: batch),
                  if (isMine)
                    Positioned(
                      top: Spacing.sm,
                      left: Spacing.sm,
                      child: _Pill(
                        label: 'My batch',
                        background: context.colors.primary,
                        foreground: context.colors.onPrimary,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.sm,
                  Spacing.md,
                  Spacing.md,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      batch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: FontSizeToken.base,
                        fontWeight: .w700,
                        color: context.colors.text,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      count == null ? ' ' : '$count students',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: FontSizeToken.xs,
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The batch page's header: the cover photo with the batch's details laid
/// over its lower part — name, sessions, student counts and whether the
/// batch is still on campus. Grows past 16:9 if the text needs the room
/// (large font settings) instead of overflowing.
class BatchCoverHeader extends StatelessWidget {
  const BatchCoverHeader({
    super.key,
    required this.batch,
    required this.total,
    required this.irregular,
  });

  final Batch batch;

  /// Null while loading (or offline); the counts are then left out.
  final int? total;
  final int? irregular;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sessions = batch.sessions.map((s) => s.name).join(' · ');
    final total = this.total;
    final irregular = this.irregular;
    final chipBg = colors.onScrim.withValues(alpha: 0.18);

    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusToken.lg),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned.fill(
              child: BatchCoverImage(batch: batch, showNumber: false),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxWidth * 9 / 16,
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.xxxl,
                Spacing.lg,
                Spacing.lg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.25, 1],
                  colors: [
                    colors.scrim.withValues(alpha: 0),
                    colors.scrim.withValues(alpha: 0.75),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    batch.name,
                    style: TextStyle(
                      fontSize: FontSizeToken.xxl,
                      fontWeight: .w800,
                      color: colors.onScrim,
                    ),
                  ),
                  if (sessions.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      'Session $sessions',
                      style: TextStyle(
                        fontSize: FontSizeToken.sm,
                        color: colors.onScrim.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                  const SizedBox(height: Spacing.sm),
                  Wrap(
                    spacing: Spacing.xs,
                    runSpacing: Spacing.xs,
                    children: [
                      if (total != null)
                        _Pill(
                          label: '$total students',
                          background: chipBg,
                          foreground: colors.onScrim,
                        ),
                      if (total != null && irregular != null) ...[
                        _Pill(
                          label: '${(total - irregular).clamp(0, total)} regular',
                          background: chipBg,
                          foreground: colors.onScrim,
                        ),
                        _Pill(
                          label: '$irregular irregular',
                          background: chipBg,
                          foreground: colors.onScrim,
                        ),
                      ],
                      batch.isStudying
                          ? _Pill(
                              label: 'On campus',
                              background: colors.success,
                              foreground: colors.onSuccess,
                            )
                          : _Pill(
                              label: 'Graduated',
                              background: colors.warning,
                              foreground: colors.onWarning,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(RadiusToken.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: FontSizeToken.xs,
          fontWeight: .w700,
          color: foreground,
        ),
      ),
    );
  }
}
