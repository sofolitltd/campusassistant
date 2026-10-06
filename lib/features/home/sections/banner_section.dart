import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/error/failures.dart';
import '/features/banner/presentation/providers/banner_provider.dart';
import '/widgets/image_carousal.dart';
import '../widgets/home_section.dart';

class BannerSection extends ConsumerWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(bannersListProvider)
        .when(
          loading: () => const HomeSectionLoading(height: 160),
          error: (e, _) => HomeSectionError(
            offline: e is NetworkFailure,
            message: e is NetworkFailure
                ? 'No internet connection'
                : 'Unable to load banners',
            onRetry: () => ref.invalidate(bannersListProvider),
          ),
          data: (banners) => banners.isEmpty
              ? const SizedBox.shrink()
              : HomeSection(child: ImageCarousel(images: banners)),
        );
  }
}
