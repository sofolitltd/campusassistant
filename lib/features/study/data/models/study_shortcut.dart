import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';

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
    color: Colors.redAccent,
    imageUrl: 'bookmark',
  ),
  ShortcutData(
    name: 'Download\nFiles',
    route: AppRoute.downloadedFiles.name,
    isNamedRoute: true,
    icon: LucideIcons.folderDown,
    color: Colors.orangeAccent,
    imageUrl: 'download',
  ),
  ShortcutData(
    name: 'Academic\nLibrary',
    route: '/library',
    icon: LucideIcons.library,
    color: Colors.blueAccent,
  ),
  ShortcutData(
    name: 'Question\nBank',
    route: '/questions',
    icon: LucideIcons.helpCircle,
    color: Colors.purpleAccent,
  ),
  ShortcutData(
    name: 'Full\nSyllabus',
    route: '/syllabus',
    icon: LucideIcons.fileText,
    color: Colors.pinkAccent,
  ),
  ShortcutData(
    name: 'Research\nArchive',
    route: '/research',
    icon: LucideIcons.search,
    color: Colors.red.shade400,
  ),
];
