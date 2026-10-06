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
            _sentenceCase(title),
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: .bold,
              letterSpacing: 0.2,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// "MAJOR COURSE" / "major course" -> "Major course".
String _sentenceCase(String text) {
  final t = text.trim();
  if (t.isEmpty) return t;
  return t[0].toUpperCase() + t.substring(1).toLowerCase();
}
