import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/university_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/about_page_parts.dart';

class UniversityPage extends ConsumerWidget {
  const UniversityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universityAsync = ref.watch(universityProvider);

    return Scaffold(
      body: universityAsync.when(
        data: (university) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AboutHero(
                    title: university.name,
                    imagePath: university.images.isNotEmpty
                        ? university.images.first
                        : null,
                    logoUrl: university.logoUrl,
                    chips: [
                      'UNIVERSITY',
                      if (university.acronym.isNotEmpty) university.acronym,
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
                        AboutStatGrid(
                          children: [
                            if (university.establishedYear.isNotEmpty)
                              AboutStatCard(
                                icon: LucideIcons.calendarDays,
                                label: 'Established',
                                value: university.establishedYear,
                              ),
                            if (university.campusArea.isNotEmpty)
                              AboutStatCard(
                                icon: LucideIcons.maximize,
                                label: 'Campus Area',
                                value: university.campusArea,
                              ),
                            AboutStatCard(
                              icon: LucideIcons.layers,
                              label: 'Faculties',
                              value: university.totalFaculties,
                            ),
                            AboutStatCard(
                              icon: LucideIcons.graduationCap,
                              label: 'Departments',
                              value: university.totalDepartments,
                            ),
                            AboutStatCard(
                              icon: LucideIcons.house,
                              label: 'Residential Halls',
                              value: university.totalHalls,
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.lg),
                        AboutSectionCard(
                          title: 'About',
                          icon: LucideIcons.info,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AboutBody(university.about),
                              if (university.address.isNotEmpty) ...[
                                const SizedBox(height: Spacing.lg),
                                AboutInfoRow(
                                  icon: LucideIcons.mapPin,
                                  text: university.address,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (university.websiteUrl.isNotEmpty) ...[
                          const SizedBox(height: Spacing.lg),
                          AboutWebsiteButton(url: university.websiteUrl),
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
