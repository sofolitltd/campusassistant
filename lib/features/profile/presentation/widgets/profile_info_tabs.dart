import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/error/failures.dart';
import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/student/domain/entities/student_address.dart';
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
    // 3 tabs: Academic Info, Personal Info, Address
    _tabController = TabController(length: 3, vsync: this);
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
                  Tab(text: 'Address'),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SizedBox(
              // Batch/Session and Blood Group/Gender are now paired into
              // rows instead of stacked, so each tab is shorter than before
              // — 240 left a big empty gap under the content. Address can
              // wrap to 2 lines per entry, so it gets a little more room.
              height: 170,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAcademicTab(),
                  _buildPersonalTab(),
                  _buildAddressTab(),
                ],
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Batch',
                              value: student.batchName ?? student.batchId,
                            ),
                          ),
                          Expanded(
                            child: _InfoItem(
                              label: 'Session',
                              value: student.sessionName ?? student.sessionId,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: .5, indent: 0, endIndent: 0),
                      _InfoItem(label: 'Student ID', value: student.studentId),
                      const Divider(thickness: .5, indent: 0, endIndent: 0),
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

  Widget _buildAddressTab() {
    if (widget.user.role != 'student') {
      return const Center(child: Text('Not available'));
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
                      _AddressItem(
                        label: 'Present Address',
                        address: student.presentAddress,
                      ),
                      const Divider(thickness: .5, indent: 0, endIndent: 0),
                      _AddressItem(
                        label: 'Permanent Address',
                        address: student.permanentAddress,
                      ),
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
                            : 'Unable to load address info',
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

  Widget _buildContactList({required Object? student}) {
    final bloodGroup = student != null
        ? ((student as dynamic).bloodGroup.isNotEmpty
              ? (student as dynamic).bloodGroup as String
              : 'N/A')
        : (widget.user.blood ?? 'N/A');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoItem(label: 'Email', value: widget.user.email),
          const Divider(thickness: .5, indent: 0, endIndent: 0),
          _InfoItem(label: 'Phone', value: widget.user.phone ?? 'N/A'),
          const Divider(thickness: .5, indent: 0, endIndent: 0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoItem(label: 'Blood Group', value: bloodGroup),
              ),
              Expanded(
                child: _InfoItem(
                  label: 'Gender',
                  value: widget.user.gender ?? 'N/A',
                ),
              ),
            ],
          ),
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
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Two-line address display: the street/house line first, then
/// sub-district/district below it — clearer than squeezing everything
/// (address line + sub-district + district) onto one wrapped line.
class _AddressItem extends StatelessWidget {
  final String label;
  final StudentAddress? address;

  const _AddressItem({required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final addressLine = address?.addressLine?.trim() ?? '';
    final region = [
      if ((address?.subDistrictName ?? '').isNotEmpty) address!.subDistrictName,
      if ((address?.districtName ?? '').isNotEmpty) address!.districtName,
    ].join(', ');
    final hasAny = addressLine.isNotEmpty || region.isNotEmpty;

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
          const SizedBox(height: 6),
          if (!hasAny)
            Text('N/A', style: Theme.of(context).textTheme.bodyMedium)
          else ...[
            if (addressLine.isNotEmpty)
              Text(
                addressLine,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (region.isNotEmpty)
              Text(
                region,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
          ],
        ],
      ),
    );
  }
}
