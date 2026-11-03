import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/features/auth/domain/entities/moderator_role.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/app_loader.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/pill_tab_bar.dart';
import '/core/widgets/section_card.dart';
import '/utils/constants.dart';
import '../../data/moderation_api.dart';

class ModeratorPanelScreen extends ConsumerStatefulWidget {
  const ModeratorPanelScreen({super.key});

  @override
  ConsumerState<ModeratorPanelScreen> createState() =>
      _ModeratorPanelScreenState();
}

class _ModeratorPanelScreenState extends ConsumerState<ModeratorPanelScreen> {
  int _selectedRole = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final roles = user?.moderatorRoles ?? const <ModeratorRole>[];
    final role = roles.isEmpty
        ? null
        : roles[_selectedRole.clamp(0, roles.length - 1)];
    final tabLabels = <String>[];
    final views = <Widget>[];

    if (role?.permissions.contains('codes.view') ?? false) {
      tabLabels.add('Codes');
      views.add(_CodesTab(role: role));
    }
    if (role?.permissions.contains('verifications.review') ?? false) {
      tabLabels.add('Requests');
      views.add(_VerificationsTab(role: role!));
    }
    if (role?.permissions.contains('resources.review') ?? false) {
      tabLabels.add('Resources');
      views.add(_ResourcesTab(role: role!));
    }

