import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/presentation/providers/student_provider.dart';

/// Opens the full profile dialog for the user who uploaded a resource.
///
/// When [userId] is null (teacher/staff/admin uploads, legacy data) only the
/// [fallbackName] is shown. When it is set, the full student profile is
/// fetched via [studentByUserIdProvider] and rendered.
Future<void> showUserProfileDialog(
  BuildContext context, {
  required String? userId,
  required String fallbackName,
}) => showDialog(
    context: context,
    builder: (dialogContext) => userId == null
        ? _FallbackProfileDialog(name: fallbackName)
        : _UserProfileDialog(userId: userId, fallbackName: fallbackName),
  );

class _UserProfileDialog extends ConsumerWidget {
  final String userId;
  final String fallbackName;

  const _UserProfileDialog({
    required this.userId,
    required this.fallbackName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentByUserIdProvider(userId));

    return AlertDialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      contentPadding: EdgeInsets.zero,
      clipBehavior: .antiAlias,
      content: SizedBox(
        width: double.maxFinite,
        child: studentAsync.when(
          data: (student) => _ProfileBody(
            student: student,
            fallbackName: fallbackName,
          ),
          loading: () => _LoadingBody(fallbackName: fallbackName),
          error: (_, _) => _FallbackBody(name: fallbackName),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final Student? student;
  final String fallbackName;

  const _ProfileBody({required this.student, required this.fallbackName});

  @override
  Widget build(BuildContext context) {
    final s = student;
    final name = s?.name ?? fallbackName;

    final rows = <(IconData, String, String)>[];
    void addRow(IconData icon, String label, String? value) {
      if (value != null && value.isNotEmpty) rows.add((icon, label, value));
    }

    addRow(LucideIcons.building2, 'University', s?.universityName);
    addRow(LucideIcons.school, 'Department', s?.departmentName);
    addRow(LucideIcons.users, 'Batch', s?.batchName);
    addRow(LucideIcons.calendarRange, 'Session', s?.sessionName);

        final studentId = s?.studentId;
        final imageUrl = s?.imageUrl ?? '';
        final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Column(
      mainAxisSize: .min,
      children: [
        const SizedBox(height: Spacing.lg),
        CircleAvatar(
          radius: 36,
          backgroundColor: context.colors.primarySubtle,
          backgroundImage: imageUrl.isNotEmpty
              ? CachedNetworkImageProvider(
                  ApiEndpoints.resolveImageUrl(imageUrl),
                )
              : null,
          child: imageUrl.isEmpty
              ? Text(
                  initial,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: .bold,
                  ),
                )
              : null,
        ),
        const SizedBox(height: Spacing.md),
        Text(
          name,
          textAlign: .center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: .w700,
            color: context.colors.text,
          ),
        ),
        if (studentId != null && studentId.isNotEmpty) ...[
          const SizedBox(height: Spacing.xs),
          Text(
            studentId,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ],
        if (s == null) ...[
          const SizedBox(height: Spacing.xs),
          Text(
            'No profile details available.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.textSubtle,
            ),
          ),
        ],
        const SizedBox(height: Spacing.lg),
        const Divider(height: 1),
        const SizedBox(height: Spacing.xs),
        ...rows.map(
          (r) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: 7,
            ),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                Icon(r.$1, size: 16, color: context.colors.textSubtle),
                const SizedBox(width: Spacing.md),
                SizedBox(
                  width: 90,
                  child: Text(
                    '${r.$2}:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colors.textSubtle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    r.$3,
                    textAlign: .right,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: .w600,
                      color: context.colors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}

class _LoadingBody extends StatelessWidget {
  final String fallbackName;

  const _LoadingBody({required this.fallbackName});

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            fallbackName,
            textAlign: .center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: .w700,
              color: context.colors.text,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          const CircularProgressIndicator(),
          const SizedBox(height: Spacing.lg),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
}

class _FallbackProfileDialog extends StatelessWidget {
  final String name;

  const _FallbackProfileDialog({required this.name});

  @override
  Widget build(BuildContext context) => _FallbackBody(name: name);
}

class _FallbackBody extends StatelessWidget {
  final String name;

  const _FallbackBody({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return AlertDialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      contentPadding: EdgeInsets.zero,
      clipBehavior: .antiAlias,
      content: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisSize: .min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: context.colors.primarySubtle,
                child: Text(
                  initial,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: .bold,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              Text(
                name.isNotEmpty ? name : 'Unknown',
                textAlign: .center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: .w700,
                  color: context.colors.text,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'No profile details available.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textSubtle,
                ),
              ),
              const SizedBox(height: Spacing.md),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
