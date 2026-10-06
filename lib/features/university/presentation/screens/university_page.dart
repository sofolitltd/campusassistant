import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/university_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/widgets/open_app.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class UniversityPage extends ConsumerWidget {
  const UniversityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universityAsync = ref.watch(universityProvider);
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: universityAsync.when(
        data: (university) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  // 🔹 Hero Image
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: ApiEndpoints.resolveImageUrl(
                          university.images.isNotEmpty
                              ? university.images.first
                              : '',
                        ),
                        width: double.infinity,
                        height: width > 800 ? 350 : 250,
                        fit: .cover,
                        placeholder: (context, _) =>
                            const Center(child: CupertinoActivityIndicator()),
                        errorWidget: (_, _, _) => Container(
                          color: context.colors.border,
                          height: width > 800 ? 350 : 250,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                      Container(
                        height: width > 800 ? 350 : 250,
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
                              university.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: context.colors.onPrimary,
                                fontWeight: .bold,
                              ),
                            ),
                            const SizedBox(height: Spacing.md),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (kIsWeb) {
                                  OpenApp.withUrl(university.websiteUrl);
                                } else {
                                  context.push(
                                    '/webview?url=${university.websiteUrl}',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.surface
                                    .withValues(alpha: 0.8),
                                foregroundColor: context.colors.text,
                                minimumSize: Size(0, ControlToken.height),
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

                  // 🔹 Stats Table
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        children: [
                          _StatTile(
                            label: 'Total Faculties',
                            value: university.totalFaculties,
                            isDark: isDark,
                            border: true,
                          ),
                          _StatTile(
                            label: 'Total Departments',
                            value: university.totalDepartments,
                            isDark: isDark,
                            border: true,
                          ),
                          _StatTile(
                            label: 'Total Halls',
                            value: '${university.totalHalls} Halls',
                            isDark: isDark,
                            border: false,
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
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: .bold,
                            fontSize: FontSizeToken.xl,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          university.about,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.colors.text,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
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
          Text(
            label,
            style: TextStyle(
              fontWeight: .w500,
              fontSize: FontSizeToken.base,
              color: context.colors.textMuted,
            ),
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
