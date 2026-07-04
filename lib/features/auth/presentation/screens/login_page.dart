import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/routes/app_route.dart';
import '/widgets/app_logo.dart';
import '/widgets/common_text_field_widget.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
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
  final TextEditingController _emailController = TextEditingController(text: "asifreyad1@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "12345678");

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

      // Listener will handle navigation if successful, or error toast if failed
      // See ref.listen in build or just await result if login returned Future<void> (it does)
      // Since login updates state, we can look at state or handle exception if login threw
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to authentication state changes
    ref.listen(currentUserProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            // Login success - Navigation should be handled by GoRouter redirect or manual push
            // For now, manual push if no router redirect is set up
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              // Navigate to Home or whatever initial route
              // context.goNamed(AppRoute.home.name);
              // Assuming AppRoute.home exists, otherwise '/'
              context.go('/');
            }
            Fluttertoast.showToast(msg: 'Welcome back, ${user.firstName}!');
          }
        },
        error: (error, stackTrace) {
          log('Login error: $error');
          Fluttertoast.showToast(msg: 'Login failed: ${error.toString()}');
        },
        loading: () {},
      );
    });

    final authState = ref.watch(currentUserProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.width * .3
                      : 16,
                  vertical: 16,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 350,
                      maxWidth: 400,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // logo
                        const AppLogo(),

                        const SizedBox(height: 24),

                        // login
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome back'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                ),
                                const SizedBox(height: 2),

                                Text(
                                  'login with email and password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey,
                                      ),
                                ),

                                const SizedBox(height: 24),

                                CommonTextFieldWidget(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  heading: 'Email',
                                  hintText: 'Enter email',
                                  keyboardType: TextInputType.emailAddress,
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
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter your password';
                                    } else if (val.length < 6) {
                                      // Adjusted length to 6 as generic rule
                                      return 'Password too short';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _handleLogin(),
                                ),

                                const SizedBox(height: 24),

                                //log in
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handleLogin,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 32,
                                            width: 32,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Login'.toUpperCase(),
                                            style: const TextStyle(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                //forgot pass
                                TextButton(
                                  onPressed: () {
                                    context.pushNamed(
                                      AppRoute.forgotPassword.name,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      ' Forgot Password ?',
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // sign up
                        Card(
                          elevation: 6,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Don\'t have an account?'.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                ),
                                const SizedBox(height: Spacing.lg),

                                //
                                OutlinedButton(
                                  onPressed: () {
                                    context.pushNamed(
                                      AppRoute.verification.name,
                                    );
                                  },
                                  child: Text(
                                    'Create new account'.toUpperCase(),
                                    style: const TextStyle(
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
