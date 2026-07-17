import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/student/presentation/providers/student_provider.dart';
import 'section_header.dart';
import '/core/theme/tokens/app_radius.dart';

class ContactSection extends ConsumerWidget {
  final user_entity.User user;

  const ContactSection({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          SectionHeader(
            title: 'Personal Info',
            subtitle: 'Contact information',
            icon: LucideIcons.contact,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).cardColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _ContactInfo(user: user),
          ),
        ],
      ),
    );
  }
}

class _ContactInfo extends ConsumerWidget {
  final user_entity.User user;

  const _ContactInfo({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user.role == 'student') {
      return ref
          .watch(studentProfileProvider)
          .when(
            data: (student) => _buildContactList(student: student),
            loading: () => _buildContactList(student: null),
            error: (err, _) => _buildContactList(student: null),
          );
    }
    return _buildContactList(student: null);
  }

  Column _buildContactList({required Object? student}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactItem(label: 'Email', value: user.email),
        const Divider(thickness: .5),
        _ContactItem(label: 'Phone', value: user.phone ?? 'N/A'),
        const Divider(thickness: .5),
        if (student != null) ...[
          _ContactItem(
            label: 'Blood Group',
            value: (student as dynamic).bloodGroup.isNotEmpty
                ? (student as dynamic).bloodGroup
                : 'N/A',
          ),
          const Divider(thickness: .5),
          _ContactItem(
            label: 'Hall',
            value:
                (student as dynamic).hallName ??
                (student as dynamic).hallId ??
                'N/A',
          ),
        ] else ...[
          _ContactItem(label: 'Blood Group', value: user.blood ?? 'N/A'),
          const Divider(thickness: .5),
          _ContactItem(label: 'Hall', value: user.hall ?? 'N/A'),
        ],
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final String label;
  final String value;

  const _ContactItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
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
    );
  }
}
