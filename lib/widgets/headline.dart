import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String title;

  const Headline({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
