import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/teacher/domain/entities/teacher.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// A single teacher — public, drop-in card. Tap navigates to the teacher
/// details route (built in, no external onTap wiring needed). Used by both
/// `TeacherListView` (teacher_page.dart) and the global search results page.
class TeacherCard extends StatelessWidget {
  final Teacher teacher;

  const TeacherCard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: () =>
            context.push('${AppRoute.teacher.path}/details?id=${teacher.id}'),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              _buildImage(context, isDark),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      teacher.name,
                      style: const TextStyle(
                        fontWeight: .w700,
                        fontSize: FontSizeToken.base,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      teacher.post,
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: FontSizeToken.sm,
                        fontWeight: .w500,
                      ),
                    ),
                    if (teacher.phd.isNotEmpty) ...[
                      const SizedBox(height: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(RadiusToken.sm),
                        ),
                        child: Text(
                          teacher.phd,
                          style: TextStyle(
                            color: context.colors.textMuted,
                            fontSize: FontSizeToken.xxs,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: context.colors.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, bool isDark) {
    return Stack(
      clipBehavior: .none,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(color: context.colors.surfaceAlt, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            child: CachedNetworkImage(
              imageUrl: ApiEndpoints.resolveImageUrl(teacher.imageUrl),
              fit: .cover,
              placeholder: (context, url) =>
                  const Center(child: CupertinoActivityIndicator(radius: 6)),
              errorWidget: (context, url, error) => Icon(
                LucideIcons.user,
                color: context.colors.borderStrong,
                size: 24,
              ),
            ),
          ),
        ),
        if (teacher.chairman)
          Positioned(
            bottom: -2,
            left: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF008080), Color(0xFF006666)],
                ),
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                'CHAIRMAN',
                textAlign: .center,
                style: TextStyle(
                  color: context.colors.onPrimary,
                  fontSize: 7,
                  fontWeight: .w900,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
