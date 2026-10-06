import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import '/widgets/common_text_field_widget.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _logoutOtherDevices = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ref
        .read(authRepositoryProvider)
        .changePassword(
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
          logoutOtherDevices: _logoutOtherDevices,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold((failure) => Fluttertoast.showToast(msg: failure.message), (_) {
      Fluttertoast.showToast(msg: 'Password changed successfully');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + Spacing.lg,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .3
                    : Spacing.lg,
                vertical: Spacing.lg,
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
                          'Change password',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(fontWeight: .bold),
                        ),
                        Text(
                          'Enter a new password for your account.',
                          style: TextStyle(color: context.colors.textMuted),
                        ),
                        const SizedBox(height: Spacing.sm),
                        const Divider(height: .5),
                        const SizedBox(height: Spacing.lg),
                        Container(
                          padding: const EdgeInsets.all(Spacing.sm),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                          ),
                          child: Row(
                            crossAxisAlignment: .start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: Spacing.xxs,
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Expanded(
                                child: Text(
                                  'Changing your password will log you out of other devices.',
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        CommonTextFieldWidget(
                          controller: _oldPasswordController,
                          heading: 'Old password',
                          hintText: 'Enter your current password',
                          keyboardType: .visiblePassword,
                          obscureText: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your current password';
                            }
                            if (val.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.lg),
                        CommonTextFieldWidget(
                          controller: _newPasswordController,
                          heading: 'New password',
                          hintText: 'Enter your new password',
                          keyboardType: .visiblePassword,
                          obscureText: true,
                          textInputAction: .next,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your new password';
                            }
                            if (val.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (val == _oldPasswordController.text) {
                              return 'New password must be different from old password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(left: Spacing.xxs),
                          child: Text(
                            'Use 8 or more characters',
                            style: TextStyle(
                              fontSize: FontSizeToken.sm,
                              color: context.colors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        CommonTextFieldWidget(
                          controller: _confirmPasswordController,
                          heading: 'Confirm new password',
                          hintText: 'Re-enter your new password',
                          keyboardType: .visiblePassword,
                          obscureText: true,
                          textInputAction: .done,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Confirm your new password';
                            }
                            if (val != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.md),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? context.colors.surface.withValues(alpha: 0.03)
                                : context.colors.surfaceAlt,
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                            border: Border.all(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? context.colors.border
                                  : context.colors.border,
                            ),
                          ),
                          child: SwitchListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                            ),
                            secondary: Icon(
                              Icons.devices_outlined,
                              size: 20,
                              color: _logoutOtherDevices
                                  ? Theme.of(context).colorScheme.primary
                                  : context.colors.textSubtle,
                            ),
                            title: Text(
                              'Logout other devices',
                              style: TextStyle(
                                fontSize: FontSizeToken.md,
                                fontWeight: .w500,
                              ),
                            ),
                            subtitle: Text(
                              'End active sessions on other phones',
                              style: TextStyle(
                                fontSize: FontSizeToken.xs,
                                color: context.colors.textMuted,
                              ),
                            ),
                            value: _logoutOtherDevices,
                            onChanged: (v) =>
                                setState(() => _logoutOtherDevices = v),
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
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
                                  'Change password',
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
      ),
    );
  }
}
