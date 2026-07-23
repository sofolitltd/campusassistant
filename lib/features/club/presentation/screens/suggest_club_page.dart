import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '/core/di.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/club/domain/entities/club.dart';
import '/features/club/presentation/providers/club_provider.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';

const clubCategories = [
  'Academic',
  'Cultural',
  'Sports',
  'Technology',
  'Arts',
  'Social Service',
  'Debate',
  'Other',
];

/// Lets a student suggest a club for their own university/department, with
/// everything an admin needs to judge it (matches the admin panel's own
/// club form field-for-field). It always saves with isActive=false
/// server-side (SuggestClub forces this regardless of what's sent) — an
/// admin reviews and activates it. The requester is immediately seeded as
/// the club's "owner" manager (see backend SuggestClub), so they can keep
/// refining it from "My Clubs" while it's pending.
class SuggestClubPage extends ConsumerStatefulWidget {
  const SuggestClubPage({super.key});

  @override
  ConsumerState<SuggestClubPage> createState() => _SuggestClubPageState();
}

class _SuggestClubPageState extends ConsumerState<SuggestClubPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _foundedYearController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _linkedinController = TextEditingController();

  String _clubType = 'department';
  String? _category;
  File? _logoFile;
  File? _bannerFile;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _foundedYearController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLogo) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (isLogo) {
        _logoFile = File(picked.path);
      } else {
        _bannerFile = File(picked.path);
      }
    });
  }

  Future<String?> _uploadIfPicked(File? file, String folder) async {
    if (file == null) return null;
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': folder},
    );
    return response.data['file_url'] as String?;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final university = await ref.read(myUniversityProvider.future);
      String? departmentId;
      if (_clubType == 'department') {
        final department = await ref.read(myDepartmentProvider.future);
        departmentId = department.id;
      }

      final logoUrl = await _uploadIfPicked(_logoFile, 'clubs');
      final bannerUrl = await _uploadIfPicked(_bannerFile, 'clubs');

      final socialLinks = <String, dynamic>{
        if (_facebookController.text.trim().isNotEmpty)
          'facebook': _facebookController.text.trim(),
        if (_instagramController.text.trim().isNotEmpty)
          'instagram': _instagramController.text.trim(),
        if (_linkedinController.text.trim().isNotEmpty)
          'linkedin': _linkedinController.text.trim(),
      };

      final club = Club(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        clubType: _clubType,
        universityId: university.id,
        departmentId: departmentId,
        isActive: false,
        logoUrl: logoUrl,
        bannerUrl: bannerUrl,
        foundedYear: int.tryParse(_foundedYearController.text.trim()),
        category: _category,
        contactEmail: _contactEmailController.text.trim().isEmpty
            ? null
            : _contactEmailController.text.trim(),
        contactPhone: _contactPhoneController.text.trim().isEmpty
            ? null
            : _contactPhoneController.text.trim(),
        socialLinks: socialLinks.isEmpty ? null : socialLinks,
      );

      await suggestClub(ref, club);

      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Submitted for review. Thanks!');
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not submit. Please try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggest a Club')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Know a club or organization that isn\'t listed yet? Suggest it '
              'here with as much detail as you can — an admin will review it '
              'before it goes live, and you\'ll be able to manage it '
              'yourself from "My Clubs" once approved.',
              style: TextStyle(color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                Expanded(
                  child: _ImagePickerBox(
                    label: 'Logo',
                    file: _logoFile,
                    onTap: () => _pickImage(true),
                    onClear: () => setState(() => _logoFile = null),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ImagePickerBox(
                    label: 'Banner',
                    file: _bannerFile,
                    onTap: () => _pickImage(false),
                    onClear: () => setState(() => _bannerFile = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Club Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'department',
                  label: Text('My Department'),
                ),
                ButtonSegment(
                  value: 'university',
                  label: Text('University-wide'),
                ),
              ],
              selected: {_clubType},
              onSelectionChanged: (s) => setState(() => _clubType = s.first),
            ),
            const SizedBox(height: Spacing.md),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: clubCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _foundedYearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Founded Year (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              'Contact',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _contactEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Contact Email (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Contact Phone (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              'Social Links',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _facebookController,
              decoration: const InputDecoration(
                labelText: 'Facebook (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _instagramController,
              decoration: const InputDecoration(
                labelText: 'Instagram (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _linkedinController,
              decoration: const InputDecoration(
                labelText: 'LinkedIn (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit for Review'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerBox extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _ImagePickerBox({
    required this.label,
    required this.file,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade50,
        ),
        child: file != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade400),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
      ),
    );
  }
}
