import 'app_route.dart';

/// Everything the router's redirect needs to decide, read from providers by
/// `routerProvider` so [resolveRedirect] stays a pure function (and testable).
class RouteGuardState {
  final bool isLoggedIn;

  /// Auth still loading, refreshing, or failed (e.g. offline at startup):
  /// hold the user where they are rather than bouncing them to login.
  final bool isAuthResolving;
  final bool isOnboardingResolving;
  final bool hasSeenOnboarding;

  /// Null while the app config is loading or failed to load: force update
  /// fails open so a backend hiccup never locks out the whole user base.
  final int? minSupportedVersionCode;
  final int? installedVersionCode;

  const RouteGuardState({
    required this.isLoggedIn,
    required this.isAuthResolving,
    required this.isOnboardingResolving,
    required this.hasSeenOnboarding,
    this.minSupportedVersionCode,
    this.installedVersionCode,
  });
}

/// Where to send the user instead of [matchedLocation], or null to stay.
String? resolveRedirect(RouteGuardState s, String matchedLocation) {
  // ── Force update: overrides every other gate, including auth/onboarding.
  // Fails open while the config is still loading or failed to load (the
  // provider itself swallows errors to `null`), so a backend hiccup never
  // locks out the whole user base.
  final minVersion = s.minSupportedVersionCode;
  final installed = s.installedVersionCode;
  final bool requiresForceUpdate =
      minVersion != null && installed != null && installed < minVersion;
  if (requiresForceUpdate) {
    return matchedLocation == AppRoute.forceUpdate.path
        ? null
        : AppRoute.forceUpdate.path;
  }
  if (matchedLocation == AppRoute.forceUpdate.path) {
    return '/splash'; // no longer required — re-run the normal flow
  }

  // ── Splash screen: wait for auth + onboarding resolution ──
  if (matchedLocation == '/splash') {
    if (s.isAuthResolving || s.isOnboardingResolving) {
      return null; // stay on splash while checking state or on network error
    }
    if (!s.hasSeenOnboarding) return AppRoute.onboarding.path;
    if (!s.isLoggedIn) return AppRoute.login.path;
    return AppRoute.home.path; // logged in → go to home
  }

  // ── During auth/onboarding loading on any other route, just wait ──
  if (s.isAuthResolving || s.isOnboardingResolving) return null;

  // ── First launch: force onboarding before anything else ──
  if (!s.hasSeenOnboarding) {
    return matchedLocation == AppRoute.onboarding.path
        ? null
        : AppRoute.onboarding.path;
  }
  if (matchedLocation == AppRoute.onboarding.path) {
    // Onboarding already seen — don't allow navigating back to it.
    return s.isLoggedIn ? AppRoute.home.path : AppRoute.login.path;
  }

  final isGuestRoute =
      matchedLocation == AppRoute.login.path ||
      matchedLocation == AppRoute.forgotPassword.path ||
      matchedLocation == AppRoute.resetPassword.path ||
      matchedLocation == AppRoute.newPassword.path ||
      matchedLocation == AppRoute.verification.path ||
      matchedLocation.startsWith('/register') ||
      matchedLocation.startsWith('/create-account') ||
      matchedLocation.startsWith('/teacher-signup') ||
      matchedLocation.startsWith('/staff-signup') ||
      matchedLocation == AppRoute.studentVerificationPlacement.path ||
      matchedLocation == AppRoute.documentSignup.path;

  // Help pages reachable from login, and fine to view signed in too.
  final isPublicRoute =
      matchedLocation == AppRoute.getVerificationCode.path ||
      matchedLocation == AppRoute.contactWithCR.path;
  if (isPublicRoute) return null;

  if (!s.isLoggedIn) {
    if (!isGuestRoute) {
      return AppRoute.login.path;
    }
    return null; // Stay on guest routes
  }

  // Just signed up without a code — continue to document verification.
  if (matchedLocation == AppRoute.documentSignup.path) {
    return AppRoute.studentVerificationRequest.path;
  }

  // Logged in — redirect away from guest routes
  if (s.isLoggedIn && isGuestRoute) {
    return AppRoute.home.path;
  }

  return null;
}
