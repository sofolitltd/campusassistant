import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/network/api_endpoints.dart';
import '../../../reminders/presentation/widgets/set_reminder_sheet.dart';
import '../providers/circular_provider.dart';

class CircularDetailScreen extends ConsumerStatefulWidget {
  final String circularId;
  const CircularDetailScreen({super.key, required this.circularId});

  @override
  ConsumerState<CircularDetailScreen> createState() => _CircularDetailScreenState();
}

class _CircularDetailScreenState extends ConsumerState<CircularDetailScreen> {
  Timer? _countdownTimer;
  bool _viewRecorded = false;
  bool _saving = false;

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

  String _countdown(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    if (days > 0) return '${days}d ${hours}h left';
    if (hours > 0) return '${hours}h ${minutes}m left';
    return '${minutes}m left';
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _saveToMyJobs() async {
    setState(() => _saving = true);
    try {
      await ref.read(circularActionsProvider).saveToMyJobs(widget.circularId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to My Jobs')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final circularAsync = ref.watch(circularDetailProvider(widget.circularId));

    return Scaffold(
      appBar: AppBar(title: const Text('Circular Details')),
      body: circularAsync.when(
        data: (circular) {
          if (!_viewRecorded) {
            _viewRecorded = true;
            ref.read(circularActionsProvider).recordView(circular.id);
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (circular.attachmentUrls.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: PageView(
                      children: circular.attachmentUrls
                          .map((url) => CachedNetworkImage(
                                imageUrl: ApiEndpoints.resolveImageUrl(url),
                                fit: BoxFit.cover,
                              ))
                          .toList(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (circular.category != null)
                        Chip(label: Text(circular.category!.name)),
                      const SizedBox(height: 8),
                      Text(circular.title, style: Theme.of(context).textTheme.headlineSmall),
                      if (circular.organization.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(circular.organization, style: Theme.of(context).textTheme.titleSmall),
                      ],
                      const SizedBox(height: 12),
                      if (circular.description.isNotEmpty) Text(circular.description),
                      const SizedBox(height: 16),
                      if (circular.publishDate != null)
                        _InfoRow(icon: Icons.calendar_today_outlined, label: 'Published', value: _shortDate(circular.publishDate!)),
                      if (circular.deadlineDate != null)
                        _InfoRow(
                          icon: Icons.access_time,
                          label: 'Deadline',
                          value: '${_shortDate(circular.deadlineDate!)} (${_countdown(circular.deadlineDate!)})',
                          urgent: circular.isPastDeadline,
                        ),
                      const SizedBox(height: 12),
                      if (circular.postLink.isNotEmpty)
                        _LinkTile(label: 'Job Posting', url: circular.postLink, onTap: () => _openLink(circular.postLink)),
                      if (circular.resourceLink.isNotEmpty)
                        _LinkTile(label: 'Resources', url: circular.resourceLink, onTap: () => _openLink(circular.resourceLink)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _saving ? null : _saveToMyJobs,
                          icon: _saving
                              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.bookmark_add_outlined),
                          label: const Text('Save to My Jobs'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (circular.deadlineDate != null)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => showSetReminderSheet(
                              context,
                              ref,
                              suggestedTitle: 'Deadline: ${circular.title}',
                              suggestedTime: circular.deadlineDate!.subtract(const Duration(hours: 8)),
                            ),
                            icon: const Icon(Icons.notifications_active_outlined),
                            label: const Text('Set Reminder'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load circular: $err')),
      ),
    );
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool urgent;

  const _InfoRow({required this.icon, required this.label, required this.value, this.urgent = false});

  @override
  Widget build(BuildContext context) {
    final color = urgent ? Theme.of(context).colorScheme.error : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600, color: color)),
          Expanded(child: Text(value, style: TextStyle(color: color))),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String label;
  final String url;
  final VoidCallback onTap;

  const _LinkTile({required this.label, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.link),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: onTap,
      ),
    );
  }
}
