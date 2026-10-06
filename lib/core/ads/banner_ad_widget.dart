import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '/core/providers/is_pro_provider.dart';
import 'ad_config.dart';

/// A banner ad that never requests an ad for Pro users or on web (checked
/// once at mount, not just visually hidden), and reserves the banner's
/// height while loading so surrounding content doesn't jump once it loads.
/// Fails silently — a broken/failed load just leaves an empty gap, never a
/// visibly broken ad box.
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key, this.margin});

  /// Space around the ad, applied only while an ad slot is actually shown
  /// (so a hidden ad for Pro users leaves no gap).
  final EdgeInsetsGeometry? margin;

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && !ref.read(isProUserProvider)) {
      _loadAd();
    }
  }

  void _loadAd() {
    BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reactive hide: if the user upgrades to Pro mid-session, stop showing
    // an already-loaded ad immediately, even though the one request that
    // loaded it already happened before they upgraded.
    if (kIsWeb || ref.watch(isProUserProvider)) {
      return const SizedBox.shrink();
    }

    // Occupy no space until an ad has actually loaded: while loading, on a
    // failed/no-fill request, and for Pro users the slot is collapsed, so
    // there is no blank 50px gap. AnimatedSize eases the page down when an ad
    // arrives instead of jumping.
    final loaded = _isLoaded && _bannerAd != null;
    final slot = loaded
        ? SizedBox(
            width: AdSize.banner.width.toDouble(),
            height: AdSize.banner.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox(width: double.infinity);
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: loaded && widget.margin != null
          ? Padding(padding: widget.margin!, child: slot)
          : slot,
    );
  }
}
