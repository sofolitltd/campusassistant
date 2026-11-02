import '/core/widgets/app_loader.dart';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/features/auth/domain/entities/user.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/routes/app_route.dart';

import 'package:go_router/go_router.dart';

import '/widgets/common_text_field_widget.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/widgets/header_gradient_backdrop.dart';

/// One-screen signup for a student who entered a valid verification code:
/// review the pre-verified record, confirm the certificate name, choose
/// email + password. Mobile, blood group, hall and photo are left for
/// "Complete your profile" afterwards — the CR/admin record often has them
/// already, and fewer fields here means fewer people dropping off.
///
/// The code is only consumed by the final claim; looking it up (here and on
/// the verification page) is read-only, so any failure before that leaves
/// the code valid to retry.
class NewStudentSignUpScreen extends ConsumerStatefulWidget {
  const NewStudentSignUpScreen({super.key, required this.code});

  /// The verification code from the previous screen (the route still calls
  /// this path parameter `studentId`).
  final String code;

  @override
  ConsumerState<NewStudentSignUpScreen> createState() =>
      _NewStudentSignUpScreenState();
}

class _NewStudentSignUpScreenState
    extends ConsumerState<NewStudentSignUpScreen> {
  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  bool _initialized = false;
  bool _showReferral = false;
  bool _isLoading = false;

  /// Set once the account exists, so a failed profile claim can be retried
  /// without registering again (which would fail with "email already exists").
  User? _account;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(studentByCodeProvider(widget.code));

    return studentAsync.when(
      // Any app resume (keyboard autofill/password-manager overlays on
      // Android, switching to the mail app) bumps appRefreshProvider, which
      // batchesByDepartmentProvider watches, which reloads this provider.
      // Without these the form is swapped for the spinner mid-typing —
      // focus lost, keyboard closed. Keep showing the record we have.
      skipLoadingOnReload: true,
      skipError: true,
      data: (s) {
        if (!_initialized) {
          _nameController.text = s.studentName ?? '';
          _initialized = true;
        }
        return _buildForm(context, s);
      },
      loading: () => const Scaffold(body: Center(child: AppLoader())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Create account')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Text(
              'Could not load your record. Check the code and try again.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, Student s) {
    final universityName = ref.watch(universityNameProvider(s.universityId));
    final departmentName = ref.watch(
      departmentNameProvider('${s.universityId}|${s.departmentId}'),
    );
    final locked = _account != null;

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Create account',
            style: TextStyle(
              color: context.colors.onPrimary,
              fontWeight: .bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.colors.onPrimary),
            onPressed: () => context.pop(),
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
            child: Form(
              key: _globalKey,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      Text(
                        'Welcome!',
                        style: Theme.of(context).textTheme.titleLarge!
                            .copyWith(fontWeight: .bold, letterSpacing: .5),
                      ),
                      Text(
                        'Check your record and create your account.',
                        style: Theme.of(context).textTheme.labelLarge!
                            .copyWith(color: context.colors.textMuted),
                      ),
                      const SizedBox(height: Spacing.lg),
                      _VerifiedRecordCard(
                        universityName: universityName,
                        departmentName: departmentName,
                        studentId: s.studentId,
                        batch: s.batch,
                      ),
                      const SizedBox(height: Spacing.lg),
                      _SectionCard(
                        icon: Icons.badge_outlined,
                        title: 'Your name',
                        children: [
                          CommonTextFieldWidget(
                            controller: _nameController,
                            heading: 'Full name (as on your certificate)',
                            hintText: 'e.g. Shihab Morshed',
                            keyboardType: .name,
                            textCapitalization: .words,
                            autofillHints: const [AutofillHints.name],
                            enabled: !locked,
                            validator: (val) {
                              if (_normalizeName(val ?? '').length < 3) {
                                return 'Enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Spacing.xs),
                          const _FieldNote(
                            'Check the spelling carefully. Your name is '
                            'locked once your account is verified.',
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.lg),
                      _SectionCard(
                        icon: Icons.lock_outline,
                        title: 'Login details',
                        children: [
                          const _PasswordHint(),
                          const SizedBox(height: Spacing.md),
                          CommonTextFieldWidget(
                            controller: _emailController,
                            heading: 'Email',
                            hintText: 'you@example.com',
                            keyboardType: .emailAddress,
                            autofillHints: const [AutofillHints.email],
                            enabled: !locked,
                            validator: (val) {
                              final v = (val ?? '').trim();
                              if (v.isEmpty) return 'Enter your email';
                              if (!_emailRegExp.hasMatch(v)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Spacing.xs),
                          const _FieldNote(
                            'Use an email you can open — you\'ll log in with '
                            'it and need it to reset your password.',
                          ),
                          const SizedBox(height: Spacing.md),
                          CommonTextFieldWidget(
                            heading: 'New password for Campus Assistant',
                            controller: _passwordController,
                            hintText: 'At least 8 characters',
                            keyboardType: .visiblePassword,
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                            enabled: !locked,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Enter a password';
                              }
                              if (val.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Spacing.sm),
                          if (_showReferral)
                            CommonTextFieldWidget(
                              heading: 'Referral code (optional)',
                              controller: _referralController,
                              hintText: 'Code from a friend\'s member card',
                              keyboardType: .text,
                              textCapitalization: .characters,
                              enabled: !locked,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z0-9]'),
                                ),
                              ],
                              validator: (_) => null,
                            )
                          else
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: locked
                                    ? null
                                    : () =>
                                          setState(() => _showReferral = true),
                                child: const Text('Have a referral code?'),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xl),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            ControlToken.height,
                          ),
                        ),
                        onPressed: _isLoading ? null : () => _submit(),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: AppLoader(),
                              )
                            : Text(
                                locked ? 'Try again' : 'Create account',
                                style: const TextStyle(fontWeight: .bold),
                              ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        'You can add your mobile, blood group, hall and '
                        'photo from your profile after signing up.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.textMuted,
                          fontSize: FontSizeToken.xs,
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

  static String _normalizeName(String raw) =>
      raw.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).join(' ');

  Future<void> _submit() async {
    if (!_globalKey.currentState!.validate()) return;
    final name = _normalizeName(_nameController.text);

    if (_account == null && !await _confirmName(name)) return;
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final account = _account ?? await _createOrSignIn(name);
      if (account == null) return; // error already shown
      if (_account == null) setState(() => _account = account);

      // The only step that consumes the code.
      await ref
          .read(studentRepositoryProvider)
          .claimProfile(code: widget.code, userId: account.id, name: name);

      Fluttertoast.showToast(msg: 'Welcome to Campus Assistant!');
      // Refreshing the current user is what lets the router leave the
      // guest-only signup routes.
      ref.invalidate(currentUserProvider);
      if (!mounted) return;
      context.goNamed(AppRoute.home.name);
    } catch (e) {
      _showError(
        _account == null
            ? 'Something went wrong. Please try again.'
            : 'Your account was created, but linking your student record '
                  'failed. Your code is still valid — tap "Try again".',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Registers the account. If the email is already registered — e.g. an
  /// earlier attempt created the account but the claim then failed and the
  /// app was closed — signs in with the same credentials instead, so the
  /// claim can still go through.
  Future<User?> _createOrSignIn(String name) async {
    final auth = ref.read(authRepositoryProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final parts = name.split(' ');

    final registered = await auth.register(
      email: email,
      password: password,
      firstName: parts.first,
      // The API requires a last name; single-word names send a space.
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : ' ',
      referralCode: _referralController.text,
    );

    return registered.fold((failure) async {
      if (!failure.message.toLowerCase().contains('already exists')) {
        _showError(failure.message);
        return null;
      }
      final signedIn = await auth.login(email: email, password: password);
      return signedIn.fold((_) {
        _showError(
          'This email already has an account. Enter its password, '
          'or use a different email.',
        );
        return null;
      }, (user) => user);
    }, (user) => user);
  }

  Future<bool> _confirmName(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Is your name correct?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('It should match your certificate exactly:'),
            const SizedBox(height: Spacing.md),
            Text(
              name,
              style: Theme.of(ctx).textTheme.titleMedium!
                  .copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'You won\'t be able to change it yourself later.',
              style: TextStyle(color: ctx.colors.textMuted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, it\'s correct'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

/// The read-only record the CR/admin entered, shown so the student can see
/// the code matched the right person before creating an account. Labels sit
/// above values so long university/department names get the full width.
class _VerifiedRecordCard extends StatelessWidget {
  const _VerifiedRecordCard({
    required this.universityName,
    required this.departmentName,
    required this.studentId,
    required this.batch,
  });

  final String universityName;
  final String departmentName;
  final String studentId;
  final String batch;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors.infoSubtle,
        borderRadius: BorderRadius.circular(RadiusToken.xl),
        border: Border.all(color: colors.info.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: colors.info, size: 18),
              const SizedBox(width: Spacing.sm),
              Text(
                'Pre-verified student record',
                style: TextStyle(
                  color: colors.info,
                  fontWeight: .bold,
                  fontSize: FontSizeToken.sm,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _RecordField(label: 'University', value: universityName),
          const SizedBox(height: Spacing.md),
          _RecordField(label: 'Department', value: departmentName),
          const SizedBox(height: Spacing.md),
          // Short values — side by side saves a row.
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: _RecordField(label: 'Student ID', value: studentId),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: _RecordField(label: 'Batch', value: batch),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordField extends StatelessWidget {
  const _RecordField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: FontSizeToken.xs,
            fontWeight: .w600,
          ),
        ),
        const SizedBox(height: Spacing.xxs),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!
              .copyWith(fontWeight: .w600, color: colors.text),
        ),
      ],
    );
  }
}

/// A titled white card grouping one step of the form.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.xl),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: Spacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!
                    .copyWith(fontWeight: .w700),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ...children,
        ],
      ),
    );
  }
}

/// Answers the common "is this my Gmail password?" confusion up front.
class _PasswordHint extends StatelessWidget {
  const _PasswordHint();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(Icons.info_outline, size: 18, color: colors.warning),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              'Don\'t enter your email account\'s password. Create a new '
              'password just for Campus Assistant, and remember it to log in '
              'next time.',
              style: TextStyle(color: colors.text, fontSize: FontSizeToken.sm),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldNote extends StatelessWidget {
  const _FieldNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: context.colors.textMuted,
      fontSize: FontSizeToken.xs,
    ),
  );
}
