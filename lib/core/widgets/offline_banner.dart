import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cache/connectivity_service.dart';

/// A banner that appears at the top of the screen when the device is offline.
/// Automatically hides when connection is restored.
class OfflineBanner extends ConsumerWidget {
  final Widget child;

  const OfflineBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);

    return StreamBuilder<bool>(
      stream: connectivity.onConnectivityChanged,
      initialData: connectivity.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isConnected ? 0 : 40,
              child: isConnected
                  ? const SizedBox.shrink()
                  : Container(
                      width: double.infinity,
                      color: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'You\'re offline. Showing cached data.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

/// Simpler version: just a conditional banner widget.
class OfflineBannerSimple extends ConsumerWidget {
  const OfflineBannerSimple({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);

    return StreamBuilder<bool>(
      stream: connectivity.onConnectivityChanged,
      initialData: connectivity.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;

        if (isConnected) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          color: Colors.orange.shade700,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'You\'re offline. Showing cached data.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
