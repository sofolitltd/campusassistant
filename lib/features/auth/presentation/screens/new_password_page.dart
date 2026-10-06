import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '/widgets/common_text_field_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

/// Step 3 of the forgot-password flow: the code has already been verified, so
/// the user only chooses a new password. On success they are sent to the login
/// screen to sign in with it.
class NewPasswordPage extends ConsumerStatefulWidget {
  const NewPasswordPage({
    super.key,
    required this.email,
    required this.resetToken,
  });

  final String email;
  final String resetToken;

  @override
  ConsumerState<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends ConsumerState<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final result = await ref
        .read(authRepositoryProvider)
        .resetPassword(
          widget.email,
          widget.resetToken,
          _passwordController.text,
        );
    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold((failure) => Fluttertoast.showToast(msg: failure.message), (_) {
      Fluttertoast.showToast(
        msg: 'Password updated. Please sign in with your new password.',
      );
      context.goNamed(AppRoute.login.name);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('New password'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
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
                        'Choose a new password',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: .bold),
                      ),
                      Text(
                        'Code verified. Set a new password for your account.',
                        style: TextStyle(color: context.colors.textSubtle),
                      ),
                      const SizedBox(height: Spacing.sm),
                      const Divider(height: .5),
                      const SizedBox(height: Spacing.xxl),
                      CommonTextFieldWidget(
                        controller: _passwordController,
                        heading: 'New password',
                        hintText: 'At least 8 characters',
                        keyboardType: .visiblePassword,
                        obscureText: true,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter a new password';
                          }
                          // Matches the backend's minimum.
                          if (val.length < 8) {
                            return 'Use at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Spacing.lg),
                      CommonTextFieldWidget(
                        controller: _confirmController,
                        heading: 'Confirm password',
                        hintText: 'Re-enter your new password',
                        keyboardType: .visiblePassword,
                        obscureText: true,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: (val) {
                          if (val != _passwordController.text) {
                            return 'Passwords do not match';
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
                                'Update password',
                                style: const TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: .bold,
                                ),
                              ),
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
