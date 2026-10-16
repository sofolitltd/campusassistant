extension NumCompact on num {
  /// Renders as entered — "2" stays "2", "2.5" stays "2.5" — instead of
  /// always forcing a decimal like "2.0" (relevant for credit values, which
  /// are stored as double but usually whole numbers).
  String toCompactString() => this % 1 == 0 ? toInt().toString() : toString();
}
