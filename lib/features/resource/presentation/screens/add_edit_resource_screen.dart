import 'dart:io';
import 'package:flutter/cupertino.dart';

import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/chapter/presentation/providers/chapter_provider.dart';
import '/features/course/presentation/providers/course_provider.dart';
import '/features/resource/data/models/resource_model.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../core/di.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../domain/entities/resource.dart';
import '../providers/resource_provider.dart';
import '../../../../widgets/batch_multi_select_field.dart';
import '../../../../widgets/year_multi_select_field.dart';
import '../../../../features/study/presentation/providers/questions_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class AddEditResourceScreen extends ConsumerStatefulWidget {
  final Resource? resource;
  final String universityId;
  final String departmentId;
  final String courseCode;
  final int lessonNo;
  final String type;

  final String? initialBatchName;

  const AddEditResourceScreen({
    super.key,
    this.resource,
    required this.universityId,
    required this.departmentId,
    required this.courseCode,
    required this.lessonNo,
    this.type = 'note',
    this.initialBatchName,
  });

  @override
  ConsumerState<AddEditResourceScreen> createState() =>
      _AddEditResourceScreenState();
}

class _AddEditResourceScreenState extends ConsumerState<AddEditResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  // Metadata Controllers
  final Map<String, TextEditingController> _metadataControllers = {};

  String? _filePath;
  String? _fileName;
  File? _localThumbnailFile;
  int _pageCount = 0;
  int _fileSizeBytes = 0;
  bool _isUploading = false;
  List<String> _selectedBatches = [];
  List<String> _selectedYears = [];
  String _accessLevel = 'basic';
  late String _selectedCourseId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.resource?.title);
    _descriptionController = TextEditingController(
      text: widget.resource?.description,
    );
    _pageCount = widget.resource?.pageCount ?? 0;
    _selectedBatches = List<String>.from(widget.resource?.batches ?? []);
    _fileSizeBytes = widget.resource?.fileSizeBytes ?? 0;
    _accessLevel = widget.resource?.accessLevel ?? 'basic';
    _selectedYears = List<String>.from(widget.resource?.years ?? []);
    _selectedCourseId = '';

    _initMetadataControllers();
  }

  void _initMetadataControllers() {
    final meta = widget.resource?.metadata ?? {};
    if (widget.type == 'note') {
      _metadataControllers['creator'] = TextEditingController(
        text: meta['creator'] ?? meta['teacher'], // Fallback for old data
      );
      _metadataControllers['chapter'] = TextEditingController(
        text:
            meta['chapter'] ??
            (widget.resource == null ? widget.lessonNo.toString() : null),
      );
    } else if (widget.type == 'book') {
      _metadataControllers['author'] = TextEditingController(
        text: meta['author'],
      );
      _metadataControllers['publisher'] = TextEditingController(
        text: meta['publisher'],
      );
      _metadataControllers['edition'] = TextEditingController(
        text: meta['edition'],
      );
      _metadataControllers['isbn'] = TextEditingController(text: meta['isbn']);
    } else if (widget.type == 'question') {
      _metadataControllers['exam_type'] = TextEditingController(
        text: meta['exam_type'],
      );
      _metadataControllers['marks'] = TextEditingController(
        text: meta['marks']?.toString(),
      );
    } else if (widget.type == 'syllabus') {
      _metadataControllers['academic_year'] = TextEditingController(
        text: meta['academic_year'],
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var c in _metadataControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickFile() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (picked != null && picked.path != null) {
      final path = picked.path!;
      final name = picked.name;
      final size = picked.lengthSync() ?? await picked.length() ?? 0;

      setState(() {
        _filePath = path;
        _fileName = name;
        _fileSizeBytes = size;
        _isUploading = true; // Show loading while processing
      });

      try {
        if (name.toLowerCase().endsWith('.pdf')) {
          final document = await PdfDocument.openFile(path);
          final page = await document.getPage(1);
          final pageImage = await page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: PdfPageImageFormat.jpeg,
            quality: 70,
          );

          final tempDir = await getTemporaryDirectory();
          final thumbFile = File(
            p.join(
              tempDir.path,
              '${p.basenameWithoutExtension(name)}_thumb.jpg',
            ),
          );
          await thumbFile.writeAsBytes(pageImage!.bytes);

          setState(() {
            _pageCount = document.pagesCount;
            _localThumbnailFile = thumbFile;
          });

          await page.close();
          await document.close();
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error extracting PDF info: $e');
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  void _clearFile() {
    setState(() {
      _filePath = null;
      _fileName = null;
      _fileSizeBytes = 0;
      _localThumbnailFile = null;
      _pageCount = 0;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.resource == null && _filePath == null) {
      Fluttertoast.showToast(msg: 'Please select a file');
      return;
    }

    if (widget.resource == null && _selectedBatches.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one batch');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = ref.read(userProvider).value;

      final isAdmin = user?.information.status?.admin ?? false;
      final isModerator = user?.information.status?.moderator ?? false;
      final isCr = user?.information.status?.cr ?? false;

      // Better CR check: match user's batch name with batch IDs
      bool isCrForAnySelectedBatch = false;
      if (isCr && user?.information.batch != null) {
        final currentBatches =
            ref.read(batchesByDepartmentProvider(widget.departmentId)).value ??
            [];
        final userBatchId = currentBatches
            .where(
              (b) =>
                  b.name == user?.information.batch &&
                  b.departmentId == widget.departmentId,
            )
            .firstOrNull
            ?.id;

        if (userBatchId != null) {
          isCrForAnySelectedBatch = _selectedBatches.contains(userBatchId);
        }
      }

      final canAutoPublish = isAdmin || isModerator || isCrForAnySelectedBatch;

      String fileUrl = widget.resource?.fileUrl ?? '';
      String thumbnailUrl = widget.resource?.thumbnailUrl ?? '';

      final apiClient = ref.read(apiClientProvider);

      if (_filePath != null) {
        final uploadResponse = await apiClient.uploadFile(
          '/upload',
          filePath: _filePath!,
          fieldName: 'image',
          data: {'folder': 'resources'},
        );
        fileUrl = uploadResponse.data['file_url'];
      }

      // Upload generated thumbnail if exists
      if (_localThumbnailFile != null) {
        final thumbResponse = await apiClient.uploadFile(
          '/upload',
          filePath: _localThumbnailFile!.path,
          fieldName: 'image',
          data: {'folder': 'thumbnails'},
        );
        thumbnailUrl = thumbResponse.data['file_url'];
      }

      final metadata = <String, dynamic>{};
      _metadataControllers.forEach((key, controller) {
        final val = controller.text.trim();
        if (val.isNotEmpty) {
          metadata[key] = val;
        }
      });

      final resource = ResourceModel(
        id: widget.resource?.id ?? '',
        type: widget.type,
        title: _titleController.text,
        fileUrl: fileUrl,
        thumbnailUrl: thumbnailUrl,
        description: _descriptionController.text,
        status:
            widget.resource?.status ??
            (canAutoPublish ? 'published' : 'pending'),
        accessLevel: _accessLevel,
        rejectedNote: widget.resource?.rejectedNote ?? '',
        reviewedBy: widget.resource?.reviewedBy ?? '',
        reviewedAt: widget.resource?.reviewedAt,
        universityId: widget.universityId,
        departmentId: widget.departmentId,
        courseCode:
            ref
                .read(
                  coursesProvider(
                    universityId: widget.universityId,
                    departmentId: widget.departmentId,
                  ),
                )
                .value
                ?.where((c) => c.id == _selectedCourseId)
                .firstOrNull
                ?.courseCode ??
            widget.courseCode,
        courseTitle: '',
        lessonNo: widget.lessonNo,
        fileSizeBytes: _fileSizeBytes,
        pageCount: _pageCount,
        downloadCount: widget.resource?.downloadCount ?? 0,
        viewCount: widget.resource?.viewCount ?? 0,
        ratingAvg: widget.resource?.ratingAvg ?? 0.0,
        ratingCount: widget.resource?.ratingCount ?? 0,
        isVerified: widget.resource?.isVerified ?? false,
        tags: widget.resource?.tags ?? const [],
        isPublic: widget.resource?.isPublic ?? true,
        metadata: metadata,
        years: _selectedYears,
        batches: _selectedBatches,
      );

      if (widget.resource == null) {
        await ref.read(createResourceProvider)(resource.toEntity());
        Fluttertoast.showToast(
          msg: resource.status == 'published'
              ? 'Resource added successfully!'
              : 'Submitted for review! Keep an eye on it.',
        );
      } else {
        await ref.read(updateResourceProvider)(resource.toEntity());
        Fluttertoast.showToast(msg: 'Resource updated successfully');
      }

      ref.invalidate(resourcesListProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final batchesAsync = ref.watch(
      batchesByDepartmentProvider(widget.departmentId),
    );

    final coursesAsync = ref.watch(
      coursesProvider(
        universityId: widget.universityId,
        departmentId: widget.departmentId,
      ),
    );

    final chaptersAsync = ref.watch(
      chaptersForCourseProvider(
        universityId: widget.universityId,
        departmentId: widget.departmentId,
        courseCode:
            coursesAsync.value
                ?.where((c) => c.id == _selectedCourseId)
                .firstOrNull
                ?.courseCode ??
            widget.courseCode,
      ),
    );

    // Find current course ID from async courses if not yet set
    if (_selectedCourseId.isEmpty && coursesAsync.hasValue) {
      final codeToFind = widget.resource?.courseCode ?? widget.courseCode;
      final course = coursesAsync.value!
          .where((c) => c.courseCode == codeToFind)
          .firstOrNull;
      if (course != null) {
        _selectedCourseId = course.id;
        // Invalidate chapters provider to load chapters for the newly selected course
        ref.invalidate(
          chaptersForCourseProvider(
            universityId: widget.universityId,
            departmentId: widget.departmentId,
            courseCode:
                coursesAsync.value
                    ?.where((c) => c.id == _selectedCourseId)
                    .firstOrNull
                    ?.courseCode ??
                widget.courseCode,
            batchId: null,
          ),
        );
      }
    }

    ref.listen(batchesByDepartmentProvider(widget.departmentId), (prev, next) {
      if (next.hasValue &&
          _selectedBatches.isEmpty &&
          widget.resource == null &&
          widget.initialBatchName != null) {
        final batch = next.value
            ?.where((b) => b.name == widget.initialBatchName)
            .firstOrNull;
        if (batch != null) {
          setState(() {
            _selectedBatches.add(batch.id);
          });
        }
      }
    });

    final String typeName =
        widget.type[0].toUpperCase() + widget.type.substring(1);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.resource == null ? 'Add $typeName' : 'Edit $typeName',
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  // 1. File Selection Redesign
                  Text(
                    '1. File Details',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.md),

                  Row(
                    crossAxisAlignment: .start,
                    children: [
                      // Left Side: Picker/Preview (2:3 Aspect Ratio)
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: context.colors.surfaceAlt,
                            borderRadius: BorderRadius.circular(RadiusToken.md),
                            border: Border.all(),
                          ),
                          child: _localThumbnailFile != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        RadiusToken.md,
                                      ),
                                      child: Image.file(
                                        _localThumbnailFile!,
                                        fit: .cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: _clearFile,
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                            Spacing.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: context.colors.textMuted,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            LucideIcons.x,
                                            size: 16,
                                            color: context.colors.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: _pickFile,
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.md,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: .center,
                                    children: [
                                      const Icon(
                                        LucideIcons.filePlus,
                                        size: 32,
                                      ),
                                      const SizedBox(height: Spacing.sm),
                                      const Text(
                                        'Choose\nFile',
                                        textAlign: .center,
                                        style: TextStyle(
                                          fontSize: FontSizeToken.sm,

                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(width: Spacing.lg),

                      // Right Side: Meta Data show like size, total page
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "File Name",
                              style: TextStyle(
                                fontSize: FontSizeToken.sm,
                                color: context.colors.textSubtle,
                                fontWeight: .bold,
                              ),
                            ),

                            Text(
                              _fileName ?? "No File Selected! ",
                              maxLines: 2,
                              overflow: .ellipsis,
                              style: TextStyle(
                                fontSize: FontSizeToken.sm,
                                fontWeight: .w500,
                                color: context.colors.textSubtle,
                              ),
                            ),

                            const SizedBox(height: Spacing.lg),

                            _infoTile(
                              icon: LucideIcons.hardDrive,
                              label: 'File Size',
                              value: _fileSizeBytes > 1024 * 1024
                                  ? '${(_fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
                                  : _fileSizeBytes > 1024
                                  ? '${(_fileSizeBytes / 1024).toStringAsFixed(1)} KB'
                                  : '$_fileSizeBytes B',
                            ),
                            const SizedBox(height: Spacing.md),
                            _infoTile(
                              icon: LucideIcons.bookOpen,
                              label: 'Page Count',
                              value: _pageCount.toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Spacing.xxl),

                  // 2. Main Content
                  const SizedBox(height: Spacing.xxl),
                  // Course Selection Like Assign Batches
                  Text(
                    '2. Select Course',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.md),
                  coursesAsync.when(
                    data: (courses) {
                      return DropdownButtonFormField<String>(
                        initialValue: _selectedCourseId.isNotEmpty
                            ? _selectedCourseId
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Course',
                          prefixIcon: Icon(LucideIcons.book),
                        ),
                        items: courses.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(
                              '[${c.courseCode}] ${c.courseTitle}',
                              overflow: .ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCourseId = val);
                          }
                        },
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Error loading courses: $e'),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  Text(
                    '3. Basic Information',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.md),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Chapter Name or Topic',
                      prefixIcon: Icon(LucideIcons.heading),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      prefixIcon: Icon(LucideIcons.fileText),
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  // 4. Meta Years (For Questions)
                  if (widget.type == 'question') ...[
                    Text(
                      '4. Academic Years',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.md),
                    Consumer(
                      builder: (context, ref, _) {
                        final years = ref.watch(questionYearsProvider);
                        return YearMultiSelectField(
                          years: years,
                          selectedYears: _selectedYears,
                          onSelected: (selected) {
                            setState(() => _selectedYears = selected);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: Spacing.xxl),
                  ],

                  // 5. Metadata Section
                  Text(
                    widget.type == 'question'
                        ? '5. Type-Specific Details'
                        : '4. Type-Specific Details',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.md),

                  // Dynamic Metadata Fields
                  ..._buildMetadataFields(chaptersAsync),

                  const SizedBox(height: Spacing.xxl),

                  // 6. Access Level
                  Text(
                    widget.type == 'question'
                        ? '6. Access Level'
                        : '5. Access Level',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.md),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'basic',
                        label: Text('Basic'),
                        icon: Icon(LucideIcons.shield),
                      ),
                      ButtonSegment(
                        value: 'pro',
                        label: Text('Pro'),
                        icon: Icon(LucideIcons.shieldCheck),
                      ),
                    ],
                    selected: {_accessLevel},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        _accessLevel = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: Spacing.xxl),
                  // 7. Batches
                  Text(
                    widget.type == 'question'
                        ? '7. Target Batches'
                        : '6. Target Batches',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.sm),
                  batchesAsync.when(
                    data: (batches) {
                      return BatchMultiSelectField(
                        batches: batches,
                        selectedBatchIds: _selectedBatches,
                        onMappingChanged: (ids) {
                          setState(() => _selectedBatches = ids);
                        },
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Error loading batches: $e'),
                  ),

                  const SizedBox(height: Spacing.xxxl),
                  ElevatedButton(
                    onPressed: _isUploading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.text,
                      foregroundColor: context.colors.onPrimary,
                      elevation: 2,
                    ),
                    child: _isUploading
                        ? CupertinoActivityIndicator(
                            color: context.colors.onPrimary,
                          )
                        : Row(
                            mainAxisAlignment: .center,
                            children: [
                              Icon(
                                widget.resource == null
                                    ? LucideIcons.plus
                                    : LucideIcons.save,
                              ),
                              const SizedBox(width: Spacing.sm),
                              Text(
                                widget.resource == null
                                    ? 'Add $typeName'
                                    : 'Update $typeName',
                                style: const TextStyle(
                                  fontSize: FontSizeToken.lg,
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizeToken.sm,
            color: context.colors.textSubtle,
            fontWeight: .bold,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: Spacing.md),
            Text(
              value,
              style: const TextStyle(
                fontWeight: .bold,
                fontSize: FontSizeToken.md,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildMetadataFields(AsyncValue chaptersAsync) {
    final fields = <Widget>[];

    _metadataControllers.forEach((key, controller) {
      if (key == 'chapter' && widget.type == 'note') {
        fields.add(
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.lg),
            child: chaptersAsync.when(
              data: (chapters) {
                final items = chapters
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem<String>(
                        value: c.chapterNo.toString(),
                        child: Text(
                          'Chapter ${c.chapterNo}: ${c.chapterTitle}',
                        ),
                      ),
                    )
                    .toList();

                return DropdownButtonFormField<String>(
                  initialValue: controller.text.isNotEmpty
                      ? controller.text
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Chapter',
                    prefixIcon: Icon(LucideIcons.bookOpen),
                  ),
                  items: items,
                  onChanged: (val) {
                    if (val != null) setState(() => controller.text = val);
                  },
                );
              },
              loading: () => const Text('Loading chapters...'),
              error: (e, _) => const Text('Error loading chapters'),
            ),
          ),
        );
        return;
      }

      String label = key.replaceAll('_', ' ');
      label = label[0].toUpperCase() + label.substring(1);

      // Override label for notes
      if (key == 'creator' && widget.type == 'note') {
        label = 'Created By / Author';
      }

      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.lg),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(_getIconForMetadata(key)),
            ),
          ),
        ),
      );
    });

    return fields;
  }

  IconData _getIconForMetadata(String key) {
    return switch (key) {
      'teacher' || 'creator' || 'author' => LucideIcons.user,
      'chapter' => LucideIcons.bookOpen,
      'publisher' => LucideIcons.building,
      'edition' => LucideIcons.hash,
      'isbn' => LucideIcons.barcode,
      'exam_type' => LucideIcons.graduationCap,
      'marks' => LucideIcons.circleCheck,
      'academic_year' => LucideIcons.calendar,
      _ => LucideIcons.info,
    };
  }
}
