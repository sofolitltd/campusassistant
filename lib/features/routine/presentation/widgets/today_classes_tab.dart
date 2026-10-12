import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/class_slot.dart';
import '../providers/class_slot_provider.dart';
import 'manage_schedule_screen.dart';

String _fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Today's classes for the signed-in user's own batch, with status
/// (held/cancelled/rescheduled). CRs enter the weekly routine once at the
/// start of the semester (via "Manage"), then only mark changes here.
class TodayClassesTab extends ConsumerWidget {
  const TodayClassesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(userProvider).value?.information;
    final departmentId = info?.departmentId ?? '';
    final batchId = info?.batchId ?? '';
    final isCr = info?.status?.cr ?? false;
    final isAdmin = info?.status?.admin ?? false;
    // The server re-checks this; here it only decides whether to show the
    // manage/status-change affordances.
    final canManage = isAdmin || isCr;

    final today = DateTime.now();
    final dow = today.weekday % 7; // Mon=1..Sun=7 -> 0=Sunday..6=Saturday
    final dateStr = _fmtDate(today);

    final slotsAsync = ref.watch(
      classSlotsProvider((departmentId: departmentId, batchId: batchId)),
    );
    final statusesAsync = ref.watch(
      classSlotStatusesProvider((
        departmentId: departmentId,
        batchId: batchId,
        date: dateStr,
      )),
    );

