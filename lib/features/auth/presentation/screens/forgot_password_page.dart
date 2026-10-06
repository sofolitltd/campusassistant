import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '/widgets/common_text_field_widget.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();

    final result = await ref.read(authRepositoryProvider).forgotPassword(email);
    // The widget can be disposed while the request is in flight — touching
    // context or calling setState afterwards would throw.
    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold((failure) => Fluttertoast.showToast(msg: failure.message), (_) {
      // Deliberately neutral: the backend returns the same response whether or
      // not the account exists, and this copy must not contradict that by
      // implying an email was definitely sent to a real account.
      Fluttertoast.showToast(
        msg: 'If an account exists for that email, we sent a code.',
      );
      context.pushNamed(AppRoute.resetPassword.name, extra: email);
    });
  }

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
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(RadiusToken.xl),
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
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    children: [
                      Text(
                        'Reset your password',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(fontWeight: .bold),
                      ),
                      Text(
                        'Enter your email address and we will send you a 6-digit code to reset your password.',
                        style: TextStyle(color: context.colors.textSubtle),
                      ),
                      const SizedBox(height: Spacing.sm),
                      const Divider(height: .5),
                      const SizedBox(height: Spacing.xxl),
                      CommonTextFieldWidget(
                        controller: _emailController,
                        heading: 'Email',
                        hintText: 'Enter your email',
                        keyboardType: .emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter your email';
                          } else if (!regExp.hasMatch(val)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Spacing.xxl),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CupertinoActivityIndicator(
                                  color: context.colors.onPrimary,
                                ),
                              )
                            : Text(
                                'Submit',
                                style: const TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: .bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: Spacing.xxxl),
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
