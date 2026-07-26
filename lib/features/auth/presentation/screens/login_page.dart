import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/routes/app_route.dart';
import '/widgets/app_logo.dart';
import '/widgets/common_text_field_widget.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  var regExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _handleLogin() async {
    if (_globalKey.currentState!.validate()) {
      // Unfocus keyboard
      FocusScope.of(context).unfocus();

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref.read(currentUserProvider.notifier).login(email, password);
      // Navigation on success is handled by the router redirect
      // (see router_config.dart); errors are surfaced below via authState.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;

    // Listen to authentication state changes
    ref.listen(currentUserProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            Fluttertoast.showToast(msg: 'Welcome back, ${user.firstName}!');
          }
        },
        error: (error, stackTrace) {
          log('Login error: $error');
          Fluttertoast.showToast(msg: 'Login failed: ${error.toString()}');
        },
      );
    });

    final authState = ref.watch(currentUserProvider);
    final isLoading = authState.isLoading;
    final loginError = authState.hasError
        ? _friendlyLoginError(authState.error)
        : null;

    return Scaffold(
      body: Stack(
        children: [
          // ── Decorative background depth ──
          Positioned(
            top: -90,
            right: -70,
            child: _Blob(color: colors.primaryColor.withValues(alpha: 0.14)),
          ),
          Positioned(
            bottom: -110,
            left: -90,
            child: _Blob(
              color: colors.primaryColor.withValues(alpha: 0.10),
              size: 260,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.xxl,
                ),
                child: Form(
                  key: _globalKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child:
                        Container(
                              padding: const EdgeInsets.all(Spacing.xxl),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.xxl,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.shadow.withValues(
                                      alpha: 0.06,
                                    ),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ── Brand mark ──
                                  Center(
                                        child: SizedBox(
                                          height: 32,
                                          child: const Center(child: AppLogo()),
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 300.ms)
                                      .scale(begin: const Offset(0.85, 0.85)),

                                  const SizedBox(height: Spacing.lg),

                                  Text(
                                        'Login to your account',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withValues(alpha: 0.8),
                                            ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 100.ms, duration: 300.ms)
                                      .slideY(begin: 0.12, end: 0),

                                  const SizedBox(height: Spacing.xl),

                                  AbsorbPointer(
                                    absorbing: isLoading,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CommonTextFieldWidget(
                                          controller: _emailController,
                                          focusNode: _emailFocusNode,
                                          heading: 'Email',
                                          hintText: 'Enter email',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autofillHints: const [
                                            AutofillHints.username,
                                          ],
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return 'Enter your email';
                                            } else if (!regExp.hasMatch(val)) {
                                              return 'Enter valid email';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(
                                              context,
                                            ).requestFocus(_passwordFocusNode);
                                          },
                                        ),

                                        const SizedBox(height: Spacing.lg),

                                        CommonTextFieldWidget(
                                          heading: 'Password',
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          hintText: 'Enter password',
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          autofillHints: const [
                                            AutofillHints.password,
                                          ],
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return 'Enter your password';
                                            } else if (val.length < 6) {
                                              return 'Password too short';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (_) =>
                                              _handleLogin(),
                                        ),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              context.pushNamed(
                                                AppRoute.forgotPassword.name,
                                              );
                                            },
                                            child: Text(
                                              'Forgot password?',
                                              style: TextStyle(
                                                color: colors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (loginError != null) ...[
                                    const SizedBox(height: Spacing.sm),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.md,
                                        vertical: Spacing.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.destructiveColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          RadiusToken.md,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 18,
                                            color: colors.destructiveColor,
                                          ),
                                          const SizedBox(width: Spacing.sm),
                                          Expanded(
                                            child: Text(
                                              loginError,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color:
                                                        colors.destructiveColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: Spacing.xl),

                                  ElevatedButton(
                                    onPressed: isLoading ? null : _handleLogin,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CupertinoActivityIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('Login'),
                                  ),

                                  const SizedBox(height: Spacing.xxl),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color:
                                              theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Spacing.md,
                                        ),
                                        child: Text(
                                          'New here?',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color:
                                              theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: Spacing.lg),

                                  OutlinedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            context.pushNamed(
                                              AppRoute.verification.name,
                                            );
                                          },
                                    icon: const Icon(
                                      Icons.person_add_alt_1_rounded,
                                    ),
                                    label: const Text('Create New Account'),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 350.ms)
                            .slideY(begin: 0.05, end: 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _friendlyLoginError(Object? error) {
    final message = error.toString();
    if (message.contains('NetworkFailure') ||
        message.toLowerCase().contains('network')) {
      return "Can't reach the server. Check your connection and try again.";
    }
    return 'Incorrect email or password. Please try again.';
  }
}

/// Soft, out-of-flow color wash used behind the login card for visual depth.
class _Blob extends StatelessWidget {
  const _Blob({required this.color, this.size = 220});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
