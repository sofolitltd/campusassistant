import 'package:flutter/material.dart';
import '/core/theme/tokens/app_spacing.dart';

class Headline extends StatelessWidget {
  final String title;

  const Headline({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        Spacing.xs,
        Spacing.xs,
        Spacing.xs,
        Spacing.xs,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: .bold,
              letterSpacing: 1,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
