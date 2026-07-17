import 'package:flutter/material.dart';
import '/core/theme/tokens/app_radius.dart';

class DateSeparator extends StatelessWidget {
  final String date;
  final bool isDark;

  const DateSeparator({super.key, required this.date, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(RadiusToken.md),
          ),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
