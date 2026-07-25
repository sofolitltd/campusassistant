import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Metadata for one of the 9 backend notification_preference categories
/// (see campusassistant-api's domain.NotificationCategories). Deliberately
/// separate from NotificationType (lib/features/notification/domain/enums) —
/// that enum is a display-only categorization for inbox icons and doesn't
/// map 1:1 to these mutable categories.
class NotificationCategoryMeta {
  final String key;
  final String label;
  final String description;
  final IconData icon;

  const NotificationCategoryMeta({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
  });
}

const List<NotificationCategoryMeta> notificationCategories = [
  NotificationCategoryMeta(
    key: 'university',
    label: 'University Announcements',
    description: 'Admin broadcasts to your whole university',
    icon: LucideIcons.landmark,
  ),
  NotificationCategoryMeta(
    key: 'department',
    label: 'Department Notices',
    description: 'Broadcasts from your department',
    icon: LucideIcons.building2,
  ),
  NotificationCategoryMeta(
    key: 'batch',
    label: 'Batch Notices',
    description: 'Broadcasts to your batch/section',
    icon: LucideIcons.graduationCap,
  ),
  NotificationCategoryMeta(
    key: 'club',
    label: 'Club Updates',
    description: 'Posts and events from clubs you follow',
    icon: LucideIcons.usersRound,
  ),
  NotificationCategoryMeta(
    key: 'association',
    label: 'Association Updates',
    description: 'Posts and events from associations you follow',
    icon: LucideIcons.handshake,
  ),
  NotificationCategoryMeta(
    key: 'lost_found',
    label: 'Lost & Found',
    description: 'Claims and updates on your lost/found items',
    icon: LucideIcons.searchCheck,
  ),
  NotificationCategoryMeta(
    key: 'career',
    label: 'Career Reminders',
    description: 'Job/circular reminders you set',
    icon: LucideIcons.briefcase,
  ),
  NotificationCategoryMeta(
    key: 'marketplace',
    label: 'Marketplace Orders',
    description: 'Order and merchant status updates',
    icon: LucideIcons.shoppingBag,
  ),
  NotificationCategoryMeta(
    key: 'study_material',
    label: 'Study Material',
    description: 'New resources uploaded for your courses',
    icon: LucideIcons.bookOpen,
  ),
];
