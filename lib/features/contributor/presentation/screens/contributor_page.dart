import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';

class ContributorPage extends StatelessWidget {
  const ContributorPage({super.key});

  static const _contributors = [
    _Contributor(name: 'Samia Matium Mojumder Samia', role: 'Student'),
    _Contributor(name: 'Bibi Hazera', role: 'Student'),
    _Contributor(name: 'Azizul Hakim Sojol', role: 'Student'),
    _Contributor(name: 'Afjal Hossain Hridoy', role: 'Student'),
    _Contributor(name: 'Abdullah Saad', role: 'Student'),
    _Contributor(name: 'Upoma Eti', role: 'Student'),
    _Contributor(name: 'Lubaba Azad', role: 'Student'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomHeaderLayout(
      title: 'Our Contributors',
      showSearchBar: false,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: _contributors.length,
        itemBuilder: (context, index) {
          final c = _contributors[index];
          final initials = _getInitials(c.name);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Theme.of(context).cardColor : Colors.white,
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _avatarColor(index),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c.role,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _avatarColor(int index) {
    const colors = [
      Color(0xFF00897B),
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF6366F1),
    ];
    return colors[index % colors.length];
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class _Contributor {
  final String name;
  final String role;

  const _Contributor({required this.name, required this.role});
}
