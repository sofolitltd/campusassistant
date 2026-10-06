import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/department/presentation/providers/department_provider.dart';
import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/teacher/presentation/providers/teacher_provider.dart';
import '/features/staff/presentation/providers/staff_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class DepartmentPage extends ConsumerWidget {
  const DepartmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentAsync = ref.watch(myDepartmentProvider);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final imageHeight = width > 800 ? 350.0 : 250.0;
    // Decode the hero at display resolution so we don't hold a full-size
    // bitmap in the image cache for a ~250-350px slot.
    final heroCacheHeight = (imageHeight * mediaQuery.devicePixelRatio).round();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: departmentAsync.when(
        data: (department) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  // 🔹 Hero Image
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: ApiEndpoints.resolveImageUrl(
                          department.images.isNotEmpty
                              ? department.images[0]
                              : '',
                        ),
                        width: double.infinity,
                        height: imageHeight,
                        memCacheHeight: heroCacheHeight,
                        maxHeightDiskCache: heroCacheHeight,
                        fit: .cover,
                        placeholder: (context, _) =>
                            const Center(child: CupertinoActivityIndicator()),
                        errorWidget: (_, _, _) => Container(
                          color: context.colors.border,
                          height: imageHeight,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                      Container(
                        height: imageHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.colors.textMuted,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 24,
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              department.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: context.colors.onPrimary,
                                    fontWeight: .bold,
                                  ),
                            ),
                            const SizedBox(height: Spacing.md),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (kIsWeb) {
                                  OpenApp.withUrl(department.websiteUrl);
                                } else {
                                  context.push(
                                    '/webview?url=${department.websiteUrl}',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.surface
                                    .withValues(alpha: 0.8),
                                foregroundColor: context.colors.text,
                                minimumSize: const Size(0, ControlToken.height),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.sm,
                                  vertical: 0,
                                ),
                              ),
                              icon: const Icon(Icons.public, size: 16),
                              label: const Text('Visit website'),
                            ),
                          ],
                        ),
                      ),
                      SafeArea(child: BackButton()),
                    ],
                  ),

                  const SizedBox(height: Spacing.xxl),

                  // 🔹 Stats Table (Teachers & Staff)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        children: [
                          // Each count is watched inside its own Consumer so
                          // resolving a total only repaints its stat row, not
                          // the hero/about tree above.
                          Consumer(
                            builder: (context, ref, _) {
                              final teachers = ref.watch(teacherCountProvider);
                              return _StatTile(
                                label: 'Teachers',
                                value: teachers.when(
                                  data: (t) => '$t',
                                  loading: () => '...',
                                  error: (_, _) => '0',
                                ),
                                isDark: isDark,
                                border: true,
                              );
                            },
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              final staff = ref.watch(staffCountProvider);
                              return _StatTile(
                                label: 'Staffs',
                                value: staff.when(
                                  data: (s) => '$s',
                                  loading: () => '...',
                                  error: (_, _) => '0',
                                ),
                                isDark: isDark,
                                border: false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.xxl),

                  // 🔹 About Section (full width)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: .bold,
                                fontSize: FontSizeToken.xl,
                              ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          department.about,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: context.colors.text,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xxxl),
                ],
              ),
            ),
          ),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool border;

  const _StatTile({
    required this.label,
    required this.value,
    required this.isDark,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        border: border
            ? Border(bottom: BorderSide(color: context.colors.border))
            : null,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              Icon(LucideIcons.user, size: 16, color: context.colors.primary),

              const SizedBox(width: Spacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontWeight: .w500,
                  fontSize: FontSizeToken.base,
                  color: context.colors.textMuted,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: .bold,
              fontSize: FontSizeToken.base,
              color: context.colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
