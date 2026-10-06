import 'package:flutter/material.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class AlumniEmptyState extends StatelessWidget {
  const AlumniEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.xxxl,
          Spacing.xxxl,
          Spacing.xxxl,
          100,
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: context.colors.borderStrong,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              'No alumni match your criteria.',
              textAlign: .center,
              style: TextStyle(
                fontSize: FontSizeToken.lg,
                fontWeight: .w600,
                color: context.colors.textMuted,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Try adjusting your search query or organization filters.',
              textAlign: .center,
              style: TextStyle(
                fontSize: FontSizeToken.sm,
                color: context.colors.textSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
