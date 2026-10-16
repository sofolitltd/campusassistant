import 'package:campusassistant/routes/app_route.dart';
import 'package:campusassistant/routes/route_guard.dart';
import 'package:flutter_test/flutter_test.dart';

RouteGuardState guard({
  bool isLoggedIn = true,
  bool isAuthResolving = false,
  bool isOnboardingResolving = false,
  bool hasSeenOnboarding = true,
  int? minSupportedVersionCode,
  int? installedVersionCode,
}) => RouteGuardState(
  isLoggedIn: isLoggedIn,
  isAuthResolving: isAuthResolving,
  isOnboardingResolving: isOnboardingResolving,
  hasSeenOnboarding: hasSeenOnboarding,
  minSupportedVersionCode: minSupportedVersionCode,
  installedVersionCode: installedVersionCode,
);

void main() {
  final login = AppRoute.login.path;
  final home = AppRoute.home.path;
  final onboarding = AppRoute.onboarding.path;
  final forceUpdate = AppRoute.forceUpdate.path;

  group('force update', () {
    test('outdated build is sent to force update from anywhere', () {
      final s = guard(minSupportedVersionCode: 20, installedVersionCode: 19);
      expect(resolveRedirect(s, home), forceUpdate);
      expect(resolveRedirect(s, '/splash'), forceUpdate);
      expect(resolveRedirect(s, forceUpdate), isNull);
    });

    test('fails open when config or version is unknown', () {
      expect(resolveRedirect(guard(installedVersionCode: 1), home), isNull);
      expect(resolveRedirect(guard(minSupportedVersionCode: 99), home), isNull);
    });

    test('leaves force update once no longer required', () {
      final s = guard(minSupportedVersionCode: 20, installedVersionCode: 20);
      expect(resolveRedirect(s, forceUpdate), '/splash');
    });
  });

  group('splash', () {
    test('waits while auth or onboarding resolve', () {
      expect(resolveRedirect(guard(isAuthResolving: true), '/splash'), isNull);
      expect(
        resolveRedirect(guard(isOnboardingResolving: true), '/splash'),
        isNull,
      );
    });

    test('routes to onboarding, login or home', () {
      expect(
        resolveRedirect(guard(hasSeenOnboarding: false), '/splash'),
        onboarding,
      );
      expect(resolveRedirect(guard(isLoggedIn: false), '/splash'), login);
      expect(resolveRedirect(guard(), '/splash'), home);
    });
  });

  test('does not redirect while auth is resolving elsewhere', () {
    expect(resolveRedirect(guard(isAuthResolving: true), '/profile'), isNull);
  });

  test('first launch forces onboarding', () {
    final s = guard(hasSeenOnboarding: false, isLoggedIn: false);
    expect(resolveRedirect(s, login), onboarding);
    expect(resolveRedirect(s, onboarding), isNull);
  });

  test('onboarding is not reachable once seen', () {
    expect(resolveRedirect(guard(), onboarding), home);
    expect(resolveRedirect(guard(isLoggedIn: false), onboarding), login);
  });

  test('signed-out user is sent to login, except on guest routes', () {
    final s = guard(isLoggedIn: false);
    expect(resolveRedirect(s, '/profile'), login);
    expect(resolveRedirect(s, login), isNull);
    expect(resolveRedirect(s, AppRoute.forgotPassword.path), isNull);
  });

  test('signed-in user is sent home from guest routes', () {
    expect(resolveRedirect(guard(), login), home);
    expect(resolveRedirect(guard(), '/profile'), isNull);
  });

  test('public help routes are open either way', () {
    final path = AppRoute.getVerificationCode.path;
    expect(resolveRedirect(guard(), path), isNull);
    expect(resolveRedirect(guard(isLoggedIn: false), path), isNull);
  });

  test('document signup continues to the verification request', () {
    expect(
      resolveRedirect(guard(), AppRoute.documentSignup.path),
      AppRoute.studentVerificationRequest.path,
    );
  });
}
