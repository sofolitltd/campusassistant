import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/profile_model.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/utils/constants.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/red_header_layout.dart';

class EditProfilePage extends ConsumerWidget {
  final String uid;

  const EditProfilePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileByUidProvider(uid));

    return RedHeaderLayout(
      title: 'Edit Profile',
      showSearchBar: false,
      body: profileAsync.when(
        data: (profile) => _EditProfileForm(profile: profile),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

/// ✅ Form (ConsumerStatefulWidget)
class _EditProfileForm extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const _EditProfileForm({required this.profile});

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  String? _selectedHall;
  String? _selectedBloodGroup;
  bool _isLoading = false;

  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _mobileController.text = widget.profile.mobile;
    _selectedHall = widget.profile.information.hall;
    _selectedBloodGroup = _validBloodGroup(widget.profile.information.blood);

    _nameController.addListener(_onFormChanged);
    _mobileController.addListener(_onFormChanged);
  }

  String? _validBloodGroup(String? blood) {
    if (blood == null || blood.isEmpty) return null;
    return kBloodGroup.contains(blood) ? blood : null;
  }

  void _onFormChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _mobileController.removeListener(_onFormChanged);
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  bool _hasChanged() {
    return _nameController.text.trim() != widget.profile.name ||
        _mobileController.text.trim() != widget.profile.mobile ||
        _selectedHall != widget.profile.information.hall ||
        _selectedBloodGroup != widget.profile.information.blood ||
        _pickedMobileImage != null;
  }

  @override
  Widget build(BuildContext context) {
    final hallsAsync = ref.watch(hallsProvider);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
//
                  ButtonTheme(
                    alignedDropdown: true,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).cardColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white10
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// ---- PROFILE IMAGE ----
                          Row(
                            children: [
                              _buildProfileImage(context),
                              const SizedBox(width: 16),
                              Expanded(child: _buildPhotoInstruction(context)),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// ---- NAME ----
                          const Text('Name'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Name'),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter your name' : null,
                          ),

                          const SizedBox(height: Spacing.lg),

                          /// ---- MOBILE + BLOOD ----
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Mobile Number'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _mobileController,
                                      keyboardType: TextInputType.phone,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Enter mobile no';
                                        }
                                        if (val.length != 11) {
                                          return 'Mobile no must be 11 digits';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Mobile No',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Blood Group'),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      initialValue: _selectedBloodGroup,
                                      decoration: const InputDecoration(
                                        hintText: 'Blood',
                                      ),
                                      isDense: true,
                                      onChanged: (val) => setState(
                                        () => _selectedBloodGroup = val,
                                      ),
                                      validator: (val) => val == null
                                          ? 'Select your blood group'
                                          : null,
                                      dropdownColor: Theme.of(
                                        context,
                                      ).cardColor,
                                      items: kBloodGroup
                                          .map(
                                            (bg) => DropdownMenuItem(
                                              value: bg,
                                              child: Text(bg),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Spacing.lg),

                          /// ---- HALL ----
                          const Text('Hall Name'),
                          const SizedBox(height: 8),

                          hallsAsync.when(
                            data: (hallList) {
                              final validHall = hallList.contains(_selectedHall)
                                  ? _selectedHall
                                  : null;
                              return DropdownButtonFormField<String>(
                                initialValue: validHall,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  hintText: 'Hall Name',
                                ),
                                isDense: true,
                                onChanged: (val) =>
                                    setState(() => _selectedHall = val),
                                validator: (val) =>
                                    val == null ? 'Select your hall' : null,
                                dropdownColor: Theme.of(context).cardColor,
                                items: hallList
                                    .map(
                                      (hall) => DropdownMenuItem(
                                        value: hall,
                                        child: Text(
                                          hall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                            loading: () => const Padding(
                              padding: EdgeInsets.all(8),
                              child: CupertinoActivityIndicator(),
                            ),
                            error: (e, _) => Text('Error loading halls: $e'),
                          ),

                          const SizedBox(height: 24),

                          /// ---- SAVE BUTTON ----
                          ElevatedButton(
                            onPressed: _isLoading || !_hasChanged()
                                ? null
                                : _updateProfile,
                            child: _isLoading
                                ? const CupertinoActivityIndicator()
                                : const Text('UPDATE'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper widgets ---
  Widget _buildProfileImage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ImageProvider? imageProvider;
    if (_pickedMobileImage != null) {
      imageProvider = kIsWeb
          ? MemoryImage(_webImage)
          : FileImage(_pickedMobileImage!);
    } else if (widget.profile.image.isNotEmpty) {
      imageProvider = NetworkImage(widget.profile.image);
    } else {
      imageProvider = null;
    }

    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageProvider != null
          ? Image(
              image: imageProvider,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildPlaceholder(cs),
            )
          : _buildPlaceholder(cs),
    );
  }

  Widget _buildPlaceholder(ColorScheme cs) {
    return Center(
      child: Icon(
        Icons.person,
        size: 40,
        color: cs.onSurface.withValues(alpha: .35),
      ),
    );
  }

  Widget _buildPhotoInstruction(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '* Try to use a formal photo.\n'
            '* Female can use photo with Hijab or Niqab.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1.2),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text(
              _pickedMobileImage == null
                  ? 'CHANGE PHOTO'
                  : 'NEW PHOTO SELECTED',
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic functions ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    if (!mounted) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 40,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Customization',
          toolbarWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(width: 350, height: 350),
        ),
      ],
    );

    if (cropped != null) {
      if (kIsWeb) {
        final bytes = await cropped.readAsBytes();
        setState(() {
          _webImage = bytes;
          _pickedMobileImage = File('');
        });
      } else {
        setState(() => _pickedMobileImage = File(cropped.path));
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String imageUrl = widget.profile.image;
      if (_pickedMobileImage != null) {
        imageUrl = await _uploadAndGetImageUrl();
      }

      await _updateUserInformation(imageUrl);
      await _updateStudentInformation(imageUrl);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String> _uploadAndGetImageUrl() async {
    /*
    final ref = FirebaseStorage.instance
        .ref('Users')
        .child(widget.profile.university)
        .child(widget.profile.department)
        .child('${widget.profile.information.id!}.jpg');

    if (kIsWeb) {
      await ref.putData(_webImage);
    } else {
      await ref.putFile(_pickedMobileImage!);
    }
    return ref.getDownloadURL();
    */
    return widget.profile.image;
  }

  Future<void> _updateUserInformation(String image) async {
    /*
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profile.uid)
        .update({
          'name': _nameController.text.trim(),
          'image': image,
          'mobile': _mobileController.text.trim(),
          'information': {
            'batch': widget.profile.information.batch,
            'id': widget.profile.information.id,
            'session': widget.profile.information.session,
            'hall': _selectedHall,
            'blood': _selectedBloodGroup,
            'status': widget.profile.information.status!.toJson(),
          },
        });
    */
  }

  Future<void> _updateStudentInformation(String image) async {
    /*
    await FirebaseFirestore.instance
        .collection('students')
        .where('university', isEqualTo: widget.profile.university)
        .where('department', isEqualTo: widget.profile.department)
        .where('batch', isEqualTo: widget.profile.information.batch)
        .where('id', isEqualTo: widget.profile.information.id)
        .get()
        .then((val) {
          val.docs.first.reference.update({
            'phone': _mobileController.text.trim(),
            'hall': _selectedHall,
            'blood': _selectedBloodGroup,
            'imageUrl': image,
          });
        });
    */
  }
}
