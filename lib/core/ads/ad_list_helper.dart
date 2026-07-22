import 'package:flutter/widgets.dart';

import 'banner_ad_widget.dart';

/// itemCount/itemBuilder pair produced by [withPeriodicAds], ready to hand
/// straight to a ListView.builder/ListView.separated.
class AdInjectedList {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const AdInjectedList({required this.itemCount, required this.itemBuilder});
}

/// Wraps a list's itemCount/itemBuilder to inject a [BannerAdWidget] every
/// [interval] real items (e.g. interval=6 -> an ad slot after real items
/// 6, 12, 18, ...). Ad slots don't count toward the spacing themselves, and
/// short lists (realCount <= interval) get no ads at all rather than one
/// squeezed in awkwardly.
AdInjectedList withPeriodicAds({
  required int realCount,
  required Widget Function(BuildContext context, int realIndex) realItemBuilder,
  int interval = 6,
}) {
  if (realCount == 0) {
    return AdInjectedList(
      itemCount: 0,
      itemBuilder: (_, _) => const SizedBox.shrink(),
    );
  }

  final adCount = realCount ~/ interval;
  final slotSize = interval + 1;

  return AdInjectedList(
    itemCount: realCount + adCount,
    itemBuilder: (context, index) {
      final isAdSlot = (index + 1) % slotSize == 0;
      if (isAdSlot) return const BannerAdWidget();

      final adsBefore = (index + 1) ~/ slotSize;
      return realItemBuilder(context, index - adsBefore);
    },
  );
}
