import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_card.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Layout rules shared by every section on the home page, so they line up and
/// space themselves the same way:
///
/// * Cards are inset [homeInset] from the screen edge.
/// * Section cards use [homeCardRadius].
/// * A section owns the gap *below* itself ([HomeSection]); a section that has
///   nothing to show returns a bare `SizedBox.shrink()` and so adds no gap.
const double homeInset = Spacing.lg;
const double homeCardRadius = RadiusToken.lg;

/// Wraps a section's content with the standard gap below it.
class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.child, this.bottom = Spacing.lg});

  final Widget child;

  /// Gap below the section; defaults to the standard home rhythm.
  final double bottom;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: bottom),
    child: child,
  );
}

/// The one title style for home sections.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader(this.title, {super.key, this.padding});

  final String title;

  /// Defaults to the horizontal [homeInset]; pass [EdgeInsets.zero] inside a
  /// card that already pads its content.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: homeInset),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: .w700,
        color: context.colors.text,
      ),
    ),
  );
}

/// Loading placeholder: same card chrome as the content it stands in for, at
/// a fixed height so the page doesn't jump when data arrives.
class HomeSectionLoading extends StatelessWidget {
  const HomeSectionLoading({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => HomeSection(
    child: SectionCard(
      margin: const EdgeInsets.symmetric(horizontal: homeInset),
      radius: homeCardRadius,
      shadow: false,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: const Center(child: CupertinoActivityIndicator()),
      ),
    ),
  );
}

/// Error placeholder: one compact, retryable card for every section that can
/// fail to load, instead of each inventing its own.
class HomeSectionError extends StatelessWidget {
  const HomeSectionError({
    super.key,
    required this.message,
    this.offline = false,
    this.onRetry,
  });

  final String message;
  final bool offline;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HomeSection(
      child: SectionCard(
        margin: const EdgeInsets.symmetric(horizontal: homeInset),
        radius: homeCardRadius,
        shadow: false,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: Row(
          children: [
            Icon(
              offline ? LucideIcons.cloudOff : LucideIcons.circleAlert,
              size: 20,
              color: colors.textSubtle,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: FontSizeToken.base,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

/// The brand gradient behind the home header and the drawer header, from the
/// theme roles so it adapts to dark mode (pair text with `colors.onPrimary`).
LinearGradient homeHeaderGradient(BuildContext context) {
  final colors = context.colors;
  return LinearGradient(
    colors: [colors.primaryPressed, colors.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
