import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/features/student_verification/data/student_verification_request.dart';
import '/routes/app_route.dart';
import '../providers/student_verification_provider.dart';

/// Shows where the user's student verification stands. Push notifications
/// for approve/reject land here.
class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myStudentVerificationProvider);

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
          title: Text(
            'Student verification',
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
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(myStudentVerificationProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(Spacing.lg),
              children: [
                async.when(
                  data: (request) => _StatusBody(request: request),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Column(
                      children: [
                        Text(serverErrorMessage(e) ?? 'Could not load status.'),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(myStudentVerificationProvider),
                          child: const Text('Retry'),
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
    );
  }
}

class _StatusBody extends ConsumerWidget {
  const _StatusBody({required this.request});

  final StudentVerificationRequest? request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final r = request;

    final (
      IconData icon,
      Color fg,
      Color bg,
      String title,
      String body,
    ) = switch (r) {
      null => (
        Icons.badge_outlined,
        colors.info,
        colors.infoSubtle,
        'Not verified yet',
        'Submit your student ID card and registration card or certificate. '
            'An admin will review them and link your account to your batch.',
      ),
      _ when r.isPending => (
        Icons.hourglass_top_rounded,
        colors.warning,
        colors.warningSubtle,
        'Under review',
        'We received your documents. You will get a notification once an '
            'admin has reviewed them.',
      ),
      _ when r.isApproved => (
        Icons.verified_rounded,
        colors.success,
        colors.successSubtle,
        'You are verified',
        'Your account is now linked to your batch.',
      ),
      _ => (
        Icons.error_outline_rounded,
        colors.danger,
        colors.dangerSubtle,
        'Not approved',
        r.rejectionReason?.isNotEmpty == true
            ? 'Reason: ${r.rejectionReason}'
            : 'Your request was not approved. Please check your documents '
                  'and submit again.',
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: Spacing.xxl),
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: bg,
            child: Icon(icon, size: 40, color: fg),
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textMuted, height: 1.4),
        ),
        if (r != null) ...[
          const SizedBox(height: Spacing.xxl),
          Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(RadiusToken.lg),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                _row(context, 'Name', r.name),
                _row(context, 'Roll', r.studentId),
                _row(context, 'University', r.universityName),
                _row(context, 'Department', r.departmentName),
                _row(context, 'Batch', r.batchName),
                _row(context, 'Session', r.sessionName),
              ],
            ),
          ),
        ],
        const SizedBox(height: Spacing.xxl),
        if (r == null || r.isRejected)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, ControlToken.height),
            ),
            onPressed: () => context.pushNamed(
              AppRoute.studentVerificationRequest.name,
              extra: r,
            ),
            child: Text(r == null ? 'Start verification' : 'Submit again'),
          ),
        if (r != null && r.isApproved)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, ControlToken.height),
            ),
            onPressed: () {
              ref.invalidate(currentUserProvider);
              ref.invalidate(studentByUserIdProvider);
              ref.invalidate(studentProfileProvider);
              context.goNamed(AppRoute.home.name);
            },
            child: const Text('Go to home'),
          ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String? value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: context.colors.textMuted)),
        const SizedBox(width: Spacing.lg),
        Flexible(
          child: Text(
            value?.isNotEmpty == true ? value! : '—',
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
