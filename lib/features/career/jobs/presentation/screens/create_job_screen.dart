import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import '../widgets/job_form_helpers.dart';
import '../../../reminders/presentation/providers/career_reminder_provider.dart';

/// Ported "same to same" from personalassistant's AddJobScreen: sectioned
/// form (Job Identity / Connections / Important Dates / Attachments),
/// reorderable attachment preview strip, upload-progress overlay. Two
/// deliberate differences from the reference, both consequences of this
/// app's architecture (not styling choices):
///  - No "Post to Circular" toggle — circulars here are admin-authored only
///    (see CareerCircular), students can't publish their own.
///  - Attachments upload one-by-one to this app's /upload (R2) endpoint
///    instead of Appwrite Storage, and PDFs render as a generic file tile
///    (no client-side PDF thumbnail rendering) rather than a real preview.
class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _orgController = TextEditingController();
  final _resourceLinkController = TextEditingController();
  final _postLinkController = TextEditingController();

  DateTime? _publishDate;
  DateTime? _deadlineDate;
  DateTime? _reminderDateTime;
  final List<PlatformFile> _selectedFiles = [];
  bool _isUploading = false;
  double _uploadProgress = 0;
  CareerJobScope _shareScope = CareerJobScope.private_;

  @override
  void dispose() {
    _titleController.dispose();
    _orgController.dispose();
    _resourceLinkController.dispose();
    _postLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() => _selectedFiles.addAll(result.files));
    }
  }

  Future<void> _selectPublishDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && mounted) {
      setState(() => _publishDate = pickedDate);
    }
  }

  Future<void> _selectDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
    );
    if (pickedTime != null && mounted) {
      setState(() {
        _deadlineDate = DateTime(
          pickedDate.year, pickedDate.month, pickedDate.day,
          pickedTime.hour, pickedTime.minute,
        );
      });
    }
  }

  Future<void> _selectReminderDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null && mounted) {
      setState(() {
        _reminderDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  Future<void> _saveJob() async {
    if (_reminderDateTime != null && _deadlineDate != null) {
      if (_reminderDateTime!.isAfter(_deadlineDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder cannot be after the deadline!')),
        );
        return;
      }
    }
    if (_reminderDateTime != null && !_reminderDateTime!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder must be in the future')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() { _isUploading = true; _uploadProgress = 0; });
    try {
      final attachmentUrls = <String>[];
      final apiClient = ref.read(apiClientProvider);
      for (var i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final response = await apiClient.uploadFile(
          '/upload',
          filePath: file.path!,
          fieldName: 'image',
          data: {'folder': 'career'},
        );
        attachmentUrls.add((response.data['file_url'] ?? response.data['url']) as String);
        setState(() => _uploadProgress = (i + 1) / _selectedFiles.length);
      }

      final draft = CareerJob(
        id: '',
        title: _titleController.text.trim(),
        organization: _orgController.text.trim(),
        postLink: _postLinkController.text.trim(),
        resourceLink: _resourceLinkController.text.trim(),
        attachmentUrls: attachmentUrls,
        publishDate: _publishDate,
        deadlineDate: _deadlineDate,
        status: CareerJobStatus.pending,
        createdAt: DateTime.now(),
        scope: _shareScope,
      );
      final job = await ref.read(careerJobActionsProvider).createJob(draft);

      if (_reminderDateTime != null) {
        await ref.read(careerReminderActionsProvider).createReminder(
              jobId: job.id,
              title: job.title,
              remindAt: _reminderDateTime!,
            );
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Add Job Post')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.xxl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle(context, 'Job Identity'),
                  buildCustomField(context, 'Job Title *', _titleController, LucideIcons.briefcase,
                    (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  buildCustomField(context, 'Organization *', _orgController, LucideIcons.building,
                    (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: Spacing.xl),
                  buildSectionTitle(context, 'Connections'),
                  buildCustomField(context, 'Resource Link (URL)', _resourceLinkController, LucideIcons.link),
                  buildCustomField(context, 'Job Post Link (URL)', _postLinkController, LucideIcons.externalLink),

                  const SizedBox(height: Spacing.xl),
                  buildSectionTitle(context, 'Important Dates'),
                  buildModernDateTile(context, 'Publish Date', _publishDate, LucideIcons.calendar,
                    _selectPublishDate,
                  ),
                  buildModernDateTile(context, 'Deadline Date & Time', _deadlineDate, LucideIcons.clock,
                    _selectDeadline, isUrgent: true,
                  ),
                  buildModernDateTile(context, 'Reminder Date & Time', _reminderDateTime, LucideIcons.bell,
                    _selectReminderDateTime,
                  ),

                  const SizedBox(height: Spacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildSectionTitle(context, 'Attachments'),
                      TextButton.icon(
                        onPressed: _pickFiles,
                        icon: const Icon(LucideIcons.filePlus, size: 16),
                        label: const Text('Add Files'),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xs),
                  if (_selectedFiles.isNotEmpty)
                    SizedBox(
                      height: 160,
                      child: ReorderableListView.builder(
                        scrollDirection: Axis.horizontal,
                        proxyDecorator: (child, index, animation) => Material(
                          elevation: 10, color: Colors.transparent, child: child,
                        ),
                        itemCount: _selectedFiles.length,
                        onReorderItem: (oldIndex, newIndex) {
                          setState(() {
                            final item = _selectedFiles.removeAt(oldIndex);
                            _selectedFiles.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) => _buildFilePreview(_selectedFiles[index], index),
                      ),
                    )
                  else
                    buildEmptyAttachmentPlaceholder(context),

                  const SizedBox(height: Spacing.xl),
                  buildSectionTitle(context, 'Share With'),
                  Text(
                    'Optionally share this posting with other students — like a Community post.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.sm,
                    children: [
                      ChoiceChip(
                        label: const Text('Just me'),
                        selected: _shareScope == CareerJobScope.private_,
                        onSelected: (_) => setState(() => _shareScope = CareerJobScope.private_),
                      ),
                      ChoiceChip(
                        label: const Text('My Batch'),
                        selected: _shareScope == CareerJobScope.batch,
                        onSelected: (_) => setState(() => _shareScope = CareerJobScope.batch),
                      ),
                      ChoiceChip(
                        label: const Text('My Department'),
                        selected: _shareScope == CareerJobScope.department,
                        onSelected: (_) => setState(() => _shareScope = CareerJobScope.department),
                      ),
                      ChoiceChip(
                        label: const Text('My University'),
                        selected: _shareScope == CareerJobScope.university,
                        onSelected: (_) => setState(() => _shareScope = CareerJobScope.university),
                      ),
                    ],
                  ),

                  const SizedBox(height: Spacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _saveJob,
                      child: const Text('Save Job Entry'),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                ],
              ),
            ),
          ),
          if (_isUploading) buildLoadingOverlay(context, _uploadProgress),
        ],
      ),
    );
  }

  Widget _buildFilePreview(PlatformFile file, int index) {
    final cs = Theme.of(context).colorScheme;
    final name = file.name.toLowerCase();
    final isImage = name.endsWith('.jpg') || name.endsWith('.jpeg') || name.endsWith('.png');
    final isPdf = name.endsWith('.pdf');
    return Container(
      key: ValueKey('file_$index'),
      width: 120,
      margin: const EdgeInsets.only(right: Spacing.md),
      decoration: BoxDecoration(
        borderRadius: RadiusToken.circular(RadiusToken.sm),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: RadiusToken.circular(RadiusToken.sm),
            child: (!kIsWeb && isImage && file.path != null)
                ? Image.file(File(file.path!), width: 120, height: 160, fit: BoxFit.cover)
                : Container(
                    width: 120,
                    height: 160,
                    color: cs.surfaceContainerHighest,
                    child: Icon(isPdf ? LucideIcons.fileText : LucideIcons.image, color: cs.outline, size: 32),
                  ),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _selectedFiles.removeAt(index)),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: cs.surfaceContainerHighest,
                child: Icon(Icons.close, size: 14, color: cs.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
