import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/department/presentation/providers/department_provider.dart';
import '/features/teacher/presentation/providers/teacher_provider.dart';
import '/features/staff/presentation/providers/staff_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/about_page_parts.dart';

class DepartmentPage extends ConsumerWidget {
  const DepartmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentAsync = ref.watch(myDepartmentProvider);

    return Scaffold(
      body: departmentAsync.when(
        data: (department) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AboutHero(
                    title: department.name,
                    imagePath: department.images.isNotEmpty
                        ? department.images.first
                        : null,
                    logoUrl: department.logoUrl,
                    chips: [
                      'DEPARTMENT',
                      if (department.acronym.isNotEmpty) department.acronym,
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.lg,
                      Spacing.xl,
                      Spacing.lg,
                      Spacing.xxxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Each count is watched inside its own Consumer so
                        // resolving a total only repaints its card, not the
                        // hero/about tree.
                        AboutStatGrid(
                          children: [
                            if (department.establishedYear > 0)
                              AboutStatCard(
                                icon: LucideIcons.calendarDays,
                                label: 'Established',
                                value: '${department.establishedYear}',
                              ),
                            Consumer(
                              builder: (context, ref, _) {
                                final teachers =
                                    ref.watch(teacherCountProvider);
                                return AboutStatCard(
                                  icon: LucideIcons.userRound,
                                  label: 'Teachers',
                                  value: teachers.when(
                                    data: (t) => '$t',
                                    loading: () => '...',
                                    error: (_, _) => '0',
                                  ),
                                );
                              },
                            ),
                            Consumer(
                              builder: (context, ref, _) {
                                final staff = ref.watch(staffCountProvider);
                                return AboutStatCard(
                                  icon: LucideIcons.users,
                                  label: 'Staff',
                                  value: staff.when(
                                    data: (s) => '$s',
                                    loading: () => '...',
                                    error: (_, _) => '0',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.lg),
                        AboutSectionCard(
                          title: 'About',
                          icon: LucideIcons.info,
                          child: AboutBody(department.about),
                        ),
                        if (department.websiteUrl.isNotEmpty) ...[
                          const SizedBox(height: Spacing.lg),
                          AboutWebsiteButton(url: department.websiteUrl),
                        ],
                      ],
                    ),
                  ),
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
