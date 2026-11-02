import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/profile/presentation/widgets/profile_completion_card.dart';

/// Home nudge for verified users whose profile still has gaps. Signup only
/// asks for name, email and password, so this is where mobile, blood group,
/// hall and photo get filled in. Hidden once the profile is complete, and for
/// unverified users (they see [StudentVerificationBanner] instead).
class CompleteProfileNudge extends ConsumerWidget {
  const CompleteProfileNudge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null ||
        !user.isVerified ||
        missingProfileFields(user).isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
      child: ProfileCompletionCard(user: user),
    );
  }
}
