/// Saves PNG bytes where the user expects a "download" to land: the photo
/// gallery on Android/iOS, a browser file download on web.
library;

export 'save_image_io.dart' if (dart.library.js_interop) 'save_image_web.dart';