    if (batchId.isEmpty) {
      return const _EmptySchedule(
        message: 'Your batch is not set up yet, so there is no schedule to show.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
          classSlotsProvider((departmentId: departmentId, batchId: batchId)),
        );
        ref.invalidate(
          classSlotStatusesProvider((
            departmentId: departmentId,
            batchId: batchId,
            date: dateStr,
          )),
        );
      },
      child: slotsAsync.when(
        data: (slots) {
          final todaySlots =
              slots.where((s) => s.dayOfWeek == dow).toList()
                ..sort((a, b) => a.startTime.compareTo(b.startTime));
          final statuses = statusesAsync.value ?? [];

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              if (canManage)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ManageScheduleScreen(
                          universityId: info?.universityId ?? '',
                          departmentId: departmentId,
                          batchId: batchId,
                          slots: slots,
                        ),
                      ),
                    ),
                    icon: const Icon(LucideIcons.settings2, size: 16),
                    label: const Text('Manage schedule'),
                  ),
                ),
              if (todaySlots.isEmpty)
                const _EmptySchedule(
                  message:
                      'No classes scheduled for today. The CR enters the weekly routine once from the printed schedule, then only marks changes here.',
                )
              else
                ...todaySlots.map((slot) {
                  final status = statuses
                      .where((s) => s.classSlotId == slot.id)
                      .cast<ClassSlotStatus?>()
                      .firstWhere((_) => true, orElse: () => null);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.md),
                    child: _SlotCard(
                      slot: slot,
                      status: status,
                      canManage: canManage,
                      departmentId: departmentId,
                      batchId: batchId,
                      date: today,
                    ),
                  );
                }),
            ],
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
                "Couldn't load today's classes. Pull down to retry.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySchedule extends StatelessWidget {
  final String message;
  const _EmptySchedule({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(LucideIcons.calendarClock, size: 56, color: colors.textSubtle),
          const SizedBox(height: Spacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends ConsumerWidget {
  final ClassSlot slot;
  final ClassSlotStatus? status;
  final bool canManage;
  final String departmentId;
  final String batchId;
  final DateTime date;

  const _SlotCard({
    required this.slot,
    required this.status,
    required this.canManage,
    required this.departmentId,
    required this.batchId,
    required this.date,
  });

  Future<void> _openActions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => _StatusActionSheet(
        slot: slot,
        status: status,
        departmentId: departmentId,
        batchId: batchId,
        date: date,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    final isCancelled = status?.isCancelled ?? false;
    final isRescheduled = status?.isRescheduled ?? false;
    final timeRange = isRescheduled
        ? '${status!.newStartTime}–${status!.newEndTime}'
        : '${slot.startTime}–${slot.endTime}';
    final room = isRescheduled ? status!.newRoom : slot.room;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.courseName,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isCancelled
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  [
                    timeRange,
                    if (room.isNotEmpty) room,
                    if (slot.teacher.isNotEmpty) slot.teacher,
                  ].join(' · '),
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                if (status?.note.isNotEmpty ?? false) ...[
                  const SizedBox(height: Spacing.xs),
                  Text(
                    status!.note,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          _StatusBadge(status: status),
          if (canManage)
            IconButton(
              onPressed: () => _openActions(context, ref),
              icon: const Icon(LucideIcons.ellipsisVertical, size: 18),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ClassSlotStatus? status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (label, color) = switch (status?.status) {
      'cancelled' => ('Cancelled', colors.danger),
      'rescheduled' => ('Rescheduled', colors.warning),
      _ => ('Held', colors.success),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusActionSheet extends ConsumerStatefulWidget {
  final ClassSlot slot;
  final ClassSlotStatus? status;
  final String departmentId;
  final String batchId;
  final DateTime date;

  const _StatusActionSheet({
    required this.slot,
    required this.status,
    required this.departmentId,
    required this.batchId,
    required this.date,
  });

  @override
  ConsumerState<_StatusActionSheet> createState() =>
      _StatusActionSheetState();
}

class _StatusActionSheetState extends ConsumerState<_StatusActionSheet> {
  bool _reschedule = false;
  bool _submitting = false;
  late final _startController = TextEditingController(
    text: widget.status?.newStartTime.isNotEmpty == true
        ? widget.status!.newStartTime
        : widget.slot.startTime,
  );
  late final _endController = TextEditingController(
    text: widget.status?.newEndTime.isNotEmpty == true
        ? widget.status!.newEndTime
        : widget.slot.endTime,
  );
  late final _roomController = TextEditingController(
    text: widget.status?.newRoom.isNotEmpty == true
        ? widget.status!.newRoom
        : widget.slot.room,
  );
  late final _noteController = TextEditingController(
    text: widget.status?.note ?? '',
  );

  @override
  void initState() {
    super.initState();
    _reschedule = widget.status?.isRescheduled ?? false;
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _roomController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _markHeld() async {
    if (widget.status == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _submitting = true);
    try {
      await deleteClassSlotStatus(
        ref,
        id: widget.status!.id,
        departmentId: widget.departmentId,
        batchId: widget.batchId,
        date: widget.date,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      Fluttertoast.showToast(msg: 'Could not update status.');
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submit(String status) async {
    setState(() => _submitting = true);
    try {
      await setClassSlotStatus(
        ref,
        classSlotId: widget.slot.id,
        departmentId: widget.departmentId,
        batchId: widget.batchId,
        date: widget.date,
        status: status,
        newStartTime: status == 'rescheduled' ? _startController.text : '',
        newEndTime: status == 'rescheduled' ? _endController.text : '',
        newRoom: status == 'rescheduled' ? _roomController.text : '',
        note: _noteController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      Fluttertoast.showToast(msg: 'Could not update status.');
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Spacing.lg,
        right: Spacing.lg,
        top: Spacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + Spacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.slot.courseName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Spacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.rotateCcw),
              title: const Text('Mark held'),
              onTap: _submitting ? null : _markHeld,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.ban),
              title: const Text('Mark cancelled'),
              onTap: _submitting ? null : () => _submit('cancelled'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(LucideIcons.clock3),
              title: const Text('Reschedule'),
              value: _reschedule,
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _reschedule = v),
            ),
            if (_reschedule) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        labelText: 'New start (HH:MM)',
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _endController,
                      decoration: const InputDecoration(
                        labelText: 'New end (HH:MM)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              TextField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'New room'),
              ),
              const SizedBox(height: Spacing.sm),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: Spacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting ? null : () => _submit('rescheduled'),
                  child: _submitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save reschedule'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
