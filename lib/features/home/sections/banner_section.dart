import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/failures.dart';
import '../../banner/presentation/providers/banner_provider.dart';
import '/widgets/image_carousal.dart';

class BannerSection extends ConsumerWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersListProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ImageCarousel(images: banners),
        );
      },
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, _) {
        final isNetworkError = e is NetworkFailure;
        return Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isNetworkError ? Icons.cloud_off : Icons.error_outline,
                  color: Colors.grey.shade400,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  isNetworkError
                      ? 'No internet connection'
                      : 'Unable to load banners',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isNetworkError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Cached banners not available',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
