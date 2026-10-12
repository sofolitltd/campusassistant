extension StringSlug on String {
  /// Converts text like "Master’s Program" → "mastersprogram"
  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r"[’'`´]"), '') // remove apostrophes
        .replaceAll(RegExp(r"[^a-z0-9]+"), '') // keep only letters/digits
        .trim();
  }
}

extension StringTitleCase on String {
  /// Converts text like "your university" → "Your University".
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
