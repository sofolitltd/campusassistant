import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/widgets/common_text_field_widget.dart';
import '/routes/app_route.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key});

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoute.login.name),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.width * .3
                      : 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
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
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.xl,
                          horizontal: Spacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Have a verification code?',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontWeight: .w600),
                            ),
                            Text(
                              'Enter your 6-digit verification code to create a new account.',
                              style: TextStyle(
                                color: context.colors.textSubtle,
                              ),
                            ),
                            const SizedBox(height: Spacing.sm),
                            const Divider(height: .5),
                            const SizedBox(height: Spacing.lg),
                            CommonTextFieldWidget(
                              controller: _verificationCodeController,
                              heading: 'Verification Code',
                              hintText: 'Enter 6-digit code',
                              keyboardType: .number,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter your verification code';
                                }
                                if (val.length != 6) {
                                  return 'Verification code must be 6 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: Spacing.xxl),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(
                                  double.infinity,
                                  ControlToken.height,
                                ),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_globalKey.currentState!.validate()) {
                                        setState(() => _isLoading = true);

                                        final studentRepo = ref.read(
                                          studentRepositoryProvider,
                                        );
                                        final code = _verificationCodeController
                                            .text
                                            .trim();

                                        try {
                                          await studentRepo.verifyCode(code);

                                          if (!context.mounted) return;
                                          setState(() => _isLoading = false);

                                          if (!context.mounted) return;
                                          context.pushNamed(
                                            AppRoute.registration.name,
                                            pathParameters: {'studentId': code},
                                          );
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          setState(() => _isLoading = false);
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      }
                                    },
                              child: _isLoading
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CupertinoActivityIndicator(
                                        color: context.colors.onPrimary,
                                      ),
                                    )
                                  : Text(
                                      'Verify now',
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
                    const SizedBox(height: Spacing.xxxl),
                    Container(
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
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.lg,
                          horizontal: Spacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: .stretch,
                          children: [
                            Text(
                              'Don\'t have a verification code?',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    fontWeight: .w600,
                                    color: context.colors.textSubtle,
                                  ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            OutlinedButton(
                              onPressed: () {
                                context.push(AppRoute.getVerificationCode.path);
                              },
                              child: Text(
                                'Get your verification code!',
                                style: const TextStyle(
                                  letterSpacing: .2,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xxl),
                    Center(
                      child: TextButton(
                        onPressed: () => context.goNamed(AppRoute.login.name),
                        child: Text(
                          'Cancel and login',
                          style: TextStyle(
                            color: context.colors.textMuted,
                            letterSpacing: 1,
                            fontWeight: .bold,
                          ),
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
    );
  }
}
