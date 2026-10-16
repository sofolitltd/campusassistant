import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '/widgets/otp_code_field_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/widgets/header_gradient_backdrop.dart';

/// Step 2 of the forgot-password flow: the user has been emailed a 6-digit
/// code and enters it here.
///
/// The code is verified on its own (before any password is typed) and traded
/// for a single-use reset token, which is handed to [NewPasswordPage] in
/// memory only. If the flow is left, the user starts over.
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  bool _isResending = false;

  // Resend cooldown. The backend also throttles (3 requests per 15 minutes),
  // so this is about setting expectations, not about enforcement.
  static const int _resendCooldownSeconds = 60;
  int _secondsRemaining = _resendCooldownSeconds;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    // Verify as soon as the sixth digit lands (typed, pasted or autofilled).
    _codeController.addListener(() {
      if (_codeController.text.length == 6 && !_isLoading) _submit();
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _secondsRemaining = _resendCooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ref
        .read(authRepositoryProvider)
        .verifyResetCode(widget.email, _codeController.text.trim());
    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        _codeController.clear();
      },
      (token) => context.pushNamed(
        AppRoute.newPassword.name,
        extra: {'email': widget.email, 'resetToken': token},
      ),
    );
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.forgotPassword(widget.email);
    if (!mounted) return;

    setState(() => _isResending = false);

    result.fold((failure) => Fluttertoast.showToast(msg: failure.message), (_) {
      Fluttertoast.showToast(
        msg: 'A new code has been sent. Earlier codes no longer work.',
      );
      _codeController.clear();
      _startCooldown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsRemaining == 0 && !_isResending && !_isLoading;

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
          title: Text(
            'Verify Code',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.colors.onPrimary,
            ),
          ),
          centerTitle: true,
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
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.width * .3
                      : 16,
                  vertical: Spacing.xl,
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 350,
                    maxWidth: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(RadiusToken.xl),
                    border: Border.all(color: context.colors.border),
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
                          'Enter the code',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: .bold),
                        ),
                        Text(
                          'We sent a 6-digit code to ${widget.email}. '
                          'It expires in 10 minutes.',
                          style: TextStyle(color: context.colors.textSubtle),
                        ),
                        const SizedBox(height: Spacing.sm),
                        const Divider(height: .5),
                        const SizedBox(height: Spacing.xxl),

                        OtpCodeFieldWidget(
                          controller: _codeController,
                          heading: 'Verification Code',
                          validator: (val) {
                            final code = val?.trim() ?? '';
                            if (code.isEmpty) return 'Enter the code';
                            if (code.length != 6) {
                              return 'Enter all 6 digits';
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
                                  'Verify Code',
                                  style: const TextStyle(fontWeight: .bold),
                                ),
                        ),
                        const SizedBox(height: Spacing.sm),

                        TextButton(
                          onPressed: canResend ? _resendCode : null,
                          child: _isResending
                              ? const CupertinoActivityIndicator()
                              : Text(
                                  _secondsRemaining > 0
                                      ? 'Resend code in ${_secondsRemaining}s'
                                      : 'Resend code',
                                ),
                        ),
                        const SizedBox(height: Spacing.lg),

                        Text(
                          '* If you don\'t see the email in your inbox, check your spam folder.',
                          style: TextStyle(
                            fontSize: FontSizeToken.sm,
                            color: context.colors.textSubtle,
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
