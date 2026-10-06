import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/department/domain/entities/department.dart';
import '/features/university/presentation/providers/faculty_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class FacultyDetailsPage extends ConsumerStatefulWidget {
  final String facultyId;
  final String facultyName;

  const FacultyDetailsPage({
    super.key,
    required this.facultyId,
    required this.facultyName,
  });

  @override
  ConsumerState<FacultyDetailsPage> createState() => _FacultyDetailsPageState();
}

class _FacultyDetailsPageState extends ConsumerState<FacultyDetailsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final facultyName = widget.facultyName;
    final departmentsAsync = ref.watch(
      departmentsByFacultyProvider(widget.facultyId),
    );

    return CustomHeaderLayout(
      title: facultyName.isNotEmpty ? facultyName : 'Faculty',
      searchAtBottom: true,
      searchHint: 'Search departments...',
      onSearchChanged: (value) => setState(() => _query = value),
      body: departmentsAsync.when(
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
  }
}

class _DepartmentsList extends StatelessWidget {
  final List<Department> departments;
  final String query;

  const _DepartmentsList({required this.departments, required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.lg),
        if (departments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xxxxl),
            child: Column(
              children: [
                Icon(
                  LucideIcons.graduationCap,
                  size: 56,
                  color: context.colors.borderStrong,
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  'No departments assigned to this faculty yet',
                  textAlign: .center,
                  style: TextStyle(
                    color: context.colors.textMuted,
                    fontWeight: .w500,
                  ),
                ),
              ],
            ),
          )
        else if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xxl),
            child: Center(
              child: Text(
                'No departments match "$query"',
                style: TextStyle(color: context.colors.textMuted),
              ),
            ),
          )
        else
          ...filtered.map((dept) => _DepartmentCard(department: dept)),
      ],
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  final Department department;

  const _DepartmentCard({required this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(RadiusToken.sm),
            ),
            child: Center(
              child: Text(
                department.acronym.isNotEmpty
                    ? department.acronym.substring(0, 2).toUpperCase()
                    : department.name.substring(0, 2).toUpperCase(),
                style: TextStyle(
                  color: context.colors.primary,
                  fontWeight: .w800,
                  fontSize: FontSizeToken.base,
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
                const SizedBox(height: Spacing.xxs),
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
        ],
      ),
    );
  }
}
