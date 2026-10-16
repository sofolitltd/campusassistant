import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../providers/class_notice_provider.dart';

/// Bottom sheet a CR uses to post a notice to their own batch.
class PostClassNoticeSheet extends ConsumerStatefulWidget {
  final String universityId;
  final String departmentId;

  const PostClassNoticeSheet({
    super.key,
    required this.universityId,
    required this.departmentId,
  });

  @override
  ConsumerState<PostClassNoticeSheet> createState() =>
      _PostClassNoticeSheetState();
}

class _PostClassNoticeSheetState extends ConsumerState<PostClassNoticeSheet> {
  static const _maxBytes = 5 * 1024 * 1024;

  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  DateTime? _expiresAt;
  File? _file;
  String? _fileType;
  String? _fileName;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _attach(File file, String type, String name) async {
    if (await file.length() > _maxBytes) {
      Fluttertoast.showToast(msg: 'File must be 5MB or smaller.');
      return;
    }
    setState(() {
      _file = file;
      _fileType = type;
      _fileName = name;
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    await _attach(File(picked.path), 'image', picked.name);
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result.isEmpty || result.first.path == null) return;
    await _attach(File(result.first.path!), 'pdf', result.first.name);
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add a title.');
      return;
    }
    setState(() => _submitting = true);
    try {
      await postClassNotice(
        ref,
        universityId: widget.universityId,
        departmentId: widget.departmentId,
        title: title,
        message: _messageController.text.trim(),
        expiresAt: _expiresAt,
        file: _file,
        fileType: _fileType,
      );
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Notice posted.');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      Fluttertoast.showToast(msg: 'Could not post notice. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

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
              'Post a notice',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              'Visible to your batch.',
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: Spacing.lg),
            TextField(
              controller: _titleController,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: "e.g. Tomorrow's class is cancelled",
              ),
            ),
            const SizedBox(height: Spacing.sm),
            TextField(
              controller: _messageController,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Details (optional)',
              ),
            ),
            const SizedBox(height: Spacing.md),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: [
                ActionChip(
                  avatar: const Icon(LucideIcons.image, size: 16),
                  label: const Text('Image'),
                  onPressed: _submitting ? null : _pickImage,
                ),
                ActionChip(
                  avatar: const Icon(LucideIcons.fileText, size: 16),
                  label: const Text('PDF'),
                  onPressed: _submitting ? null : _pickPdf,
                ),
                ActionChip(
                  avatar: const Icon(LucideIcons.calendarClock, size: 16),
                  label: Text(
                    _expiresAt == null
                        ? 'Visible until…'
                        : 'Until ${_expiresAt!.day}/${_expiresAt!.month}/${_expiresAt!.year}',
                  ),
                  onPressed: _submitting ? null : _pickExpiry,
                ),
              ],
            ),
            if (_fileName != null) ...[
              const SizedBox(height: Spacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                  border: Border.all(color: colors.border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _fileName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _file = null;
                        _fileType = null;
                        _fileName = null;
                      }),
                      child: const Icon(LucideIcons.x, size: 16),
                    ),
                  ],
                ),
              ),
            ],
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
                    : const Text('Post notice'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
