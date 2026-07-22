import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/routes/app_route.dart';
import '/core/providers/is_pro_provider.dart';
import 'rewarded_ad_manager.dart';

/// Shows a "watch an ad to download" prompt before a resource's first
/// download for Basic users. Returns true if the download should proceed.
///
/// Lenient by design: once the user opts in by tapping "Watch Ad," a failed
/// load, an early close, or any other ad hiccup never blocks the download
/// itself — only explicitly declining the prompt does. This avoids trapping
/// a student behind a study resource because of a flaky ad network, which
/// would violate the "never break the app experience" principle this
/// feature was built under. Re-downloading after deleting a file from local
/// cache goes through this same gate again, since it's keyed on the file's
/// current on-disk state, not a one-time-ever flag.
///
/// Pro users and web always return true immediately (Pro: no ads anywhere;
/// web: google_mobile_ads has no web implementation at all).
Future<bool> showDownloadAdGate(BuildContext context, WidgetRef ref) async {
  if (kIsWeb || ref.read(isProUserProvider)) return true;

  final manager = ref.read(rewardedAdManagerProvider);
  manager.preload(); // start warming up an ad while the user decides

  if (!context.mounted) return true;
  final wantsToWatch = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Unlock this download',
            style: Theme.of(dialogContext).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
        ],
      ),
      content: const Text(
        'Watch a short ad to download this file, or upgrade to Pro for '
        'unlimited ad-free downloads.',
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                  GoRouter.of(
                    dialogContext,
                  ).pushNamed(AppRoute.subscription.name);
                },
                child: const Text('Go Pro'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Watch Ad'),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (wantsToWatch != true) return false;

  await manager.show();
  return true;
}
