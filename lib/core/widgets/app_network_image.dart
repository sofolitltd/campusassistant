import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '/core/theme/app_colors.dart';

/// The one way to show a remote image. Use it instead of `Image.network`,
/// `NetworkImage` or a bare `CachedNetworkImage`.
///
/// It does two things those don't:
/// - **Disk cache** via `cached_network_image`, so an image is downloaded once,
///   not on every rebuild or app start.
/// - **Decodes at display size.** A 4000×3000 upload shown in a 120 dp tile
///   would otherwise be decoded at full size (~48 MB of RAM). The decode size
///   comes from [width]/[height], or from the layout constraints when they're
///   omitted, times the device pixel ratio.
///
/// Same shape as `Image.network`: positional URL, then [width], [height],
/// [fit], [errorBuilder]. The URL is used as-is; resolve relative paths with
/// `ApiEndpoints.resolveImageUrl` first, as before.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.placeholder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Shown until the first frame decodes. Defaults to a `surfaceAlt` box.
  final WidgetBuilder? placeholder;

  /// A cached, size-capped [ImageProvider], for APIs that take a provider
  /// rather than a widget (`CircleAvatar.backgroundImage`, `DecorationImage`).
  /// [maxSize] is in physical pixels; 256 covers a 40 dp-radius avatar at 3x.
  static ImageProvider provider(String url, {int maxSize = 256}) =>
      _CoverResizeImage(
        CachedNetworkImageProvider(url),
        width: maxSize,
        height: maxSize,
      );

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback(context, 'empty url', null);

    // Both sides known: no need to measure.
    if (width != null && height != null) {
      return _image(context, width, height);
    }
    return LayoutBuilder(
      builder: (context, constraints) => _image(
        context,
        width ?? (constraints.hasBoundedWidth ? constraints.maxWidth : null),
        height ?? (constraints.hasBoundedHeight ? constraints.maxHeight : null),
      ),
    );
  }

  Widget _image(BuildContext context, double? boxWidth, double? boxHeight) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    ImageProvider image = CachedNetworkImageProvider(url);
    final targetWidth = _bucket(boxWidth, dpr);
    final targetHeight = _bucket(boxHeight, dpr);
    if (targetWidth != null || targetHeight != null) {
      image = _CoverResizeImage(
        image,
        width: targetWidth,
        height: targetHeight,
      );
    }

    return Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return placeholder?.call(context) ?? _box(context);
      },
      errorBuilder: errorBuilder ?? (context, _, _) => _box(context),
    );
  }

  Widget _fallback(BuildContext context, Object error, StackTrace? stack) =>
      errorBuilder?.call(context, error, stack) ?? _box(context);

  Widget _box(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: ColoredBox(color: context.colors.surfaceAlt),
  );

  /// Rounds the physical size up to a multiple of 64 px, so small layout
  /// differences (a 179.5 vs 180 dp tile) share one decoded image in the
  /// ImageCache instead of decoding the same file twice.
  static int? _bucket(double? logical, double dpr) {
    if (logical == null || !logical.isFinite || logical <= 0) return null;
    return ((logical * dpr) / 64).ceil() * 64;
  }
}

/// Like Flutter's `ResizeImage`, but sized from the image's real dimensions:
/// scales the decode so the image still *covers* the target box, keeping its
/// aspect ratio and never upscaling. `ResizeImage` can only fix one side ahead
/// of time, which leaves a landscape photo in a square `BoxFit.cover` tile
/// decoded too small and blurry.
class _CoverResizeImage extends ImageProvider<_CoverResizeKey> {
  const _CoverResizeImage(this.provider, {this.width, this.height});

  final ImageProvider provider;
  final int? width;
  final int? height;

  @override
  Future<_CoverResizeKey> obtainKey(ImageConfiguration configuration) {
    // CachedNetworkImageProvider returns a SynchronousFuture, and `then` on
    // one stays synchronous, so cache hits still paint on the first frame.
    return provider
        .obtainKey(configuration)
        .then((key) => _CoverResizeKey(key, width, height));
  }

  @override
  ImageStreamCompleter loadImage(
    _CoverResizeKey key,
    ImageDecoderCallback decode,
  ) {
    Future<ui.Codec> decodeResized(
      ui.ImmutableBuffer buffer, {
      ui.TargetImageSizeCallback? getTargetSize,
    }) {
      return decode(
        buffer,
        getTargetSize: (intrinsicWidth, intrinsicHeight) {
          var scale = 0.0;
          if (width != null) scale = math.max(scale, width! / intrinsicWidth);
          if (height != null) {
            scale = math.max(scale, height! / intrinsicHeight);
          }
          if (scale <= 0 || scale >= 1) return const ui.TargetImageSize();
          return ui.TargetImageSize(
            width: (intrinsicWidth * scale).ceil(),
            height: (intrinsicHeight * scale).ceil(),
          );
        },
      );
    }

    // Same delegation ResizeImage does internally.
    // ignore: invalid_use_of_protected_member
    return provider.loadImage(key.providerKey, decodeResized);
  }
}

@immutable
class _CoverResizeKey {
  const _CoverResizeKey(this.providerKey, this.width, this.height);

  final Object providerKey;
  final int? width;
  final int? height;

  @override
  bool operator ==(Object other) =>
      other is _CoverResizeKey &&
      other.providerKey == providerKey &&
      other.width == width &&
      other.height == height;

  @override
  int get hashCode => Object.hash(providerKey, width, height);
}
