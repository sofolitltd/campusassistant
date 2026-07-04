import 'package:flutter/material.dart';

/// Notification category icons and their associated colors.
///
/// These are static (same in light and dark mode).
enum NotificationCategory {
  calendar,
  book,
  message,
  reply,
  premium,
  alert,
  medical,
  graduation,
  announcement,
  trophy,
  users,
}

/// Maps each notification category to its brand color.
const Map<NotificationCategory, Color> kNotificationColors = {
  NotificationCategory.calendar: Color(0xFF6C7BFF),
  NotificationCategory.book: Color(0xFF22C55E),
  NotificationCategory.message: Color(0xFF3B82F6),
  NotificationCategory.reply: Color(0xFF8B5CF6),
  NotificationCategory.premium: Color(0xFFF59E0B),
  NotificationCategory.alert: Color(0xFFEF4444),
  NotificationCategory.medical: Color(0xFFE11D48),
  NotificationCategory.graduation: Color(0xFF14B8A6),
  NotificationCategory.announcement: Color(0xFFF97316),
  NotificationCategory.trophy: Color(0xFFFACC15),
  NotificationCategory.users: Color(0xFFEC4899),
};