    if (tabLabels.isEmpty) {
      return CustomHeaderLayout(
        title: 'Moderator Panel',
        showSearchBar: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.shieldAlert,
                  size: 36,
                  color: context.colors.textSubtle,
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  'No moderation permissions are active.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.textMuted),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      key: ValueKey(role?.id ?? 'moderator-no-scope'),
      length: tabLabels.length,
      child: Builder(
        builder: (context) => CustomHeaderLayout(
          title: 'Moderator Panel',
          showSearchBar: false,
          body: Column(
            children: [
              if (role != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.sm),
                        child: Text(
                          role.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      _ScopeSelector(
                        roles: roles,
                        selectedIndex: _selectedRole.clamp(0, roles.length - 1),
                        onChanged: (index) =>
                            setState(() => _selectedRole = index),
                      ),
                    ],
                  ),
                ),
              _ModerationOverview(roles: roles),
              if (tabLabels.length > 1)
                PillTabBar(
                  controller: DefaultTabController.of(context),
                  labels: tabLabels,
                ),
              Expanded(child: TabBarView(children: views)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScopeSelector extends StatelessWidget {
  const _ScopeSelector({
    required this.roles,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<ModeratorRole> roles;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final role = roles[selectedIndex];
    return SectionCard(
      padding: const EdgeInsets.all(Spacing.md),
      shadow: false,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.primarySubtle,
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Icon(
              LucideIcons.shieldCheck,
              size: 20,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(
              role.scopeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: context.colors.textMuted),
            ),
          ),
          if (roles.length > 1)
            PopupMenuButton<int>(
              tooltip: 'Change moderation scope',
              initialValue: selectedIndex,
              onSelected: onChanged,
              icon: Icon(
                LucideIcons.chevronsUpDown,
                size: 20,
                color: context.colors.textMuted,
              ),
              itemBuilder: (context) => [
                for (var i = 0; i < roles.length; i++)
                  PopupMenuItem(
                    value: i,
                    child: Text(
                      '${roles[i].title} · ${roles[i].scopeName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ModerationOverview extends ConsumerWidget {
  const _ModerationOverview({required this.roles});

  final List<ModeratorRole> roles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(moderationDashboardProvider);
    final canViewCodes = roles.any(
      (role) => role.permissions.contains('codes.view'),
    );
    final canReviewVerifications = roles.any(
      (role) => role.permissions.contains('verifications.review'),
    );
    final canReviewResources = roles.any(
      (role) => role.permissions.contains('resources.review'),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: dashboard.when(
        data: (summary) {
          final metrics = <({IconData icon, String label, int value})>[
            (
              icon: LucideIcons.inbox,
              label: 'Total pending',
              value: summary.totalPending,
            ),
            if (canViewCodes)
              (
                icon: LucideIcons.keyRound,
                label: 'Codes',
                value: summary.pendingCodes,
              ),
            if (canReviewVerifications)
              (
                icon: LucideIcons.fileCheck2,
                label: 'Requests',
                value: summary.pendingVerifications,
              ),
            if (canReviewResources)
              (
                icon: LucideIcons.bookOpen,
                label: 'Resources',
                value: summary.pendingResources,
              ),
          ];

          return SectionCard(
            padding: const EdgeInsets.all(Spacing.md),
            shadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending activity',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  'Across your assigned moderation scopes',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: context.colors.textMuted),
                ),
                const SizedBox(height: Spacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - Spacing.sm) / 2;
                    return Wrap(
                      spacing: Spacing.sm,
                      runSpacing: Spacing.sm,
                      children: [
                        for (final metric in metrics)
                          SizedBox(
                            width: width,
                            child: _ModerationMetric(
                              icon: metric.icon,
                              label: metric.label,
                              value: metric.value,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => SectionCard(
          padding: const EdgeInsets.all(Spacing.md),
          shadow: false,
          child: const Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: Spacing.md),
              Text('Loading moderation statistics…'),
            ],
          ),
        ),
        error: (error, _) => SectionCard(
          padding: const EdgeInsets.all(Spacing.md),
          shadow: false,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  moderationErrorMessage(error),
                  style: TextStyle(color: context.colors.danger),
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(moderationDashboardProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModerationMetric extends StatelessWidget {
  const _ModerationMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Spacing.sm),
    decoration: BoxDecoration(
      color: context.colors.surfaceAlt,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      border: Border.all(color: context.colors.border),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: context.colors.primary),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: context.colors.textMuted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CodesTab extends ConsumerStatefulWidget {
  const _CodesTab({required this.role});

  final ModeratorRole? role;

  @override
  ConsumerState<_CodesTab> createState() => _CodesTabState();
}

class _CodesTabState extends ConsumerState<_CodesTab> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    if (role == null) return const SizedBox.shrink();
    final studentsAsync = ref.watch(
      moderationStudentsProvider((
        scopeType: role.scopeType,
        scopeId: role.scopeId,
        query: _query,
      )),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.lg,
            Spacing.lg,
            Spacing.sm,
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search by name or roll',
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(LucideIcons.x),
              ),
              filled: true,
              fillColor: context.colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RadiusToken.lg),
                borderSide: BorderSide(color: context.colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RadiusToken.lg),
                borderSide: BorderSide(color: context.colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RadiusToken.lg),
                borderSide: BorderSide(
                  color: context.colors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onSubmitted: (value) => setState(() => _query = value.trim()),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                moderationStudentsProvider((
                  scopeType: role.scopeType,
                  scopeId: role.scopeId,
                  query: _query,
                )),
              );
              ref.invalidate(moderationDashboardProvider);
            },
            child: studentsAsync.when(
              data: (students) => students.isEmpty
                  ? const _EmptyPanel(message: 'No unclaimed students found.')
                  : ListView.separated(
                      padding: const EdgeInsets.all(Spacing.lg),
                      itemCount: students.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Spacing.md),
                      itemBuilder: (context, index) => _StudentCodeCard(
                        student: students[index],
                        role: role,
                        query: _query,
                      ),
                    ),
              loading: () => const Center(child: AppLoader()),
              error: (error, _) => _ErrorPanel(
                message: moderationErrorMessage(error),
                onRetry: () => ref.invalidate(
                  moderationStudentsProvider((
                    scopeType: role.scopeType,
                    scopeId: role.scopeId,
                    query: _query,
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentCodeCard extends ConsumerWidget {
  const _StudentCodeCard({
    required this.student,
    required this.role,
    required this.query,
  });

  final ModerationStudent student;
  final ModeratorRole role;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = student.verificationCode;
    return SectionCard(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student.name.isEmpty ? 'Student' : student.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (student.roll.isNotEmpty)
            Text(
              'Roll: ${student.roll}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (student.batchName?.isNotEmpty ?? false)
            Text(
              student.batchName!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const SizedBox(height: 8),
          SelectableText(
            code.isEmpty ? 'No code available' : code,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: code.isEmpty
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: code));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code copied')),
                          );
                        }
                      },
                icon: const Icon(LucideIcons.copy, size: 16),
                label: const Text('Copy'),
              ),
              TextButton.icon(
                onPressed: code.isEmpty
                    ? null
                    : () => SharePlus.instance.share(
                        ShareParams(
                          text:
                              'Your Campus Assistant verification code is $code. '
                              'Use it in the app to claim your student profile.\n'
                              '$kPlayStoreUrl',
                        ),
                      ),
                icon: const Icon(LucideIcons.share2, size: 16),
                label: const Text('Share'),
              ),
              TextButton.icon(
                onPressed: () =>
                    _regenerateCode(context, ref, student, role, query),
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: const Text('Regenerate'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _regenerateCode(
    BuildContext context,
    WidgetRef ref,
    ModerationStudent student,
    ModeratorRole role,
    String query,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Regenerate verification code?'),
        content: const Text(
          'The current code will stop working. Share the new code only with the student.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: const Text('Regenerate'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final code = await regenerateStudentCode(ref, student.id);
      ref.invalidate(
        moderationStudentsProvider((
          scopeType: role.scopeType,
          scopeId: role.scopeId,
          query: query,
        )),
      );
      ref.invalidate(moderationDashboardProvider);
      if (!context.mounted) return;
      if (code.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code regenerated successfully')),
        );
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('New verification code'),
          content: SelectableText(code),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (context.mounted) context.pop();
              },
              child: const Text('Copy'),
            ),
            TextButton(
              onPressed: () => SharePlus.instance.share(
                ShareParams(
                  text:
                      'Your Campus Assistant verification code is $code. '
                      'Use it in the app to claim your student profile.\n'
                      '$kPlayStoreUrl',
                ),
              ),
              child: const Text('Share'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(moderationErrorMessage(error))));
    }
  }
}

class _VerificationsTab extends ConsumerWidget {
  const _VerificationsTab({required this.role});

  final ModeratorRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(moderationVerificationsProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(moderationVerificationsProvider);
        ref.invalidate(moderationDashboardProvider);
      },
      child: requestsAsync.when(
        data: (requests) {
          final scopedRequests = requests
              .where((request) => request.isInScope(role))
              .toList();
          return scopedRequests.isEmpty
              ? const _EmptyPanel(
                  message: 'No pending verification requests in this scope.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: scopedRequests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final request = scopedRequests[index];
                    return SectionCard(
                      padding: const EdgeInsets.all(Spacing.md),
                      onTap: () => _openVerification(context, ref, request.id),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: context.colors.primarySubtle,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.fileCheck2,
                              size: 20,
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: Spacing.xxs),
                                Text(
                                  [
                                    if (request.studentNumber.isNotEmpty)
                                      'Student ID ${request.studentNumber}',
                                    if (request.batchName?.isNotEmpty ?? false)
                                      request.batchName!,
                                    if (request.phone.isNotEmpty) request.phone,
                                  ].join(' · '),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.colors.textMuted,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 18,
                            color: context.colors.textSubtle,
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
        loading: () => const Center(child: AppLoader()),
        error: (error, _) => _ErrorPanel(
          message: moderationErrorMessage(error),
          onRetry: () => ref.invalidate(moderationVerificationsProvider),
        ),
      ),
    );
  }

  Future<void> _openVerification(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    try {
      final request = await getModerationVerification(ref, id);
      if (!context.mounted) return;
      final reviewed = await showDialog<bool>(
        context: context,
        builder: (_) => _VerificationDialog(request: request),
      );
      if (reviewed == true) {
        ref.invalidate(moderationVerificationsProvider);
        ref.invalidate(moderationDashboardProvider);
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(moderationErrorMessage(error))));
    }
  }
}

class _VerificationDialog extends ConsumerStatefulWidget {
  const _VerificationDialog({required this.request});

  final ModerationVerification request;

  @override
  ConsumerState<_VerificationDialog> createState() =>
      _VerificationDialogState();
}

class _VerificationDialogState extends ConsumerState<_VerificationDialog> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return AlertDialog(
      title: Text(request.name.isEmpty ? 'Verification request' : request.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (request.studentNumber.isNotEmpty)
              Text('Student ID: ${request.studentNumber}'),
            if (request.phone.isNotEmpty) Text('Phone: ${request.phone}'),
            if (request.departmentName?.isNotEmpty ?? false)
              Text('Department: ${request.departmentName}'),
            if (request.batchName?.isNotEmpty ?? false)
              Text('Batch: ${request.batchName}'),
            const SizedBox(height: 16),
            _DocumentLink(
              label: 'Student ID document',
              url: request.idDocumentUrl,
            ),
            _DocumentLink(
              label: request.secondDocumentType.isEmpty
                  ? 'Supporting document'
                  : request.secondDocumentType,
              url: request.secondDocumentUrl,
            ),
            if (request.idDocumentUrl == null &&
                request.secondDocumentUrl == null)
              const Text(
                'Document previews are unavailable. Refresh and retry.',
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => context.pop(false),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: _busy ? null : () => _reject(context),
          child: const Text('Reject'),
        ),
        FilledButton(
          onPressed: _busy ? null : () => _review(context, approve: true),
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Approve'),
        ),
      ],
    );
  }

  Future<void> _reject(BuildContext context) async {
    final reason = await _askForReason(context, title: 'Reject request');
    if (reason == null || !context.mounted) return;
    await _review(context, approve: false, reason: reason);
  }

  Future<void> _review(
    BuildContext context, {
    required bool approve,
    String? reason,
  }) async {
    setState(() => _busy = true);
    try {
      await reviewVerification(
        ref,
        id: widget.request.id,
        approve: approve,
        reason: reason,
      );
      if (context.mounted) context.pop(true);
    } catch (error) {
      if (!context.mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(moderationErrorMessage(error))));
    }
  }
}

class _DocumentLink extends StatelessWidget {
  const _DocumentLink({required this.label, required this.url});

  final String label;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(LucideIcons.fileText),
      title: Text(label),
      subtitle: Text(
        url?.isNotEmpty == true ? 'Open secure preview' : 'Unavailable',
      ),
      trailing: const Icon(LucideIcons.externalLink, size: 18),
      onTap: url?.isNotEmpty == true
          ? () =>
                launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)
          : null,
    );
  }
}

class _ResourcesTab extends ConsumerWidget {
  const _ResourcesTab({required this.role});

  final ModeratorRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(moderationResourcesProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(moderationResourcesProvider);
        ref.invalidate(moderationDashboardProvider);
      },
      child: resourcesAsync.when(
        data: (resources) {
          final scopedResources = resources
              .where((resource) => resource.isInScope(role))
              .toList();
          return scopedResources.isEmpty
              ? const _EmptyPanel(
                  message: 'No pending resources in this scope.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: scopedResources.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final resource = scopedResources[index];
                    return SectionCard(
                      padding: const EdgeInsets.all(Spacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [
                              resource.type,
                              if (resource.creatorName?.isNotEmpty ?? false)
                                'by ${resource.creatorName}',
                              if (resource.departmentName?.isNotEmpty ?? false)
                                resource.departmentName!,
                            ].join(' · '),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (resource.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(resource.description),
                          ],
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton.icon(
                                onPressed: resource.fileUrl.isEmpty
                                    ? null
                                    : () => launchUrl(
                                        Uri.parse(resource.fileUrl),
                                        mode: LaunchMode.externalApplication,
                                      ),
                                icon: const Icon(LucideIcons.eye, size: 16),
                                label: const Text('Preview'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _rejectResource(context, ref, resource.id),
                                child: const Text('Reject'),
                              ),
                              FilledButton(
                                onPressed: () => _reviewResource(
                                  context,
                                  ref,
                                  resource.id,
                                  approve: true,
                                ),
                                child: const Text('Approve'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
        loading: () => const Center(child: AppLoader()),
        error: (error, _) => _ErrorPanel(
          message: moderationErrorMessage(error),
          onRetry: () => ref.invalidate(moderationResourcesProvider),
        ),
      ),
    );
  }

  Future<void> _rejectResource(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final reason = await _askForReason(context, title: 'Reject resource');
    if (reason == null || !context.mounted) return;
    await _reviewResource(context, ref, id, approve: false, reason: reason);
  }

  Future<void> _reviewResource(
    BuildContext context,
    WidgetRef ref,
    String id, {
    required bool approve,
    String? reason,
  }) async {
    try {
      await reviewResource(ref, id: id, approve: approve, reason: reason);
      ref.invalidate(moderationResourcesProvider);
      ref.invalidate(moderationDashboardProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(approve ? 'Resource approved' : 'Resource rejected'),
          ),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(moderationErrorMessage(error))));
    }
  }
}

Future<String?> _askForReason(
  BuildContext context, {
  required String title,
}) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 2,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: 'Reason',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final reason = controller.text.trim();
            if (reason.isNotEmpty) context.pop(reason);
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(Spacing.lg),
    children: [
      const SizedBox(height: Spacing.xxxl),
      SectionCard(
        padding: const EdgeInsets.all(Spacing.xl),
        shadow: false,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.colors.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.inbox,
                size: 24,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: context.colors.textMuted),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(Spacing.lg),
    children: [
      const SizedBox(height: Spacing.xxxl),
      SectionCard(
        padding: const EdgeInsets.all(Spacing.xl),
        shadow: false,
        child: Column(
          children: [
            Icon(
              LucideIcons.circleAlert,
              size: 36,
              color: context.colors.danger,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textMuted),
            ),
            const SizedBox(height: Spacing.sm),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    ],
  );
}
