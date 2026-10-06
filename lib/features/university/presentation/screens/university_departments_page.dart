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

class UniversityDepartmentsPage extends ConsumerStatefulWidget {
  const UniversityDepartmentsPage({super.key});

  @override
  ConsumerState<UniversityDepartmentsPage> createState() =>
      _UniversityDepartmentsPageState();
}

class _UniversityDepartmentsPageState
    extends ConsumerState<UniversityDepartmentsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final universityAsync = ref.watch(myUniversityProvider);

    return universityAsync.when(
      data: (university) {
        final deptsAsync = ref.watch(
          departmentsByUniversityProvider(university.id),
        );

        return CustomHeaderLayout(
          title: '${university.acronym} Departments',
          searchAtBottom: true,
          searchHint: 'Search departments...',
          onSearchChanged: (value) => setState(() => _query = value),
          body: deptsAsync.when(
            data: (departments) =>
                _DepartmentsList(departments: departments, query: _query),
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

class _DepartmentsList extends StatelessWidget {
  final List<Department> departments;
  final String query;

  const _DepartmentsList({required this.departments, required this.query});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? departments
        : departments
              .where(
                (d) =>
                    d.name.toLowerCase().contains(q) ||
                    d.acronym.toLowerCase().contains(q),
              )
              .toList();

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Departments (${filtered.length})',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.lg),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xxl),
            child: Center(
              child: Text(
                departments.isEmpty
                    ? 'No departments found'
                    : 'No departments match "$query"',
                style: TextStyle(color: context.colors.textMuted),
              ),
            ),
          )
        else
          ...filtered.map(
            (dept) => _DepartmentCard(department: dept, isDark: isDark),
          ),
      ],
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
