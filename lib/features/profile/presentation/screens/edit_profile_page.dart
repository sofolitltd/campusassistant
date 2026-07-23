import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/profile_model.dart';
import '/features/student/domain/entities/student_address.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/utils/constants.dart';

import '/core/di.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/network/api_endpoints.dart';
import '/widgets/district_sub_district_picker.dart';

class EditProfilePage extends ConsumerWidget {
  final String uid;

  const EditProfilePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileByUidProvider(uid));
    final studentAsync = ref.watch(studentByUserIdProvider(uid));

    return CustomHeaderLayout(
      title: 'Edit Profile',
      showSearchBar: false,
      body: profileAsync.when(
        data: (profile) => _EditProfileForm(
          profile: profile,
          presentAddress: studentAsync.value?.presentAddress,
          permanentAddress: studentAsync.value?.permanentAddress,
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

/// ✅ Form (ConsumerStatefulWidget)
class _EditProfileForm extends ConsumerStatefulWidget {
  final ProfileModel profile;
  final StudentAddress? presentAddress;
  final StudentAddress? permanentAddress;

  const _EditProfileForm({
    required this.profile,
    this.presentAddress,
    this.permanentAddress,
  });

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

  // Present/permanent address section.
  final _presentAddressLineController = TextEditingController();
  final _permanentAddressLineController = TextEditingController();
  String? _presentDistrictId;
  String? _presentDistrictName;
  String? _presentSubDistrictId;
  String? _presentSubDistrictName;
  String? _permanentDistrictId;
  String? _permanentDistrictName;
  String? _permanentSubDistrictId;
  String? _permanentSubDistrictName;
  bool _permanentSameAsPresent = false;
  bool _addressDirty = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _mobileController.text = widget.profile.mobile;
    _selectedHall = widget.profile.information.hall;
    _selectedBloodGroup = _validBloodGroup(widget.profile.information.blood);

    final present = widget.presentAddress;
    if (present != null) {
      _presentDistrictId = present.districtId;
      _presentDistrictName = present.districtName;
      _presentSubDistrictId = present.subDistrictId;
      _presentSubDistrictName = present.subDistrictName;
      _presentAddressLineController.text = present.addressLine ?? '';
    }
    final permanent = widget.permanentAddress;
    if (permanent != null) {
      _permanentDistrictId = permanent.districtId;
      _permanentDistrictName = permanent.districtName;
      _permanentSubDistrictId = permanent.subDistrictId;
      _permanentSubDistrictName = permanent.subDistrictName;
      _permanentAddressLineController.text = permanent.addressLine ?? '';
    }
    _permanentSameAsPresent =
        present != null &&
        permanent != null &&
        present.districtId == permanent.districtId &&
        present.subDistrictId == permanent.subDistrictId &&
        present.addressLine == permanent.addressLine;

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
    _presentAddressLineController.dispose();
    _permanentAddressLineController.dispose();
    super.dispose();
  }

  bool _hasChanged() {
    return _nameController.text.trim() != widget.profile.name ||
        _mobileController.text.trim() != widget.profile.mobile ||
        _selectedHall != widget.profile.information.hall ||
        _selectedBloodGroup != widget.profile.information.blood ||
        _pickedMobileImage != null ||
        _addressDirty;
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

                          const SizedBox(height: Spacing.lg),

                          /// ---- PRESENT ADDRESS ----
                          const Text(
                            'Present Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DistrictSubDistrictPicker(
                            districtId: _presentDistrictId,
                            subDistrictId: _presentSubDistrictId,
                            onDistrictChanged: (d) => setState(() {
                              _presentDistrictId = d?.id;
                              _presentDistrictName = d?.name;
                              _addressDirty = true;
                              if (_permanentSameAsPresent) {
                                _permanentDistrictId = d?.id;
                                _permanentDistrictName = d?.name;
                              }
                            }),
                            onSubDistrictChanged: (s) => setState(() {
                              _presentSubDistrictId = s?.id;
                              _presentSubDistrictName = s?.name;
                              _addressDirty = true;
                              if (_permanentSameAsPresent) {
                                _permanentSubDistrictId = s?.id;
                                _permanentSubDistrictName = s?.name;
                              }
                            }),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _presentAddressLineController,
                            decoration: const InputDecoration(
                              hintText: 'House/road/hall name',
                            ),
                            onChanged: (v) {
                              _addressDirty = true;
                              if (_permanentSameAsPresent) {
                                setState(
                                  () => _permanentAddressLineController.text =
                                      v,
                                );
                              }
                            },
                          ),

                          const SizedBox(height: Spacing.lg),

                          /// ---- PERMANENT ADDRESS ----
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Permanent Address',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Same as present',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Checkbox(
                                    value: _permanentSameAsPresent,
                                    onChanged: (checked) => setState(() {
                                      _permanentSameAsPresent =
                                          checked ?? false;
                                      _addressDirty = true;
                                      if (_permanentSameAsPresent) {
                                        _permanentDistrictId =
                                            _presentDistrictId;
                                        _permanentDistrictName =
                                            _presentDistrictName;
                                        _permanentSubDistrictId =
                                            _presentSubDistrictId;
                                        _permanentSubDistrictName =
                                            _presentSubDistrictName;
                                        _permanentAddressLineController.text =
                                            _presentAddressLineController
                                                .text;
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (!_permanentSameAsPresent) ...[
                            const SizedBox(height: 8),
                            DistrictSubDistrictPicker(
                              districtId: _permanentDistrictId,
                              subDistrictId: _permanentSubDistrictId,
                              onDistrictChanged: (d) => setState(() {
                                _permanentDistrictId = d?.id;
                                _permanentDistrictName = d?.name;
                                _addressDirty = true;
                              }),
                              onSubDistrictChanged: (s) => setState(() {
                                _permanentSubDistrictId = s?.id;
                                _permanentSubDistrictName = s?.name;
                                _addressDirty = true;
                              }),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _permanentAddressLineController,
                              decoration: const InputDecoration(
                                hintText: 'House/road/village name',
                              ),
                              onChanged: (_) => _addressDirty = true,
                            ),
                          ],

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
      imageProvider = NetworkImage(
        ApiEndpoints.resolveImageUrl(widget.profile.image),
      );
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
      String? imageUrl;
      if (_pickedMobileImage != null) {
        imageUrl = await _uploadAndGetImageUrl();
      }

      String? hallId;
      if (_selectedHall != null &&
          _selectedHall != widget.profile.information.hall) {
        final halls = await ref.read(
          hallsByUniversityProvider(widget.profile.university).future,
        );
        hallId = halls.firstWhereOrNull((h) => h.name == _selectedHall)?.id;
      }

      final nameParts = _nameController.text.trim().split(RegExp(r'\s+'));
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      await updateMyUser(
        ref,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: imageUrl,
      );

      await updateMyStudent(
        ref,
        phone: _mobileController.text.trim(),
        bloodGroup: _selectedBloodGroup,
        hallId: hallId,
      );

      if (_addressDirty) {
        StudentAddress? present;
        if (_presentDistrictId != null) {
          present = StudentAddress(
            districtId: _presentDistrictId!,
            districtName: _presentDistrictName ?? '',
            subDistrictId: _presentSubDistrictId,
            subDistrictName: _presentSubDistrictName,
            addressLine: _presentAddressLineController.text.trim(),
          );
        }
        StudentAddress? permanent;
        final permanentDistrictId = _permanentSameAsPresent
            ? _presentDistrictId
            : _permanentDistrictId;
        if (permanentDistrictId != null) {
          permanent = StudentAddress(
            districtId: permanentDistrictId,
            districtName:
                (_permanentSameAsPresent
                    ? _presentDistrictName
                    : _permanentDistrictName) ??
                '',
            subDistrictId: _permanentSameAsPresent
                ? _presentSubDistrictId
                : _permanentSubDistrictId,
            subDistrictName: _permanentSameAsPresent
                ? _presentSubDistrictName
                : _permanentSubDistrictName,
            addressLine: _permanentAddressLineController.text.trim(),
          );
        }
        await updateMyStudentAddress(
          ref,
          present: present,
          permanent: permanent,
        );
      }

      ref.invalidate(userProvider);
      ref.invalidate(userProfileByUidProvider(widget.profile.uid));
      ref.invalidate(studentByUserIdProvider(widget.profile.uid));

      if (!mounted) return;
      _addressDirty = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String?> _uploadAndGetImageUrl() async {
    final apiClient = ref.read(apiClientProvider);
    if (kIsWeb) {
      final response = await apiClient.uploadBytes(
        '/upload',
        bytes: _webImage,
        fileName: 'avatar.jpg',
        fieldName: 'image',
        data: {'folder': 'avatars'},
      );
      return response.data['file_url'] as String?;
    }
    final file = _pickedMobileImage;
    if (file == null) return null;
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': 'avatars'},
    );
    return response.data['file_url'] as String?;
  }
}
