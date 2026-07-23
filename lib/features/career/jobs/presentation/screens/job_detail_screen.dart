import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/routes/app_route.dart';
import '../../../reminders/presentation/widgets/set_reminder_sheet.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import '../widgets/job_detail_helpers.dart';
import '../widgets/job_status_badge.dart';

/// Ported "same to same" from personalassistant's JobDetailsScreen: media
/// gallery, title/org header, tappable status badge, info cards
/// (Published/Deadline-with-live-countdown), link sections. Two differences
/// from the reference, both consequences of this app's data model rather
/// than styling choices:
///  - No "Share to Circular" action — sharing scope (batch/department/
///    university) is chosen once at creation time (see CreateJobScreen),
///    not toggled from the detail page.
///  - "Add Reminder" lives in the app bar menu instead of Edit, since
///    reminders here are a separate server-scheduled entity, not a field
///    edited inline on the job.
class JobDetailScreen extends ConsumerStatefulWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _timeLeft(DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final parts = <String>[];
    if (days > 0) parts.add('${days}d');
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0 || parts.isEmpty) parts.add('${minutes}m');
    return parts.join(' ');
  }

  Future<void> _confirmDelete(CareerJob job) async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
        title: const Text('Delete this job?'),
        content: const Text('This will permanently remove the job from your list.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: cs.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(careerJobActionsProvider).deleteJob(job.id);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final jobAsync = ref.watch(careerJobByIdProvider(widget.jobId));

    return jobAsync.when(
      data: (job) {
        if (job == null) {
          return const Scaffold(body: Center(child: Text('Job not found')));
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Job', style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: CircleAvatar(
                backgroundColor: cs.surfaceContainerHighest,
                child: Icon(LucideIcons.arrowLeft, size: 16, color: cs.onSurface),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  backgroundColor: cs.surfaceContainerHighest,
                  child: Icon(LucideIcons.moreHorizontal, color: cs.onSurface),
                ),
                shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
                onSelected: (value) {
                  if (value == 'edit') {
                    context.pushNamed(AppRoute.careerJobEdit.name, pathParameters: {'jobId': job.id}, extra: job);
                  } else if (value == 'reminder') {
                    showSetReminderSheet(
                      context,
                      ref,
                      jobId: job.id,
                      suggestedTitle: job.title,
                      suggestedTime: job.deadlineDate?.subtract(const Duration(hours: 8)),
                    );
                  } else if (value == 'delete') {
                    _confirmDelete(job);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.edit3, color: cs.onSurface, size: 18),
                        const SizedBox(width: Spacing.md),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'reminder',
                    child: Row(
                      children: [
                        Icon(LucideIcons.bell, color: cs.primary, size: 18),
                        const SizedBox(width: Spacing.md),
                        const Text('Add Reminder'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, color: cs.error, size: 18),
                        const SizedBox(width: Spacing.md),
                        Text('Delete', style: TextStyle(color: cs.error)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.md),
            ],
          ),
          body: SafeArea(
            child: Container(
              color: cs.surface,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (job.attachmentUrls.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: PageView(
                          children: job.attachmentUrls
                              .map((url) => CachedNetworkImage(
                                    imageUrl: ApiEndpoints.resolveImageUrl(url),
                                    fit: BoxFit.cover,
                                  ))
                              .toList(),
                        ),
                      )
                    else
                      buildEmptyJobMedia(context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.xl, Spacing.xxl, Spacing.xxl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          if (job.organization.isNotEmpty)
                            Text(
                              job.organization,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(height: Spacing.xxl),
                          Row(
                            children: [
                              JobStatusBadge(job: job),
                              if (job.scope != CareerJobScope.private_) ...[
                                const SizedBox(width: Spacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
                                  decoration: BoxDecoration(
                                    color: cs.primaryContainer,
                                    borderRadius: RadiusToken.circular(RadiusToken.sm),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(LucideIcons.radio, size: 12, color: cs.primary),
                                      const SizedBox(width: Spacing.sm),
                                      Text(
                                        'Shared with ${_scopeLabel(job.scope)}',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: Spacing.xxxl),
                          if (job.publishDate != null)
                            buildJobInfoCard(context, LucideIcons.calendar, 'Published', job.publishDate!),
                          if (job.deadlineDate != null)
                            buildJobInfoCard(
                              context,
                              LucideIcons.clock,
                              'Deadline',
                              job.deadlineDate!,
                              isUrgent: true,
                              timeLeft: _timeLeft(job.deadlineDate!),
                            ),
                          if (job.notes.isNotEmpty) ...[
                            Text(job.notes, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: Spacing.xl),
                          ],
                          if (job.postLink.isNotEmpty)
                            buildJobLinkSection(context, 'Job Posting', job.postLink, LucideIcons.externalLink),
                          if (job.resourceLink.isNotEmpty)
                            buildJobLinkSection(context, 'Resources', job.resourceLink, LucideIcons.link),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Failed to load job: $err'))),
    );
  }

  String _scopeLabel(CareerJobScope scope) {
    switch (scope) {
      case CareerJobScope.batch:
        return 'Batch';
      case CareerJobScope.department:
        return 'Department';
      case CareerJobScope.university:
        return 'University';
      case CareerJobScope.private_:
        return '';
    }
  }
}
