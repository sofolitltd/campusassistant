import 'dart:io';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/chapter/presentation/providers/chapter_provider.dart';
import '/features/course/presentation/providers/course_provider.dart';
import '/features/resource/data/models/resource_model.dart';
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final name = result.files.single.name;
      final size = result.files.single.size;

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
      const kAdminSentinelId = '00000000-0000-0000-0000-000000000000';
      final uploaderUid = user?.uid ?? '';
      final uploaderId = widget.resource?.uploaderId ?? kAdminSentinelId;
      final uploaderName = user?.name ?? 'Admin';

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
        uploaderId: uploaderId,
        uploaderUid: uploaderUid,
        uploaderName: uploaderName,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.resource == null ? 'Add $typeName' : 'Edit $typeName',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. File Selection Redesign
              Text(
                '1. File Details',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Picker/Preview (2:3 Aspect Ratio)
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: _localThumbnailFile != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _localThumbnailFile!,
                                    fit: BoxFit.cover,
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
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        LucideIcons.x,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: _pickFile,
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.filePlus, size: 32),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Choose\nFile',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right Side: Meta Data show like size, total page
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "File Name",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          _fileName ?? "No File Selected! ",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _infoTile(
                          icon: LucideIcons.hardDrive,
                          label: 'File Size',
                          value: _fileSizeBytes > 1024 * 1024
                              ? '${(_fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
                              : _fileSizeBytes > 1024
                              ? '${(_fileSizeBytes / 1024).toStringAsFixed(1)} KB'
                              : '$_fileSizeBytes B',
                        ),
                        const SizedBox(height: 12),
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

              const SizedBox(height: 24),

              // 2. Main Content
              const SizedBox(height: 24),
              // Course Selection Like Assign Batches
              Text(
                '2. Select Course',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              coursesAsync.when(
                data: (courses) {
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCourseId.isNotEmpty
                        ? _selectedCourseId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LucideIcons.book),
                    ),
                    items: courses.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          '[${c.courseCode}] ${c.courseTitle}',
                          overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 24),

              Text(
                '3. Basic Information',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Chapter Name or Topic',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(LucideIcons.heading),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(LucideIcons.fileText),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Meta Years (For Questions)
              if (widget.type == 'question') ...[
                Text(
                  '4. Academic Years',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 24),
              ],

              // 5. Metadata Section
              Text(
                widget.type == 'question'
                    ? '5. Type-Specific Details'
                    : '4. Type-Specific Details',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Dynamic Metadata Fields
              ..._buildMetadataFields(chaptersAsync),

              const SizedBox(height: 24),

              // 6. Access Level
              Text(
                widget.type == 'question'
                    ? '6. Access Level'
                    : '5. Access Level',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),
              // 7. Batches
              Text(
                widget.type == 'question'
                    ? '7. Target Batches'
                    : '6. Target Batches',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isUploading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.resource == null
                                ? LucideIcons.plus
                                : LucideIcons.save,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.resource == null
                                ? 'Add $typeName'
                                : 'Update $typeName',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 12),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
            padding: const EdgeInsets.only(bottom: 16),
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
                  initialValue: controller.text.isNotEmpty ? controller.text : null,
                  decoration: const InputDecoration(
                    labelText: 'Chapter',
                    border: OutlineInputBorder(),
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
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(_getIconForMetadata(key)),
            ),
          ),
        ),
      );
    });

    return fields;
  }

  IconData _getIconForMetadata(String key) {
    switch (key) {
      case 'teacher':
      case 'creator':
      case 'author':
        return LucideIcons.user;
      case 'chapter':
        return LucideIcons.bookOpen;
      case 'publisher':
        return LucideIcons.building;
      case 'edition':
        return LucideIcons.hash;
      case 'isbn':
        return LucideIcons.barcode;
      case 'exam_type':
        return LucideIcons.graduationCap;
      case 'marks':
        return LucideIcons.circleCheck;
      case 'academic_year':
        return LucideIcons.calendar;
      default:
        return LucideIcons.info;
    }
  }
}
