import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/class_slot.dart';
import '../providers/class_slot_provider.dart';

const _days = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

/// Lets the CR (or an admin) enter the weekly routine once at the start of a
/// semester: one card per class, grouped by day, with add/edit/delete.
class ManageScheduleScreen extends ConsumerWidget {
  final String universityId;
  final String departmentId;
  final String batchId;
  final List<ClassSlot> slots;

  const ManageScheduleScreen({
    super.key,
    required this.universityId,
    required this.departmentId,
    required this.batchId,
    required this.slots,
  });

  void _openForm(BuildContext context, ClassSlot? slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _SlotFormSheet(
        slot: slot,
        universityId: universityId,
        departmentId: departmentId,
        batchId: batchId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(
      classSlotsProvider((departmentId: departmentId, batchId: batchId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Schedule'),
        actions: [
          IconButton(
            onPressed: () => _openForm(context, null),
            icon: const Icon(LucideIcons.plus),
          ),
        ],
      ),
      body: slotsAsync.when(
        data: (slots) {
          if (slots.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Text(
                  'No classes added yet. Tap + to add this batch\'s weekly routine.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colors.textMuted,
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              for (var dow = 0; dow < 7; dow++)
                if (slots.any((s) => s.dayOfWeek == dow))
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _days[dow],
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: Spacing.sm),
                        ...(slots.where((s) => s.dayOfWeek == dow).toList()
                              ..sort(
                                (a, b) => a.startTime.compareTo(b.startTime),
                              ))
                            .map(
                              (slot) => _SlotRow(
                                slot: slot,
                                onTap: () => _openForm(context, slot),
                                departmentId: departmentId,
                                batchId: batchId,
                              ),
                            ),
                      ],
                    ),
                  ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load schedule: $e')),
      ),
    );
  }
}

class _SlotRow extends ConsumerWidget {
  final ClassSlot slot;
  final VoidCallback onTap;
  final String departmentId;
  final String batchId;

  const _SlotRow({
    required this.slot,
    required this.onTap,
    required this.departmentId,
    required this.batchId,
  });

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete class?'),
        content: Text('Remove ${slot.courseName} from the weekly schedule.'),
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
      await deleteClassSlot(
        ref,
        id: slot.id,
        departmentId: departmentId,
        batchId: batchId,
      );
    } catch (_) {
      Fluttertoast.showToast(msg: 'Could not delete class.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: colors.border),
      ),
      child: ListTile(
        title: Text(slot.courseName),
        subtitle: Text(
          [
            '${slot.startTime}–${slot.endTime}',
            if (slot.room.isNotEmpty) slot.room,
            if (slot.teacher.isNotEmpty) slot.teacher,
          ].join(' · '),
        ),
        trailing: IconButton(
          icon: Icon(LucideIcons.trash2, color: colors.danger, size: 18),
          onPressed: () => _confirmDelete(context, ref),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SlotFormSheet extends ConsumerStatefulWidget {
  final ClassSlot? slot;
  final String universityId;
  final String departmentId;
  final String batchId;

  const _SlotFormSheet({
    required this.slot,
    required this.universityId,
    required this.departmentId,
    required this.batchId,
  });

  @override
  ConsumerState<_SlotFormSheet> createState() => _SlotFormSheetState();
}

class _SlotFormSheetState extends ConsumerState<_SlotFormSheet> {
  late int _dayOfWeek = widget.slot?.dayOfWeek ?? 0;
  late final _courseController = TextEditingController(
    text: widget.slot?.courseName ?? '',
  );
  late final _teacherController = TextEditingController(
    text: widget.slot?.teacher ?? '',
  );
  late final _roomController = TextEditingController(
    text: widget.slot?.room ?? '',
  );
  late final _startController = TextEditingController(
    text: widget.slot?.startTime ?? '',
  );
  late final _endController = TextEditingController(
    text: widget.slot?.endTime ?? '',
  );
  bool _submitting = false;

  @override
  void dispose() {
    _courseController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final initial = controller.text.isNotEmpty
        ? TimeOfDay(
            hour: int.tryParse(controller.text.split(':').first) ?? 9,
            minute: int.tryParse(controller.text.split(':').last) ?? 0,
          )
        : TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      controller.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    final course = _courseController.text.trim();
    if (course.isEmpty) {
      Fluttertoast.showToast(msg: 'Course name is required.');
      return;
    }
    if (_startController.text.isEmpty || _endController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Start and end time are required.');
      return;
    }
    setState(() => _submitting = true);
    try {
      if (widget.slot != null) {
        await updateClassSlot(
          ref,
          id: widget.slot!.id,
          departmentId: widget.departmentId,
          batchId: widget.batchId,
          dayOfWeek: _dayOfWeek,
          courseName: course,
          teacher: _teacherController.text.trim(),
          room: _roomController.text.trim(),
          startTime: _startController.text,
          endTime: _endController.text,
        );
      } else {
        await createClassSlot(
          ref,
          universityId: widget.universityId,
          departmentId: widget.departmentId,
          batchId: widget.batchId,
          dayOfWeek: _dayOfWeek,
          courseName: course,
          teacher: _teacherController.text.trim(),
          room: _roomController.text.trim(),
          startTime: _startController.text,
          endTime: _endController.text,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      Fluttertoast.showToast(msg: 'Could not save class.');
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
              widget.slot == null ? 'Add class' : 'Edit class',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Spacing.lg),
            DropdownButtonFormField<int>(
              initialValue: _dayOfWeek,
              decoration: const InputDecoration(labelText: 'Day'),
              items: [
                for (var i = 0; i < 7; i++)
                  DropdownMenuItem(value: i, child: Text(_days[i])),
              ],
              onChanged: (v) => setState(() => _dayOfWeek = v ?? 0),
            ),
            const SizedBox(height: Spacing.sm),
            TextField(
              controller: _courseController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Course',
                hintText: 'e.g. Data Structures',
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startController,
                    readOnly: true,
                    onTap: () => _pickTime(_startController),
                    decoration: const InputDecoration(labelText: 'Start time'),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: TextField(
                    controller: _endController,
                    readOnly: true,
                    onTap: () => _pickTime(_endController),
                    decoration: const InputDecoration(labelText: 'End time'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            TextField(
              controller: _teacherController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Teacher (optional)'),
            ),
            const SizedBox(height: Spacing.sm),
            TextField(
              controller: _roomController,
              decoration: const InputDecoration(labelText: 'Room (optional)'),
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
