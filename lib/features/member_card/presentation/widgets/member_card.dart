import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

/// Shape of the exported image. Both share one logical width
/// ([MemberCard.logicalWidth]) so capture is always 1080px wide.
enum MemberCardFormat {
  story(label: 'Story', aspectRatio: 9 / 16),
  square(label: 'Post', aspectRatio: 1);

  const MemberCardFormat({required this.label, required this.aspectRatio});
  final String label;
  final double aspectRatio;
}

enum MemberType {
  student('Student'),
  alumni('Alumni');

  const MemberType(this.label);
  final String label;
}

/// Everything printed on the card. Deliberately excludes phone/email — the
/// card is made to be posted publicly.
class MemberCardData {
  const MemberCardData({
    required this.name,
    required this.memberType,
    required this.universityName,
    required this.departmentName,
    required this.installUrl,
    this.photoUrl,
    this.batch,
    this.session,
    this.studentId,
    this.referralCode,
  });

  final String name;
  final MemberType memberType;
  final String universityName;
  final String departmentName;
  final String installUrl;
  final String? photoUrl;
  final String? batch;
  final String? session;
  final String? studentId;
  final String? referralCode;
}

/// The shareable member card. Rendered at a fixed logical size so it can be
/// captured by a [RepaintBoundary]; scale it for preview with a [FittedBox].
///
/// Always uses the light brand palette — the exported image should look the
/// same no matter which theme the sharer happens to use.
class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.data, required this.format});

  static const double logicalWidth = 360;

  final MemberCardData data;
  final MemberCardFormat format;

  static const _colors = AppColors.light;

  @override
  Widget build(BuildContext context) {
    final isStory = format == MemberCardFormat.story;
    return SizedBox(
      width: logicalWidth,
      height: logicalWidth / format.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_colors.primaryPressed, _colors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isStory ? Spacing.xxl : Spacing.lg),
          child: isStory ? _StoryLayout(data: data) : _SquareLayout(data: data),
        ),
      ),
    );
  }
}

class _StoryLayout extends StatelessWidget {
  const _StoryLayout({required this.data});
  final MemberCardData data;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const colors = MemberCard._colors;
    return Column(
      children: [
        const _BrandBar(),
        const Spacer(),
        _Avatar(url: data.photoUrl, size: 132),
        const SizedBox(height: Spacing.lg),
        Text(
          data.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.headlineSmall?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        _MemberChip(type: data.memberType, batch: data.batch),
        const SizedBox(height: Spacing.xl),
        _InfoPanel(data: data),
        const Spacer(),
        _QrFooter(
          url: data.installUrl,
          qrSize: 84,
          referralCode: data.referralCode,
        ),
      ],
    );
  }
}

class _SquareLayout extends StatelessWidget {
  const _SquareLayout({required this.data});
  final MemberCardData data;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const colors = MemberCard._colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BrandBar(),
        const Spacer(),
        Row(
          children: [
            _Avatar(url: data.photoUrl, size: 80),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleLarge?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  _MemberChip(type: data.memberType, batch: data.batch),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        _InfoPanel(data: data, compact: true),
        const Spacer(),
        _QrFooter(
          url: data.installUrl,
          qrSize: 56,
          referralCode: data.referralCode,
        ),
      ],
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) {
    const colors = MemberCard._colors;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(Spacing.xs),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(RadiusToken.md),
          ),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Text(
            'Campus Assistant',
            style: text.titleMedium?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xxs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.onPrimary.withValues(alpha: 0.6)),
            borderRadius: BorderRadius.circular(RadiusToken.full),
          ),
          child: Text(
            'MEMBER',
            style: text.labelSmall?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.size});
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    const colors = MemberCard._colors;
    final placeholder = Icon(
      LucideIcons.user,
      size: size * 0.45,
      color: colors.primary,
    );
    // Ring and photo are separate layers: a white disc padded by the ring
    // width, with the photo clipped to its own circle inside. Clipping one
    // bordered Container instead left the photo misaligned with the ring.
    const ring = 3.0;
    final inner = size - ring * 2;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(ring),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Container(
          width: inner,
          height: inner,
          color: colors.primarySubtle,
          alignment: Alignment.center,
          child: (url == null || url!.isEmpty)
              ? placeholder
              : Image(
                  image: CachedNetworkImageProvider(
                    ApiEndpoints.resolveImageUrl(url!),
                  ),
                  width: inner,
                  height: inner,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) => placeholder,
                ),
        ),
      ),
    );
  }
}

class _MemberChip extends StatelessWidget {
  const _MemberChip({required this.type, this.batch});
  final MemberType type;
  final String? batch;

  @override
  Widget build(BuildContext context) {
    const colors = MemberCard._colors;
    final label = type == MemberType.alumni && batch != null
        ? 'Alumni · $batch'
        : type.label;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.badgeCheck, size: 14, color: colors.primary),
          const SizedBox(width: Spacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.primaryPressed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.data, this.compact = false});
  final MemberCardData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const colors = MemberCard._colors;
    final text = Theme.of(context).textTheme;
    final facts = [
      if (data.batch != null && data.memberType == MemberType.student)
        ('Batch', data.batch!),
      if (data.session != null) ('Session', data.session!),
      if (data.studentId != null) ('ID', data.studentId!),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? Spacing.md : Spacing.lg),
      decoration: BoxDecoration(
        color: colors.onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: colors.onPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: compact
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            data.departmentName,
            textAlign: compact ? TextAlign.start : TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            data.universityName,
            textAlign: compact ? TextAlign.start : TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodyMedium?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          if (facts.isNotEmpty) ...[
            SizedBox(height: compact ? Spacing.sm : Spacing.md),
            Row(
              mainAxisAlignment: compact
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                for (final (i, fact) in facts.indexed) ...[
                  if (i > 0)
                    Container(
                      width: 1,
                      height: 28,
                      margin: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                      ),
                      color: colors.onPrimary.withValues(alpha: 0.3),
                    ),
                  Column(
                    crossAxisAlignment: compact
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        fact.$1.toUpperCase(),
                        style: text.labelSmall?.copyWith(
                          color: colors.onPrimary.withValues(alpha: 0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        fact.$2,
                        style: text.labelLarge?.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _QrFooter extends StatelessWidget {
  const _QrFooter({required this.url, required this.qrSize, this.referralCode});
  final String url;
  final double qrSize;
  final String? referralCode;

  @override
  Widget build(BuildContext context) {
    const colors = MemberCard._colors;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.xs),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(RadiusToken.md),
          ),
          child: QrImageView(
            data: url,
            size: qrSize,
            padding: EdgeInsets.zero,
            backgroundColor: colors.surface,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: colors.primaryPressed,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: colors.primaryPressed,
            ),
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Join your campus on Campus Assistant',
                style: text.labelLarge?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                referralCode == null
                    ? 'Scan to download the app'
                    : 'Scan & sign up with code $referralCode',
                style: text.labelSmall?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.85),
                  fontWeight: referralCode == null ? null : FontWeight.w700,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'Not an official university ID',
                style: text.labelSmall?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
