import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
