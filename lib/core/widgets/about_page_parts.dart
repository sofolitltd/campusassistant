import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/widgets/open_app.dart';

/// Building blocks shared by the University and Department "about" pages so the
/// two stay visually identical.

/// Photo header: scrim gradient, back button, and a logo / title / chip block
/// anchored to the bottom-left.
class AboutHero extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String logoUrl;
  final List<String> chips;

  const AboutHero({
    super.key,
    required this.title,
    required this.imagePath,
    this.logoUrl = '',
    this.chips = const [],
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.width > 800 ? 360.0 : 280.0;
    final cacheHeight = (height * mq.devicePixelRatio).round();
    final colors = context.colors;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: ApiEndpoints.resolveImageUrl(imagePath ?? ''),
            fit: BoxFit.cover,
            memCacheHeight: cacheHeight,
            maxHeightDiskCache: cacheHeight,
            placeholder: (_, _) => Container(
              color: colors.surfaceAlt,
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(),
            ),
            errorWidget: (_, _, _) => Container(
              color: colors.primarySubtle,
              alignment: Alignment.center,
              child: Icon(LucideIcons.graduationCap,
                  size: 56, color: colors.primary.withValues(alpha: 0.4)),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0, 0.55, 1],
                colors: [
                  colors.scrim.withValues(alpha: 0.85),
                  colors.scrim.withValues(alpha: 0.25),
                  colors.scrim.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.sm),
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.scrim.withValues(alpha: 0.45),
                    foregroundColor: colors.onScrim,
                  ),
                  icon: const Icon(LucideIcons.arrowLeft, size: 20),
                ),
              ),
            ),
          ),
          Positioned(
            left: Spacing.lg,
            right: Spacing.lg,
            bottom: Spacing.xl,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (logoUrl.isNotEmpty) ...[
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: RadiusToken.circular(RadiusToken.xl),
                      boxShadow: [
                        BoxShadow(color: colors.shadow, blurRadius: 12),
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ApiEndpoints.resolveImageUrl(logoUrl),
                      fit: BoxFit.contain,
                      errorWidget: (_, _, _) => Icon(
                        LucideIcons.graduationCap,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (chips.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.xs),
                          child: Wrap(
                            spacing: Spacing.sm,
                            runSpacing: Spacing.xs,
                            children: [
                              for (final c in chips)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.sm,
                                    vertical: Spacing.xxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius:
                                        RadiusToken.circular(RadiusToken.full),
                                  ),
                                  child: Text(
                                    c,
                                    style: TextStyle(
                                      color: colors.onPrimary,
                                      fontSize: FontSizeToken.xxs,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.onScrim,
                          fontSize: FontSizeToken.display,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One headline figure: tinted icon tile, big value, small label.
class AboutStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AboutStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primarySubtle,
              borderRadius: RadiusToken.circular(RadiusToken.md),
            ),
            child: Icon(icon, size: 20, color: colors.primary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: FontSizeToken.lg,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: FontSizeToken.sm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Two-column grid of [AboutStatCard]s (a lone last card spans the full row).
class AboutStatGrid extends StatelessWidget {
  final List<Widget> children;
  const AboutStatGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final hasPair = i + 1 < children.length;
      rows.add(
        Row(
          children: [
            Expanded(child: children[i]),
            if (hasPair) ...[
              const SizedBox(width: Spacing.md),
              Expanded(child: children[i + 1]),
            ],
          ],
        ),
      );
      if (i + 2 < children.length) rows.add(const SizedBox(height: Spacing.md));
    }
    return Column(children: rows);
  }
}

/// Titled card with the brand accent bar — the "About" body lives in one.
class AboutSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const AboutSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: RadiusToken.circular(RadiusToken.xl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: RadiusToken.circular(RadiusToken.full),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: Spacing.sm),
              Text(
                title,
                style: TextStyle(
                  color: colors.text,
                  fontSize: FontSizeToken.xl,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          child,
        ],
      ),
    );
  }
}

/// Body text of an about section, with an empty-state fallback.
class AboutBody extends StatelessWidget {
  final String text;
  const AboutBody(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final empty = text.trim().isEmpty;
    return Text(
      empty ? 'No information available yet.' : text.trim(),
      style: TextStyle(
        color: empty ? colors.textSubtle : colors.text,
        fontSize: FontSizeToken.base,
        height: 1.65,
      ),
    );
  }
}

/// Icon + text line, used for address and similar facts inside a section card.
class AboutInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const AboutInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: FontSizeToken.md,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width primary action that opens a site (in-app webview on mobile).
class AboutWebsiteButton extends StatelessWidget {
  final String url;
  final String label;
  const AboutWebsiteButton({
    super.key,
    required this.url,
    this.label = 'Visit Website',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          if (kIsWeb) {
            OpenApp.withUrl(url);
          } else {
            context.push('/webview?url=$url');
          }
        },
        icon: const Icon(LucideIcons.globe, size: 18),
        label: Text(label),
      ),
    );
  }
}
