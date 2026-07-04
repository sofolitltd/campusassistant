import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/department/presentation/providers/department_provider.dart';
import '/widgets/open_app.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';

class DepartmentPage extends ConsumerWidget {
  const DepartmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentAsync = ref.watch(myDepartmentProvider);
    final userAsync = ref.watch(currentUserProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(title: const Text('Department Details'), centerTitle: true),
      body: departmentAsync.when(
        data: (department) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 Hero Image
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: department.images.isNotEmpty
                        ? department.images[0]
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
                          department.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 10),
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
                            backgroundColor: Colors.white.withValues(alpha: 0.8),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            visualDensity: const VisualDensity(
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

              // const SizedBox(height: 16),

              // Quick Actions Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: width > 600 ? 4 : 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.8,
                      children: [
                        _QuickActionCard(
                          title: 'Teachers',
                          icon: LucideIcons.users,
                          onTap: () => context.push(AppRoute.teacher.path),
                        ),
                        _QuickActionCard(
                          title: 'Students',
                          icon: LucideIcons.graduationCap,
                          onTap: () {
                            userAsync.whenData((user) {
                              if (user == null) return;
                              final bId = user.batch?.trim();
                              if (bId == null || bId == '' || bId == '0') {
                                context.pushNamed('allStudents');
                              } else {
                                context.pushNamed(
                                  'batchStudents',
                                  pathParameters: {'batch': bId},
                                );
                              }
                            });
                          },
                        ),
                   
                        _QuickActionCard(
                          title: 'CR List',
                          icon: LucideIcons.userCheck,
                          onTap: () => context.push(AppRoute.cr.path),
                        ),
                        _QuickActionCard(
                          title: 'Staffs',
                          icon: LucideIcons.briefcase,
                          onTap: () => context.push(AppRoute.staff.path),
                        ),
                             _QuickActionCard(
                          title: 'Routine',
                          icon: LucideIcons.calendarClock,
                          onTap: () => context.push(AppRoute.routine.path),
                        ),
                        _QuickActionCard(
                          title: 'Notice',
                          icon: LucideIcons.info,
                          onTap: () {
                            context.push(AppRoute.routine.path);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 16),

              // About section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        department.about,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade800,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
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

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            width: 1,
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
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark ? Colors.white : Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
