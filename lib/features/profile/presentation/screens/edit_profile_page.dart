import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:collection/collection.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
import '/core/theme/tokens/app_layout.dart';
import '/core/widgets/app_network_image.dart';

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
        // Picking/cropping a photo backgrounds the app briefly (native
        // cropper activity, or the browser's file dialog on web), which
        // triggers main.dart's app-resume refresh. That bumps
        // appRefreshProvider, which batch/session providers watch, which
        // cascades into this screen's own provider chain
        // (studentByUserIdProvider -> userProfileByUidProvider) and would
        // otherwise swap this form out for the loading spinner below —
        // disposing _EditProfileFormState while _pickImage's crop Future is
        // still in flight, crashing on the setState when it resolves and
        // silently dropping the picked photo. Keep rendering the existing
        // form with its stale data during that reload instead.
        skipLoadingOnReload: true,
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

  // Compressed, ready-to-upload avatar bytes — set by _pickImage once the
  // cropped image has been shrunk under kMaxAvatarBytes. Using bytes on both
  // platforms (instead of a dart:io File on mobile) keeps preview + upload
  // identical cross-platform.
  Uint8List? _pickedImageBytes;

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
        _pickedImageBytes != null ||
        _addressDirty;
  }

  @override
  Widget build(BuildContext context) {
    final hallsAsync = ref.watch(hallsProvider);

    // The Update button lives outside the scroll view, in a fixed footer
    // (see _buildStickyFooter) — it used to be the last item inside the
    // SingleChildScrollView, where a long form (or the keyboard opening)
    // pushed it off-screen, so it was easy to back out of the screen
    // without ever seeing it was there to tap.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppLayout.pageWidth),
                child: Form(
                  key: _formKey,
                  child: ButtonTheme(
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
                                        dropdownColor: Theme.of(context)
                                            .cardColor,
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
                                        dropdownColor: Theme.of(context)
                                            .cardColor,
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
                            const SizedBox(height: Spacing.md),
                            const Text('Home Address'),
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
                              const SizedBox(height: Spacing.md),
                              const Text('Home Address'),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildStickyFooter(context),
      ],
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : context.colors.surface,
          border: Border(top: BorderSide(color: context.colors.border)),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(Spacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppLayout.pageWidth),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || !_hasChanged()
                    ? null
                    : _updateProfile,
                child: _isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text('UPDATE'),
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
    if (_pickedImageBytes != null) {
      imageProvider = MemoryImage(_pickedImageBytes!);
    } else if (widget.profile.image.isNotEmpty) {
      imageProvider = AppNetworkImage.provider(
        ApiEndpoints.resolveImageUrl(widget.profile.image),
        maxSize: 384,
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
              _pickedImageBytes == null
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
          size: const CropperSize(width: 320, height: 320),
          viewMode: WebViewMode.mode_1,
          initialAspectRatio: 1,
          customDialogBuilder: (cropper, initCropper, crop, rotate, scale) =>
              _CropperDialog(
                cropper: cropper,
                initCropper: initCropper,
                crop: crop,
                rotate: rotate,
                scale: scale,
                cropSize: 320,
              ),
        ),
      ],
    );

    if (cropped == null) return;

    final rawBytes = await cropped.readAsBytes();
    final compressed = await _compressAvatarBytes(rawBytes);
    if (!mounted) return;
    setState(() => _pickedImageBytes = compressed);
  }

  /// Shrinks [bytes] to a JPEG no larger than [kMaxAvatarBytes] (100 KB),
  /// stepping quality down until it fits. Both platforms need this: mobile's
  /// native cropper quality setting (compressQuality above) only roughly
  /// controls output size, and the web cropper ignores it entirely (see
  /// image_cropper_for_web's own docs — ignored param), so this is the one
  /// place that actually enforces the limit on either platform.
  static const kMaxAvatarBytes = 100 * 1024;

  Future<Uint8List> _compressAvatarBytes(Uint8List bytes) async {
    if (bytes.lengthInBytes <= kMaxAvatarBytes) return bytes;

    for (final quality in const [70, 55, 40, 25, 15]) {
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 512,
        minHeight: 512,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (result.length <= kMaxAvatarBytes) return result;
    }

    // Lowest quality didn't make it either — return it anyway; the backend
    // enforces the hard cap and will reject it rather than silently bloat.
    return FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 512,
      minHeight: 512,
      quality: 10,
      format: CompressFormat.jpeg,
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String? imageUrl;
      if (_pickedImageBytes != null) {
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
    final bytes = _pickedImageBytes;
    if (bytes == null) return null;
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.uploadBytes(
      '/upload',
      bytes: bytes,
      fileName: 'avatar.jpg',
      fieldName: 'image',
      data: {'folder': 'avatars'},
    );
    return response.data['file_url'] as String?;
  }
}

/// Replaces image_cropper_for_web's stock dialog (large title, a bottom
/// Cancel text button alongside Crop, and a size that overflowed on short
/// viewports) with a compact header (X close, top-right) and a single Crop
/// action, sized to always fit — the whole thing scrolls as a fallback on
/// very short viewports instead of overflowing.
class _CropperDialog extends StatefulWidget {
  final Widget cropper;
  final VoidCallback initCropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle) rotate;
  final void Function(num) scale;
  final double cropSize;

  const _CropperDialog({
    required this.cropper,
    required this.initCropper,
    required this.crop,
    required this.rotate,
    required this.scale,
    required this.cropSize,
  });

  @override
  State<_CropperDialog> createState() => _CropperDialogState();
}

class _CropperDialogState extends State<_CropperDialog> {
  double _scaleValue = 1;
  bool _cropping = false;

  @override
  void initState() {
    super.initState();
    widget.initCropper();
  }

  Future<void> _doCrop() async {
    if (_cropping) return;
    setState(() => _cropping = true);
    final result = await widget.crop();
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(Spacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Crop Photo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(RadiusToken.md),
                child: SizedBox(
                  width: widget.cropSize,
                  height: widget.cropSize,
                  child: widget.cropper,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.rotate_90_degrees_ccw_rounded),
                    tooltip: 'Rotate left',
                    onPressed: () =>
                        widget.rotate(RotationAngle.counterClockwise90),
                  ),
                  Expanded(
                    child: Slider(
                      value: _scaleValue,
                      min: 1,
                      max: 3,
                      label: _scaleValue.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() => _scaleValue = value);
                        widget.scale(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
                    tooltip: 'Rotate right',
                    onPressed: () => widget.rotate(RotationAngle.clockwise90),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              ElevatedButton(
                onPressed: _cropping ? null : _doCrop,
                child: _cropping
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
