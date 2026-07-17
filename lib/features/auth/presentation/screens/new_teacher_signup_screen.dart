import 'package:flutter/cupertino.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '/routes/app_route.dart';
import '/widgets/common_text_field_widget.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class NewTeacherSignupScreen extends ConsumerStatefulWidget {
  const NewTeacherSignupScreen({
    super.key,
    required this.university,
    required this.department,
    required this.profession,
    required this.name,
    required this.information,
    required this.verificationUID,
  });

  final String university;
  final String department;
  final String profession;
  final String name;
  final String verificationUID;
  final Map<dynamic, dynamic> information;

  @override
  ConsumerState<NewTeacherSignupScreen> createState() =>
      _NewTeacherSignupScreenState();
}

class _NewTeacherSignupScreenState
    extends ConsumerState<NewTeacherSignupScreen> {
  var regExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _mobileController.text = widget.information['mobile'] ?? '';
    _emailController.text = widget.information['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.profession} Sign Up'),
        centerTitle: true,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Hello Sir'.toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                        ),
                        Text(
                          'Please sign up your account',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(fontWeight: FontWeight.w100),
                        ),
                        const SizedBox(height: 24),
                        CommonTextFieldWidget(
                          controller: _nameController,
                          heading: 'Name',
                          hintText: 'Enter full name',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.lg),
                        CommonTextFieldWidget(
                          controller: _mobileController,
                          heading: 'Mobile',
                          hintText: 'Enter mobile number',
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter mobile number';
                            }
                            if (val.length < 11) {
                              return 'Mobile number at least 11 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.lg),
                        CommonTextFieldWidget(
                          controller: _emailController,
                          heading: 'Email',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your email';
                            } else if (!regExp.hasMatch(val)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.lg),
                        CommonTextFieldWidget(
                          heading: 'Password',
                          controller: _passwordController,
                          hintText: 'Enter new password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
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
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
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
                                      final names = _nameController.text
                                          .trim()
                                          .split(' ');
                                      final firstName = names.first;
                                      final lastName = names.length > 1
                                          ? names.sublist(1).join(' ')
                                          : ' ';

                                      final result = await authRepo.register(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        firstName: firstName,
                                        lastName: lastName,
                                        phone: _mobileController.text.trim(),
                                        universityId: widget.university,
                                        departmentId: widget.department,
                                      );

                                      result.fold(
                                        (failure) {
                                          Fluttertoast.showToast(
                                            msg: failure.message,
                                          );
                                          setState(() => _isLoading = false);
                                        },
                                        (user) {
                                          Fluttertoast.showToast(
                                            msg: 'Signup successful!',
                                          );
                                          // TODO: Claim teacher profile in Go backend
                                          // For now, redirecting to home
                                          if (!mounted) return;
                                          context.goNamed(AppRoute.home.name);
                                        },
                                      );
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: 'Signup error: $e',
                                      );
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CupertinoActivityIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Sign up'.toUpperCase(),
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
    );
  }
}
