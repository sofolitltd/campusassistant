import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';

class AddClubPage extends ConsumerStatefulWidget {
  const AddClubPage({super.key});

  @override
  ConsumerState<AddClubPage> createState() => _AddClubPageState();
}

class _AddClubPageState extends ConsumerState<AddClubPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _foundedYearController = TextEditingController();

  String clubType = 'department';
  String? selectedDepartment;
  bool isLoading = false;

  File? logoFile;
  File? bannerFile;

  Future<void> _pickImage(bool isLogo) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isLogo) {
          logoFile = File(picked.path);
        } else {
          bannerFile = File(picked.path);
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(userProvider).value;
    if (user == null) return;

    try {
      setState(() => isLoading = true);

      /*
      final logoUrl = await _uploadFile(
        logoFile,
        'clubs/${user.university}/${DateTime.now().millisecondsSinceEpoch}_logo.jpg',
      );

      final bannerUrl = await _uploadFile(
        bannerFile,
        'clubs/${user.university}/${DateTime.now().millisecondsSinceEpoch}_banner.jpg',
      );

      final socialLinks = {
        if (_facebookController.text.isNotEmpty)
          'facebook': _facebookController.text,
        if (_instagramController.text.isNotEmpty)
          'instagram': _instagramController.text,
        if (_linkedinController.text.isNotEmpty)
          'linkedin': _linkedinController.text,
      };
      */

      // await FirebaseFirestore.instance.collection('clubs').add({
      //   'name': _nameController.text.trim(),
      //   'description': _descriptionController.text.trim(),
      //   'clubType': clubType,
      //   'university': user.university,
      //   'department': clubType == 'department' ? user.department : null,
      //   'logoUrl': logoUrl,
      //   'bannerUrl': bannerUrl,
      //   'foundedYear': int.tryParse(_foundedYearController.text),
      //   'isActive': true,
      //   'socialLinks': socialLinks.isEmpty ? null : socialLinks,
      //   'contactEmail': _emailController.text.trim(),
      //   'contactPhone': _phoneController.text.trim(),
      //   'createdAt': DateTime.now(),
      //   'createdBy': user.uid,
      // });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Club added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Club'), centerTitle: true),
      body: userAsync.when(
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Club Name',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Enter club name' : null,
                  ),

                  const SizedBox(height: 10),

                  // description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    maxLines: 2,
                    validator: (v) =>
                        v!.isEmpty ? 'Enter club description' : null,
                  ),

                  const SizedBox(height: 10),

                  // club type
                  ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      initialValue: clubType,
                      isDense: true,
                      decoration: const InputDecoration(
                        labelText: 'Club Type',
                        visualDensity: VisualDensity(
                          horizontal: 0,
                          vertical: -2,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'department',
                          child: Text('Department Club'),
                        ),
                        DropdownMenuItem(
                          value: 'university',
                          child: Text('University Club'),
                        ),
                      ],
                      onChanged: (val) => setState(() => clubType = val!),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // founded year
                  TextFormField(
                    controller: _foundedYearController,
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelText: 'Founded Year',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // contact info
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Email',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Social Links',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _facebookController,
                    decoration: const InputDecoration(
                      labelText: 'Facebook URL',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _instagramController,
                    decoration: const InputDecoration(
                      labelText: 'Instagram URL',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _linkedinController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn URL',
                      isDense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Images',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickImage(true),
                          child: Text(
                            logoFile == null ? 'Pick Logo' : 'Logo Selected',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickImage(false),
                          child: Text(
                            bannerFile == null
                                ? 'Pick Banner'
                                : 'Banner Selected',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _submit,
                    icon: const Icon(Icons.check),
                    label: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Add Club'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
