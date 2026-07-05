import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusassistant/features/student/presentation/providers/student_provider.dart';
import 'package:campusassistant/widgets/common_text_field_widget.dart';
import 'package:campusassistant/routes/app_route.dart';
import 'package:go_router/go_router.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';
import 'package:campusassistant/core/theme/tokens/app_spacing.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.xl),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white10
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Have a verification code?'.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Text(
                              'Enter your 6-digit verification code to create a new account.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: .5),
                            const SizedBox(height: Spacing.lg),
                            CommonTextFieldWidget(
                              controller: _verificationCodeController,
                              heading: 'Verification Code',
                              hintText: 'Enter 6-digit code',
                              keyboardType: TextInputType.number,
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
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
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
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Verify now'.toUpperCase(),
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
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.xl),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white10
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Don\'t have a verification code?'.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            OutlinedButton(
                              onPressed: () {
                                context.push(AppRoute.getVerificationCode.path);
                              },
                              child: Text(
                                'get your verification code!'.toUpperCase(),
                                style: const TextStyle(
                                  letterSpacing: .2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => context.goNamed(AppRoute.login.name),
                        child: Text(
                          'Cancel and Login'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
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
