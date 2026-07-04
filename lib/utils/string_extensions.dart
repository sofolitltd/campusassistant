extension StringSlug on String {
  /// Converts text like "Master’s Program" → "mastersprogram"
  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r"[’'`´]"), '') // remove apostrophes
        .replaceAll(RegExp(r"[^a-z0-9]+"), '') // keep only letters/digits
        .trim();
  }
}
