import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cache/connectivity_service.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// A banner that appears at the top of the screen when the device is offline.
/// Automatically hides when connection is restored.
class OfflineBanner extends ConsumerWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedProvider);

    if (isConnected) return child;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: context.colors.warning,
            child: SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: context.colors.onWarning,
                    size: 14,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'You\'re offline.',
                    style: TextStyle(
                      color: context.colors.onWarning,
                      fontSize: FontSizeToken.sm,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
