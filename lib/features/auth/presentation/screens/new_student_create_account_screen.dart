import 'dart:io';
import 'dart:ui' as ui;

import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusassistant/features/student/presentation/providers/student_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:campusassistant/routes/app_route.dart';

import '/widgets/common_text_field_widget.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';


class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({
    super.key,
    required this.universityId,
    required this.departmentId,
    required this.university,
    required this.department,
    required this.profession,
    required this.name,
    required this.mobile,
    required this.batchId,
    required this.studentId,
    required this.sessionId,
    required this.hallId,
    required this.hallName,
    required this.blood,
    required this.verificationUID,
  });

  final String universityId;
  final String departmentId;
  final String university;
  final String department;
  final String profession;
  final String name;
  final String mobile;
  final String batchId;
  final String studentId;
  final String sessionId;
  final String? hallId;
  final String hallName;
  final String blood;
  final String verificationUID;

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  var regExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);
  bool isUpload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up(2/2)'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .3
                  : 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 6,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Account'.toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: .2,
                              ),
                        ),
                        Text(
                          'with email and password',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(fontWeight: FontWeight.w100),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _pickedMobileImage == null
                                ? Container(
                                    height: 116,
                                    width: 116,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                                      color: Colors.grey.shade200,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'No image selected',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Container(
                                    height: 116,
                                    width: 116,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                                      border: Border.all(
                                        color: Colors.blueGrey.shade100,
                                      ),
                                      image: kIsWeb
                                          ? DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: MemoryImage(_webImage),
                                            )
                                          : DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: FileImage(
                                                _pickedMobileImage!,
                                              ),
                                            ),
                                    ),
                                  ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 116,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '* Try to use formal photo.\n* Female can use photo with Hijab & Nikab.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            height: 1.2,
                                            color: Colors.red,
                                          ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _pickedMobileImage == null
                                            ? Colors.grey
                                            : Colors.red.shade400,
                                      ),
                                      onPressed: () async {
                                        await pickImage(context);
                                      },
                                      child: Text(
                                        _pickedMobileImage == null
                                            ? 'Choose your Photo'.toUpperCase()
                                            : 'Change your Photo'.toUpperCase(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CommonTextFieldWidget(
                          controller: _emailController,
                          heading: 'Email',
                          hintText: 'Enter email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your email';
                            } else if (!regExp.hasMatch(val)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CommonTextFieldWidget(
                          heading: 'Password',
                          controller: _passwordController,
                          hintText: 'Enter new password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your password';
                            } else if (val.length < 8) {
                              return 'Password at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '* Please remember this email and password for further login.',
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: Spacing.lg),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(RadiusToken.md),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_globalKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);

                                    try {
                                      final authRepo = ref.read(
                                        authRepositoryProvider,
                                      );
                                      final names = widget.name.split(' ');
                                      final firstName = names.first;
                                      final lastName = names.length > 1
                                          ? names.sublist(1).join(' ')
                                          : ' ';

                                      final regResult = await authRepo.register(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        firstName: firstName,
                                        lastName: lastName,
                                        phone: widget.mobile,
                                        gender: null,
                                        universityId: widget.universityId,
                                        departmentId: widget.departmentId,
                                      );

                                      await regResult.fold(
                                        (failure) async {
                                          Fluttertoast.showToast(
                                            msg:
                                                'Registration error: ${failure.message}',
                                            backgroundColor: Colors.red,
                                          );
                                          setState(() => _isLoading = false);
                                        },
                                        (goUser) async {
                                          final studentRepo = ref.read(
                                            studentRepositoryProvider,
                                          );
                                          try {
                                            await studentRepo.claimProfile(
                                              code: widget.verificationUID,
                                              userId: goUser.id,
                                              studentId: widget.studentId,
                                              phone: widget.mobile,
                                              bloodGroup: widget.blood,
                                              hallId: widget.hallId,
                                              batchId: widget.batchId,
                                              sessionId: widget.sessionId,
                                              departmentId:
                                                  widget.departmentId,
                                              universityId:
                                                  widget.universityId,
                                            );

                                            Fluttertoast.showToast(
                                              msg:
                                                  'Welcome to Campus Assistant!',
                                              backgroundColor: Colors.green,
                                            );

                                            // Force refresh current user to trigger router redirect
                                            ref.invalidate(
                                              currentUserProvider,
                                            );

                                            if (!context.mounted) return;
                                            context.goNamed(
                                              AppRoute.home.name,
                                            );
                                          } catch (claimError) {
                                            Fluttertoast.showToast(
                                              msg:
                                                  'Profile setup failed: $claimError',
                                              backgroundColor: Colors.orange,
                                            );
                                            setState(
                                              () => _isLoading = false,
                                            );
                                          }
                                        },
                                      );
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: 'An unexpected error occurred',
                                      );
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Complete Registration'.toUpperCase(),
                                  style: const TextStyle(
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    if (!context.mounted) return;

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Customization',
          toolbarColor: ThemeData().cardColor,
          toolbarWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          cropStyle: CropStyle.rectangle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(width: 350, height: 350),
        ),
      ],
    );

    if (croppedImage == null) return;

    if (!kIsWeb) {
      File file = File(croppedImage.path);
      Uint8List compressed = await _compressImageIfNeeded(
        await file.readAsBytes(),
        150 * 1024,
      );
      File finalFile = await file.writeAsBytes(compressed);
      setState(() {
        _pickedMobileImage = finalFile;
      });
    } else {
      Uint8List bytes = await croppedImage.readAsBytes();
      Uint8List compressed = await _compressImageIfNeeded(bytes, 150 * 1024);
      setState(() {
        _webImage = compressed;
        _pickedMobileImage = File('');
      });
    }
  }

  Future<Uint8List> _compressImageIfNeeded(Uint8List bytes, int maxSize) async {
    if (bytes.length <= maxSize) return bytes;
    int quality = 90;
    Uint8List result = bytes;
    while (result.length > maxSize && quality > 10) {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: null,
        targetHeight: null,
        allowUpscaling: false,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) result = byteData.buffer.asUint8List();
      quality -= 10;
    }
    return result;
  }
}
