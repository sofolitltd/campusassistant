import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/department/domain/entities/department.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class UniversityDepartmentsPage extends ConsumerWidget {
  const UniversityDepartmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universityAsync = ref.watch(myUniversityProvider);

    return universityAsync.when(
      data: (university) {
        final deptsAsync = ref.watch(
          departmentsByUniversityProvider(university.id),
        );

        return CustomHeaderLayout(
          title: '${university.acronym} Departments',
          showSearchBar: false,
          body: deptsAsync.when(
            data: (departments) => Column(
              children: [
                _TotalCountBanner(
                  count: departments.length,
                  label: 'Total Departments',
                  icon: LucideIcons.building2,
                ),
                Expanded(child: _DepartmentsList(departments: departments)),
              ],
            ),
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
        appBar: AppBar(title: const Text('Departments'), centerTitle: true),
        body: const Center(child: CupertinoActivityIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Departments'), centerTitle: true),
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

class _TotalCountBanner extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;

  const _TotalCountBanner({
    required this.count,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 0),
      child: Container(
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AccentToken.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),
              child: Icon(icon, color: AccentToken.blue, size: 22),
            ),
            const SizedBox(width: Spacing.lg),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '$count',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: .bold,
                    color: AccentToken.blue,
                  ),
                ),
                Text(
                  label,
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
    );
  }
}

class _DepartmentsList extends StatelessWidget {
  final List<Department> departments;

  const _DepartmentsList({required this.departments});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.lg),
      physics: const BouncingScrollPhysics(),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final dept = departments[index];
        return _DepartmentCard(department: dept, isDark: isDark);
      },
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  final Department department;
  final bool isDark;

  const _DepartmentCard({required this.department, required this.isDark});

  Color _colorForIndex(int index) {
    const colors = [
      AccentToken.blue,
      AccentToken.violet,
      AccentToken.pink,
      Color(0xFF10B981),
      AccentToken.amber,
      AccentToken.red,
      AccentToken.indigo,
      AccentToken.teal,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForIndex(department.name.hashCode);

    return GestureDetector(
      onTap: () => context.push('/department'),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Center(
                  child: Text(
                    department.acronym.isNotEmpty
                        ? department.acronym.substring(0, 2).toUpperCase()
                        : department.name.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: .w800,
                      fontSize: FontSizeToken.lg,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      department.name,
                      style: const TextStyle(
                        fontWeight: .w600,
                        fontSize: FontSizeToken.base,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      'Est. ${department.establishedYear}',
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: FontSizeToken.sm,
                      ),
                    ),
                  ],
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
