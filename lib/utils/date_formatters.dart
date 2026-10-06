import 'package:intl/intl.dart';

/// Formats a [DateTime] as dd-mm-yyyy (e.g. 31-07-2026).
String formatDateDdMmYyyy(DateTime date) =>
    DateFormat('dd-MM-yyyy').format(date);

/// Parses a yyyy-mm-dd (or ISO) date string and formats it as dd-mm-yyyy.
/// Returns the original string when it can't be parsed.
String formatDateStringDdMmYyyy(String dateString) {
  final date = DateTime.tryParse(dateString);
  if (date == null) return dateString;
  return formatDateDdMmYyyy(date);
}
