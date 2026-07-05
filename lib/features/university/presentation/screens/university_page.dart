import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/university_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/widgets/open_app.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Hero Image
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: university.images.isNotEmpty
                        ? university.images.first
                        : '',
                    width: double.infinity,
                    height: width > 800 ? 350 : 250,
                    fit: BoxFit.cover,
                    placeholder: (context, _) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (_, _, _) => Container(
                      color: Colors.grey.shade200,
                      height: width > 800 ? 350 : 250,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                  Container(
                    height: width > 800 ? 350 : 250,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                            backgroundColor: Colors.white.withValues(alpha: 0.8),
                            foregroundColor: Colors.black,
                            minimumSize: Size(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            visualDensity: VisualDensity(
                              vertical: -4,
                              horizontal: -4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                          ),
                          icon: const Icon(Icons.public, size: 16),
                          label: const Text('Visit Website'),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(child: BackButton()),
                ],
              ),

              const SizedBox(height: 24),

              // 🔹 Stats Table
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
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

              const SizedBox(height: 24),

              // 🔹 About Section (full width)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      university.about,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? Colors.white70
                            : Colors.grey.shade800,
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
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: border
            ? Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
