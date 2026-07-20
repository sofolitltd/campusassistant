import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/error/failures.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/student/presentation/providers/student_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_tab_bar.dart';

class ProfileInfoTabsSection extends StatefulWidget {
  final user_entity.User user;

  const ProfileInfoTabsSection({super.key, required this.user});

  @override
  State<ProfileInfoTabsSection> createState() => _ProfileInfoTabsSectionState();
}

class _ProfileInfoTabsSectionState extends State<ProfileInfoTabsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2 tabs: Academic Info, Personal Info
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.xs),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
                0,
              ),
              child: SectionTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Academic'),
                  Tab(text: 'Personal'),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SizedBox(
              height: 240, // Enough height for the content
              child: TabBarView(
                controller: _tabController,
                children: [_buildAcademicTab(), _buildPersonalTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicTab() {
    if (widget.user.role != 'student') {
      return const Center(child: Text('Not a student'));
    }

    return Consumer(
      builder: (context, ref, child) {
        return ref
            .watch(studentProfileProvider)
            .when(
              data: (student) {
                if (student == null) return const SizedBox.shrink();
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoItem(
                        label: 'Batch',
                        value: student.batchName ?? student.batchId,
                      ),
                      const Divider(thickness: .5),
                      _InfoItem(
                        label: 'Session',
                        value: student.sessionName ?? student.sessionId,
                      ),
                      const Divider(thickness: .5),
                      _InfoItem(label: 'Student ID', value: student.studentId),
                      const Divider(thickness: .5),
                      _InfoItem(label: 'Hall', value: student.hall),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        err is NetworkFailure
                            ? Icons.cloud_off
                            : Icons.error_outline,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        err is NetworkFailure
                            ? 'No internet connection'
                            : 'Unable to load academic info',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
      },
    );
  }

  Widget _buildPersonalTab() {
    return Consumer(
      builder: (context, ref, child) {
        if (widget.user.role == 'student') {
          return ref
              .watch(studentProfileProvider)
              .when(
                data: (student) => _buildContactList(student: student),
                loading: () => _buildContactList(student: null),
                error: (err, _) => _buildContactList(student: null),
              );
        }
        return _buildContactList(student: null);
      },
    );
  }

  Widget _buildContactList({required Object? student}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoItem(label: 'Email', value: widget.user.email),
          const Divider(thickness: .5),
          _InfoItem(label: 'Phone', value: widget.user.phone ?? 'N/A'),
          const Divider(thickness: .5),
          if (student != null) ...[
            _InfoItem(
              label: 'Blood Group',
              value: (student as dynamic).bloodGroup.isNotEmpty
                  ? (student as dynamic).bloodGroup
                  : 'N/A',
            ),
            const Divider(thickness: .5),
            _InfoItem(label: 'Gender', value: widget.user.gender ?? 'N/A'),
          ] else ...[
            _InfoItem(label: 'Blood Group', value: widget.user.blood ?? 'N/A'),
            const Divider(thickness: .5),
            _InfoItem(label: 'Gender', value: widget.user.gender ?? 'N/A'),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
