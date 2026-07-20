enum NotificationType {
  routineUpdate,
  studyMaterial,
  communityPost,
  communityReply,
  subscription,
  emergency,
  bloodRequest,
  alumni,
  notice,
  achievement,
  club;

  String get value => name;

  static NotificationType fromJson(String json) {
    return NotificationType.values.firstWhere(
      (e) => e.value == json,
      orElse: () => NotificationType.notice,
    );
  }

  String toJson() => value;

  String get label {
    switch (this) {
      case NotificationType.routineUpdate:
        return 'Routine Update';
      case NotificationType.studyMaterial:
        return 'Study Material';
      case NotificationType.communityPost:
        return 'Community';
      case NotificationType.communityReply:
        return 'Reply';
      case NotificationType.subscription:
        return 'Subscription';
      case NotificationType.emergency:
        return 'Emergency';
      case NotificationType.bloodRequest:
        return 'Blood Request';
      case NotificationType.alumni:
        return 'Alumni';
      case NotificationType.notice:
        return 'Notice';
      case NotificationType.achievement:
        return 'Achievement';
      case NotificationType.club:
        return 'Club';
    }
  }
}
