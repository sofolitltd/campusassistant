import 'dart:typed_data';

import 'package:gal/gal.dart';

/// Saves into a "Campus Assistant" album. Throws on denied access.
Future<void> saveImageBytes(Uint8List bytes, String fileName) async {
  if (!await Gal.hasAccess(toAlbum: true)) {
    if (!await Gal.requestAccess(toAlbum: true)) {
      throw StateError('Gallery permission denied');
    }
  }
  await Gal.putImageBytes(
    bytes,
    album: 'Campus Assistant',
    name: fileName.replaceAll('.png', ''),
  );
}
