import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/class_notice.dart';
import '../providers/class_notice_provider.dart';

/// Notices for the user's batch (plus department-wide ones), newest first.
class ClassNoticeTab extends ConsumerWidget {
  const ClassNoticeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(userProvider).value?.information;
    final scope = (
      departmentId: info?.departmentId ?? '',
      batchId: info?.batchId,
    );
    final isCr = info?.status?.cr ?? false;
    final noticesAsync = ref.watch(classNoticesProvider(scope));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(classNoticesProvider(scope));
        await ref.read(classNoticesProvider(scope).future);
      },
      child: noticesAsync.when(
        data: (notices) {
          if (notices.isEmpty) return const _EmptyNotices();
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(Spacing.lg),
            itemCount: notices.length,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, i) {
              final notice = notices[i];
              // The server re-checks this; here it only decides whether to
              // show the delete button.
              final canDelete = isCr && notice.batchId == info?.batchId;
              return _NoticeCard(notice: notice, canDelete: canDelete);
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: Spacing.md),
            Center(
              child: Text(
                "Couldn't load notices. Pull down to retry.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotices extends StatelessWidget {
  const _EmptyNotices();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(LucideIcons.megaphone, size: 56, color: colors.textSubtle),
        const SizedBox(height: Spacing.lg),
        Center(
          child: Text(
            'No notices right now',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Center(
          child: Text(
            'Class updates from your CR will show up here.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends ConsumerWidget {
  final ClassNotice notice;
  final bool canDelete;

  const _NoticeCard({required this.notice, required this.canDelete});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete notice?'),
        content: const Text('Your batch will no longer see it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await deleteClassNotice(ref, notice.id);
    } catch (_) {
      Fluttertoast.showToast(msg: 'Could not delete notice.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final url = ApiEndpoints.resolveImageUrl(notice.fileUrl);

    final meta = [
      if (notice.postedByName.isNotEmpty) notice.postedByName,
      '${notice.createdAt.day}/${notice.createdAt.month}/${notice.createdAt.year}',
      if (notice.expiresAt != null)
        'until ${notice.expiresAt!.day}/${notice.expiresAt!.month}',
    ].join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notice.isImage)
            GestureDetector(
              onTap: () => context.pushNamed(
                AppRoute.imageViewer.name,
                queryParameters: {
                  'title': notice.title,
                  'time': meta,
                  'image': notice.fileUrl,
                },
              ),
              child: CachedNetworkImage(
                imageUrl: url,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, _) => const SizedBox(
                  height: 200,
                  child: Center(child: CupertinoActivityIndicator()),
                ),
                errorWidget: (_, _, _) => SizedBox(
                  height: 120,
                  child: Center(
                    child: Icon(LucideIcons.image, color: colors.textSubtle),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notice.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (canDelete)
                      GestureDetector(
                        onTap: () => _confirmDelete(context, ref),
                        child: Icon(
                          LucideIcons.trash2,
                          size: 18,
                          color: colors.danger,
                        ),
                      ),
                  ],
                ),
                if (notice.message.isNotEmpty) ...[
                  const SizedBox(height: Spacing.sm),
                  Text(notice.message, style: textTheme.bodyMedium),
                ],
                if (notice.isPdf) ...[
                  const SizedBox(height: Spacing.md),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.fileText,
                          size: 16,
                          color: colors.primary,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          'Open PDF',
                          style: textTheme.labelLarge?.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.md),
                Text(
                  meta,
                  style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
