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
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/utils/constants.dart';
import '/core/di.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/network/api_endpoints.dart';
import '/widgets/district_sub_district_picker.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

const kGenderOptions = <String>['Male', 'Female'];

class EditProfilePage extends ConsumerWidget {
  final String uid;

  const EditProfilePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileByUidProvider(uid));
    final studentAsync = ref.watch(studentByUserIdProvider(uid));
    // Gender lives on the `User` entity, not `ProfileModel`/`Student` (which
    // this screen otherwise reads from) — this screen only ever edits the
    // signed-in user's own profile, so `currentUserProvider` is safe to use
    // for it here.
    final currentUserAsync = ref.watch(currentUserProvider);

    return CustomHeaderLayout(
      title: 'Edit Profile',
      showSearchBar: false,
      body: profileAsync.when(
        data: (profile) => _EditProfileForm(
          profile: profile,
          presentAddress: studentAsync.value?.presentAddress,
          permanentAddress: studentAsync.value?.permanentAddress,
          initialGender: currentUserAsync.value?.gender,
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
  final String? initialGender;

  const _EditProfileForm({
    required this.profile,
    this.presentAddress,
    this.permanentAddress,
    this.initialGender,
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
  String? _selectedGender;
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
    _selectedGender = _validGender(widget.initialGender);

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

  String? _validGender(String? gender) {
    if (gender == null || gender.isEmpty) return null;
    return kGenderOptions.contains(gender) ? gender : null;
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
        _selectedGender != widget.initialGender ||
        _pickedMobileImage != null ||
        _addressDirty;
  }

  @override
  Widget build(BuildContext context) {
    final hallsAsync = ref.watch(hallsProvider);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.all(Spacing.lg),
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
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        /// ---- SECTION 1: PROFILE IMAGE ----
                        _buildSectionCard(
                          context,
                          children: [
                            Row(
                              children: [
                                _buildProfileImage(context),
                                const SizedBox(width: Spacing.lg),
                                Expanded(
                                  child: _buildPhotoInstruction(context),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: Spacing.lg),

                        /// ---- SECTION 2: PERSONAL INFO ----
                        _buildSectionCard(
                          context,
                          children: [
                            /// ---- NAME ----
                            const Text('Name'),
                            const SizedBox(height: Spacing.sm),
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: .words,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter your name' : null,
                            ),

                            const SizedBox(height: Spacing.lg),

                            /// ---- MOBILE ----
                            const Text('Mobile Number'),
                            const SizedBox(height: Spacing.sm),
                            TextFormField(
                              controller: _mobileController,
                              keyboardType: .phone,
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

                            const SizedBox(height: Spacing.lg),

                            /// ---- GENDER + BLOOD ----
                            Row(
                              crossAxisAlignment: .start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      const Text('Gender'),
                                      const SizedBox(height: Spacing.sm),
                                      DropdownButtonFormField<String>(
                                        initialValue: _selectedGender,
                                        decoration: const InputDecoration(
                                          hintText: 'Select gender',
                                        ),
                                        isDense: true,
                                        onChanged: (val) => setState(
                                          () => _selectedGender = val,
                                        ),
                                        dropdownColor: Theme.of(
                                          context,
                                        ).cardColor,
                                        items: kGenderOptions
                                            .map(
                                              (g) => DropdownMenuItem(
                                                value: g,
                                                child: Text(g),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Spacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      const Text('Blood Group'),
                                      const SizedBox(height: Spacing.sm),
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
                            const SizedBox(height: Spacing.sm),

                            hallsAsync.when(
                              data: (hallList) {
                                final validHall =
                                    hallList.contains(_selectedHall)
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
                                            overflow: .ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                              loading: () => const Padding(
                                padding: EdgeInsets.all(Spacing.sm),
                                child: CupertinoActivityIndicator(),
                              ),
                              error: (e, _) => Text('Error loading halls: $e'),
                            ),
                          ],
                        ),

                        const SizedBox(height: Spacing.lg),

                        /// ---- SECTION 3: ADDRESS ----
                        _buildSectionCard(
                          context,
                          children: [
                            /// ---- PRESENT ADDRESS ----
                            const Text(
                              'Present Address',
                              style: TextStyle(fontWeight: .bold),
                            ),
                            const SizedBox(height: Spacing.sm),
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
                            const SizedBox(height: Spacing.sm),
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
                                    style: TextStyle(fontWeight: .bold),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: .min,
                                  children: [
                                    const Text(
                                      'Same as present',
                                      style: TextStyle(
                                        fontSize: FontSizeToken.sm,
                                      ),
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
                              const SizedBox(height: Spacing.sm),
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
                              const SizedBox(height: Spacing.sm),
                              TextFormField(
                                controller: _permanentAddressLineController,
                                decoration: const InputDecoration(
                                  hintText: 'House/road/village name',
                                ),
                                onChanged: (_) => _addressDirty = true,
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: Spacing.xxl),

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper widgets ---
  Widget _buildSectionCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: .stretch, children: children),
    );
  }

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
            : context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? context.colors.border
              : context.colors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: .antiAlias,
      child: imageProvider != null
          ? Image(
              image: imageProvider,
              fit: .cover,
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
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            '* Try to use a formal photo.\n'
            '* Female can use photo with Hijab or Niqab.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1.2),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _pickedMobileImage == null
                  ? 'Change Photo'
                  : 'New Photo Selected',
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
          toolbarWidgetColor: context.colors.warning,
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
        gender: _selectedGender,
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
      ref.invalidate(currentUserProvider);
      ref.invalidate(userProfileByUidProvider(widget.profile.uid));
      ref.invalidate(studentByUserIdProvider(widget.profile.uid));

      if (!mounted) return;
      _addressDirty = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
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
