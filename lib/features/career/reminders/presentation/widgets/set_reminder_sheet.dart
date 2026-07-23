import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/career_reminder_provider.dart';

/// Bottom sheet to create a reminder — title + date/time picker, optionally
/// pre-filled (e.g. "8 hours before a circular's deadline") and optionally
/// tied to a job. Delivery is server-driven (FCM push from the Go
/// scheduler), so this just schedules the row — no local alarm involved.
Future<bool?> showSetReminderSheet(
  BuildContext context,
  WidgetRef ref, {
  String? jobId,
  String suggestedTitle = '',
  DateTime? suggestedTime,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: _SetReminderForm(
        jobId: jobId,
        suggestedTitle: suggestedTitle,
        suggestedTime: suggestedTime,
      ),
    ),
  );
}

class _SetReminderForm extends ConsumerStatefulWidget {
  final String? jobId;
  final String suggestedTitle;
  final DateTime? suggestedTime;

  const _SetReminderForm({this.jobId, required this.suggestedTitle, this.suggestedTime});

  @override
  ConsumerState<_SetReminderForm> createState() => _SetReminderFormState();
}

class _SetReminderFormState extends ConsumerState<_SetReminderForm> {
  late final TextEditingController _titleController;
  DateTime? _remindAt;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.suggestedTitle);
    final suggested = widget.suggestedTime;
    _remindAt = (suggested != null && suggested.isAfter(DateTime.now()))
        ? suggested
        : DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _remindAt!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_remindAt!),
    );
    if (time == null) return;
    setState(() {
      _remindAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty || _remindAt == null) return;
    if (!_remindAt!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder time must be in the future')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(careerReminderActionsProvider).createReminder(
            jobId: widget.jobId,
            title: _titleController.text.trim(),
            remindAt: _remindAt!,
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set reminder: $e')),
        );
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Set a reminder', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_remindAt == null ? 'Pick date & time' : _formatDateTime(_remindAt!)),
          trailing: const Icon(Icons.edit_calendar_outlined),
          onTap: _pickDateTime,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save Reminder'),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day}/${dt.month}/${dt.year} $hour:$minute $period';
  }
}
