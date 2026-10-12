import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/features/auth/presentation/providers/auth_provider.dart';

/// Account signup for students without a verification code. Creates a plain
/// account, then hands off to the document verification form — the account
/// is linked to a student profile only after an admin approves.
class DocumentSignupScreen extends ConsumerStatefulWidget {
  const DocumentSignupScreen({super.key});

  @override
  ConsumerState<DocumentSignupScreen> createState() =>
      _DocumentSignupScreenState();
}

class _DocumentSignupScreenState extends ConsumerState<DocumentSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await ref
        .read(authRepositoryProvider)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _loading = false);
        Fluttertoast.showToast(msg: 'Registration error: ${failure.message}');
      },
      // Once the user refreshes to signed-in, the router redirect moves this
      // guest route on to the verification form (see router_config.dart).
      (_) => ref.invalidate(currentUserProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
          title: Text(
            'Create account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.colors.onPrimary,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxxl),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: Spacing.xl,
              horizontal: width > 800 ? width * .3 : Spacing.lg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Step 1 of 2 — create your account. Next you will upload '
                    'your student ID card for verification.',
                    style: TextStyle(
                      color: context.colors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'First name',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Enter your email';
                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile number',
                    ),
                    validator: (v) => (v == null || v.trim().length < 11)
                        ? 'Enter your mobile number'
                        : null,
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 8)
                        ? 'Password at least 8 characters'
                        : null,
                  ),
                  const SizedBox(height: Spacing.xxxl),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        ControlToken.height,
                      ),
                    ),
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
