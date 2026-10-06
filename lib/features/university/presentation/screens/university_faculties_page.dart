import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '/features/university/data/models/faculty.dart';
import '/features/university/presentation/providers/faculty_provider.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class UniversityFacultiesPage extends ConsumerWidget {
  const UniversityFacultiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universityAsync = ref.watch(myUniversityProvider);

    return universityAsync.when(
      data: (university) {
        final facultiesAsync = ref.watch(
          facultiesByUniversityProvider(university.id),
        );

        return CustomHeaderLayout(
          title: 'Faculties',
          showSearchBar: false,
          body: facultiesAsync.when(
            data: (faculties) => _FacultiesList(faculties: faculties),
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Text(
                  err.toString(),
                  textAlign: .center,
                  style: TextStyle(
                    color: context.colors.danger,
                    fontSize: FontSizeToken.md,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Faculties'), centerTitle: true),
        body: const Center(child: CupertinoActivityIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Faculties'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Text(
              err.toString(),
              textAlign: .center,
              style: TextStyle(
                color: context.colors.danger,
                fontSize: FontSizeToken.md,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FacultiesList extends StatelessWidget {
  final List<Faculty> faculties;

  const _FacultiesList({required this.faculties});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (faculties.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    LucideIcons.layers,
                    size: 56,
                    color: context.colors.borderStrong,
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'No faculties listed yet',
                    style: TextStyle(
                      color: context.colors.textMuted,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AccentToken.blue.withValues(alpha: 0.1),
                AccentToken.violet.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(color: context.colors.info),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AccentToken.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: const Icon(
                  LucideIcons.building,
                  color: AccentToken.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    '${faculties.length}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: .bold,
                      color: AccentToken.blue,
                    ),
                  ),
                  Text(
                    'Total Faculties',
                    style: TextStyle(
                      color: context.colors.textMuted,
                      fontSize: FontSizeToken.md,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.xxl),
        Text(
          'All Faculties',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          'Tap a faculty to see its departments',
          style: TextStyle(
            color: context.colors.textMuted,
            fontSize: FontSizeToken.md,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        ...faculties.map((faculty) => _FacultyCard(faculty: faculty)),
      ],
    );
  }
}

class _FacultyCard extends StatelessWidget {
  final Faculty faculty;

  const _FacultyCard({required this.faculty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
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
        onTap: () => context.pushNamed(
          AppRoute.facultyDetails.name,
          pathParameters: {'facultyId': faculty.id},
          extra: {'facultyName': faculty.name},
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AccentToken.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Center(
                  child: Text(
                    faculty.name.isNotEmpty
                        ? faculty.name.substring(0, 2).toUpperCase()
                        : '??',
                    style: const TextStyle(
                      color: AccentToken.blue,
                      fontWeight: .w800,
                      fontSize: FontSizeToken.base,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  faculty.name,
                  style: const TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.base,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: context.colors.textSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
