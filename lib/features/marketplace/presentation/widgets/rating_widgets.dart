import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

/// "★ 4.5 (12)" — compact rating for cards and headers. Renders nothing when
/// there are no ratings yet, so unrated products don't show a sad "0.0".
class RatingBadge extends StatelessWidget {
  final double average;
  final int count;
  final double size;
  const RatingBadge({super.key, required this.average, required this.count, this.size = 12});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size + 2, color: c.warning),
        const SizedBox(width: Spacing.xxs),
        Text(
          average.toStringAsFixed(1),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: c.text),
        ),
        const SizedBox(width: Spacing.xs),
        Text('($count)', style: TextStyle(fontSize: size - 1, color: c.textSubtle)),
      ],
    );
  }
}

/// A row of five stars showing [rating] (whole stars; fractions round).
class StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const StarRow({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = rating.round() > i;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: filled ? c.warning : c.borderStrong,
        );
      }),
    );
  }
}

/// Tap-to-rate stars.
class StarPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final double size;
  const StarPicker({super.key, required this.value, required this.onChanged, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = value > i;
        return GestureDetector(
          onTap: () => onChanged(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xxs),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: filled ? c.warning : c.borderStrong,
            ),
          ),
        );
      }),
    );
  }
}

/// Small verified-seller / fast-shipper style chip.
class TrustChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const TrustChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(color: c.primarySubtle, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: c.primary),
          const SizedBox(width: Spacing.xs),
          Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: c.primary)),
        ],
      ),
    );
  }
}

const reviewIcon = LucideIcons.messageSquareText;
