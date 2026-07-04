import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../banner/presentation/providers/banner_provider.dart';
import '/widgets/image_carousal.dart';
import '/core/theme/tokens/app_radius.dart';

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
      loading: () => const Skeletonizer(
        enabled: true,
        child: _BannerSkeleton(),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        child: const SizedBox(
          width: double.infinity,
          height: 160,
        ),
      ),
    );
  }
}
