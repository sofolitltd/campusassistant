import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import '../widgets/job_form_helpers.dart';

/// Ported "same to same" from personalassistant's EditJobScreen: same
/// sectioned layout as Add Job, plus an "Application Status" dropdown card
/// and existing-attachment management (remote thumbnails, removable,
/// alongside newly-picked local files). Share scope isn't editable here —
/// it's chosen once at creation (see CreateJobScreen / JobDetailScreen).
class EditJobScreen extends ConsumerStatefulWidget {
  final CareerJob job;
  const EditJobScreen({super.key, required this.job});

  @override
  ConsumerState<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends ConsumerState<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(text: widget.job.title);
  late final _orgController = TextEditingController(text: widget.job.organization);
  late final _resourceLinkController = TextEditingController(text: widget.job.resourceLink);
  late final _postLinkController = TextEditingController(text: widget.job.postLink);

  late DateTime? _publishDate = widget.job.publishDate;
  late DateTime? _deadlineDate = widget.job.deadlineDate;
  late CareerJobStatus _status = widget.job.status;
  late final List<String> _existingAttachmentUrls = List.of(widget.job.attachmentUrls);
  final List<PlatformFile> _newFiles = [];
  bool _isUploading = false;
  double _uploadProgress = 0;

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
      setState(() => _newFiles.addAll(result.files));
    }
  }

  Future<void> _selectPublishDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _publishDate ?? DateTime.now(),
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
      initialDate: _deadlineDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _deadlineDate != null ? TimeOfDay.fromDateTime(_deadlineDate!) : const TimeOfDay(hour: 23, minute: 59),
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isUploading = true; _uploadProgress = 0; });
    try {
      final apiClient = ref.read(apiClientProvider);
      final uploadedUrls = <String>[];
      for (var i = 0; i < _newFiles.length; i++) {
        final file = _newFiles[i];
        final response = await apiClient.uploadFile(
          '/upload',
          filePath: file.path!,
          fieldName: 'image',
          data: {'folder': 'career'},
        );
        uploadedUrls.add((response.data['file_url'] ?? response.data['url']) as String);
        setState(() => _uploadProgress = (i + 1) / _newFiles.length);
      }

      final draft = CareerJob(
        id: widget.job.id,
        title: _titleController.text.trim(),
        organization: _orgController.text.trim(),
        postLink: _postLinkController.text.trim(),
        resourceLink: _resourceLinkController.text.trim(),
        attachmentUrls: [..._existingAttachmentUrls, ...uploadedUrls],
        publishDate: _publishDate,
        deadlineDate: _deadlineDate,
        status: _status,
        notes: widget.job.notes,
        createdAt: widget.job.createdAt,
        scope: widget.job.scope,
      );
      await ref.read(careerJobActionsProvider).updateJob(widget.job.id, draft);

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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Edit Job Entry')),
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
                  _buildStatusSelector(),

                  const SizedBox(height: Spacing.xl),
                  buildSectionTitle(context, 'Connections'),
                  buildCustomField(context, 'Resource Link (URL)', _resourceLinkController, LucideIcons.link),
                  buildCustomField(context, 'Job Post Link (URL)', _postLinkController, LucideIcons.externalLink),

                  const SizedBox(height: Spacing.xl),
                  buildSectionTitle(context, 'Important Dates'),
                  buildModernDateTile(context, 'Publish Date', _publishDate, LucideIcons.calendar, _selectPublishDate),
                  buildModernDateTile(context, 'Deadline Date & Time', _deadlineDate, LucideIcons.clock, _selectDeadline, isUrgent: true),

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
                  if (_existingAttachmentUrls.isNotEmpty || _newFiles.isNotEmpty)
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var i = 0; i < _existingAttachmentUrls.length; i++)
                            _buildExistingFileCard(_existingAttachmentUrls[i], i),
                          for (var i = 0; i < _newFiles.length; i++)
                            _buildNewFileCard(_newFiles[i], i),
                        ],
                      ),
                    )
                  else
                    buildEmptyAttachmentPlaceholder(context),

                  const SizedBox(height: Spacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(backgroundColor: cs.primary, foregroundColor: cs.onPrimary),
                      child: const Text('Save Changes'),
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

  Widget _buildStatusSelector() {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Application Status', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: Spacing.xs),
          Card(
            elevation: 0,
            color: cs.surface,
            shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CareerJobStatus>(
                  value: _status,
                  isExpanded: true,
                  items: CareerJobStatus.values
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.name[0].toUpperCase() + s.name.substring(1))))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingFileCard(String url, int index) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      key: ValueKey('existing_$index'),
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
            child: CachedNetworkImage(
              imageUrl: ApiEndpoints.resolveImageUrl(url),
              width: 120,
              height: 160,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 120,
                height: 160,
                color: cs.surfaceContainerHighest,
                child: Icon(LucideIcons.fileText, color: cs.outline, size: 32),
              ),
            ),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _existingAttachmentUrls.removeAt(index)),
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

  Widget _buildNewFileCard(PlatformFile file, int index) {
    final cs = Theme.of(context).colorScheme;
    final name = file.name.toLowerCase();
    final isImage = name.endsWith('.jpg') || name.endsWith('.jpeg') || name.endsWith('.png');
    final isPdf = name.endsWith('.pdf');
    return Container(
      key: ValueKey('new_$index'),
      width: 120,
      margin: const EdgeInsets.only(right: Spacing.md),
      decoration: BoxDecoration(
        borderRadius: RadiusToken.circular(RadiusToken.sm),
        border: Border.all(color: cs.primary),
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
            top: 4, left: 4,
            child: Container(
              padding: const EdgeInsets.all(Spacing.xxs),
              decoration: BoxDecoration(color: cs.primary, borderRadius: RadiusToken.circular(RadiusToken.xs)),
              child: Text('NEW', style: TextStyle(color: cs.onPrimary, fontSize: 10)),
            ),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _newFiles.removeAt(index)),
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
