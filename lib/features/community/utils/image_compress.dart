import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Compresses a picked image to JPEG, capping the longest side at 1080px and
/// stepping quality down until the result fits within [maxBytesPerImage].
///
/// Returns the original file's bytes if compression fails, so the caller can
/// still enforce the overall size budget.
Future<Uint8List> compressCommunityImage(
  File file, {
  int maxBytesPerImage = 256 * 1024,
}) async {
  final bytes = await file.readAsBytes();
  if (bytes.lengthInBytes <= maxBytesPerImage) return bytes;

  for (final quality in const [60, 45, 35, 25]) {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1080,
      minHeight: 1080,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    if (result.length <= maxBytesPerImage) return result;
  }

  // Last attempt at lowest quality; caller enforces the total budget.
  return FlutterImageCompress.compressWithList(
    bytes,
    minWidth: 1080,
    minHeight: 1080,
    quality: 20,
    format: CompressFormat.jpeg,
  );
}

int totalImageBytes(List<Uint8List> images) =>
    images.fold(0, (sum, e) => sum + e.lengthInBytes);
