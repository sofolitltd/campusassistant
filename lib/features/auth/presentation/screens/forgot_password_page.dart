import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart';
import '/widgets/common_text_field_widget.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  var regExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Forgot password'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .3
                  : 16,
              vertical: 16,
            ),
            child: Container(
              constraints: const BoxConstraints(minWidth: 350, maxWidth: 400),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Reset your password'.toUpperCase(),
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Enter your email address and we will send you instructions to reset your password.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: .5),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);

                                  try {
                                    final authRepo = ref.read(
                                      authRepositoryProvider,
                                    );
                                    final result = await authRepo
                                        .forgotPassword(
                                          _emailController.text.trim(),
                                        );

                                    result.fold(
                                      (failure) {
                                        Fluttertoast.showToast(
                                          msg: failure.message,
                                        );
                                        setState(() => _isLoading = false);
                                      },
                                      (_) {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Password reset instructions sent to your email',
                                        );
                                        setState(() => _isLoading = false);
                                        Navigator.pop(context);
                                      },
                                    );
                                  } catch (e) {
                                    Fluttertoast.showToast(msg: 'Error: $e');
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
                                'Submit'.toUpperCase(),
                                style: const TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '* If you don\'t see the email in your inbox, check your spam folder.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
