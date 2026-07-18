import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/features/study/data/models/study_shortcut.dart';

class ResourceShortcutsBar extends StatelessWidget {
  final int bookmarkCount;
  final int downloadCount;

  const ResourceShortcutsBar({
    super.key,
    required this.bookmarkCount,
    required this.downloadCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 124,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: allShortcuts.length,
        itemBuilder: (context, index) {
          final shortcut = allShortcuts[index];
          final isBookmark = shortcut.imageUrl == 'bookmark';
          final isDownload = shortcut.imageUrl == 'download';
          int count = 0;
          if (isBookmark) count = bookmarkCount;
          if (isDownload) count = downloadCount;

          return GestureDetector(
            onTap: () {
              if (shortcut.isNamedRoute) {
                context.pushNamed(shortcut.route);
              } else {
                context.push(shortcut.route);
              }
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: shortcut.color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          shortcut.icon,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      if (count > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.cardColor,
                                width: 2,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shortcut.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,height: 1.3,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
