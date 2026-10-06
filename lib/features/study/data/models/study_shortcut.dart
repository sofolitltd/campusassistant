import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '/core/theme/tokens/app_accents.dart';

class ShortcutData {
  final String name;
  final String route;
  final bool isNamedRoute;
  final IconData icon;
  final Color color;
  final String? imageUrl;

  ShortcutData({
    required this.name,
    required this.route,
    required this.icon,
    required this.color,
    this.imageUrl,
    this.isNamedRoute = false,
  });
}

final List<ShortcutData> allShortcuts = [
  ShortcutData(
    name: 'Saved\nBookmarks',
    route: AppRoute.bookmarks.name,
    isNamedRoute: true,
    icon: LucideIcons.bookmark,
    color: AccentToken.red,
    imageUrl: 'bookmark',
  ),
  ShortcutData(
    name: 'Download\nFiles',
    route: AppRoute.downloadedFiles.name,
    isNamedRoute: true,
    icon: LucideIcons.folderDown,
    color: AccentToken.orange,
    imageUrl: 'download',
  ),
  ShortcutData(
    name: 'Academic\nLibrary',
    route: '/library',
    icon: LucideIcons.library,
    color: AccentToken.blue,
  ),
  ShortcutData(
    name: 'Question\nBank',
    route: '/questions',
    icon: LucideIcons.helpCircle,
    color: AccentToken.violet,
  ),
  ShortcutData(
    name: 'Full\nSyllabus',
    route: '/syllabus',
    icon: LucideIcons.fileText,
    color: AccentToken.pink,
  ),
  ShortcutData(
    name: 'Research\nArchive',
    route: '/research',
    icon: LucideIcons.search,
    color: AccentToken.red,
  ),
];
