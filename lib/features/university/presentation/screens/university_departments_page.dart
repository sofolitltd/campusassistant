import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/red_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/department/domain/entities/department.dart';
import '/features/university/presentation/providers/university_provider.dart';

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

        return RedHeaderLayout(
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
                padding: const EdgeInsets.all(20),
                child: Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent, fontSize: 13),
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
            padding: const EdgeInsets.all(20),
            child: Text(
              err.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent, fontSize: 13),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3B82F6).withValues(alpha: 0.1),
              Color(0xFF8B5CF6).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.blue.shade100,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),
              child: Icon(icon, color: Color(0xFF3B82F6), size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 13,
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
      padding: const EdgeInsets.all(16),
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
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
      Color(0xFF6366F1),
      Color(0xFF14B8A6),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForIndex(department.name.hashCode);

    return GestureDetector(
      onTap: () => context.push('/department'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Est. ${department.establishedYear}',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: isDark ? Colors.white30 : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
