import '../../domain/entities/app_notification.dart';
import '../../domain/enums/notification_type.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final List<AppNotification> _notifications = [];
  bool _initialized = false;

  void _seedDemoData() {
    if (_initialized) return;
    _initialized = true;

    final now = DateTime.now();

    _notifications.addAll([
      AppNotification(
        id: '1',
        title: 'Routine Updated for Tomorrow',
        body:
            'Your CSE-301 class has been rescheduled to 10:00 AM in Room 401. Check the updated routine.',
        type: NotificationType.routineUpdate,
        timestamp: now.subtract(const Duration(minutes: 25)),
        actionRoute: '/routine',
      ),
      AppNotification(
        id: '2',
        title: 'New Study Material: OOP Chapter 5',
        body:
            'Dr. Rahman has uploaded notes and slides for Object-Oriented Programming Chapter 5: Inheritance & Polymorphism.',
        type: NotificationType.studyMaterial,
        timestamp: now.subtract(const Duration(hours: 2)),
        actionRoute: '/study/courses/CSE-201/5',
        actionParams: {'title': 'OOP Chapter 5'},
      ),
      AppNotification(
        id: '3',
        title: 'New Reply on Your Post',
        body:
            'Fariha replied to your question in the "Database Design" discussion: "You can use a normalized schema for that."',
        type: NotificationType.communityReply,
        timestamp: now.subtract(const Duration(hours: 5)),
        actionRoute: '/community',
      ),
      AppNotification(
        id: '4',
        title: 'Subscription Confirmed',
        body:
            'Your Premium plan has been activated. You now have access to all study materials, offline downloads, and priority support.',
        type: NotificationType.subscription,
        timestamp: now.subtract(const Duration(hours: 8)),
        actionRoute: '/subscription',
      ),
      AppNotification(
        id: '5',
        title: 'Campus Emergency Drill',
        body:
            'Emergency evacuation drill scheduled for tomorrow at 3:00 PM. All students must assemble at the central field.',
        type: NotificationType.emergency,
        timestamp: now.subtract(const Duration(hours: 12)),
        actionRoute: '/emergency',
      ),
      AppNotification(
        id: '6',
        title: 'Urgent Blood Needed (A+)',
        body:
            'A patient at the university medical center needs A+ blood. Donors please report to the blood bank by 5 PM.',
        type: NotificationType.bloodRequest,
        timestamp: now.subtract(const Duration(days: 1)),
        actionRoute: '/blood-bank',
      ),
      AppNotification(
        id: '7',
        title: 'New Alumni Registered',
        body:
            'Sarah Ahmed (Batch 2019) has joined the alumni network. She is now working as a Software Engineer at Google.',
        type: NotificationType.alumni,
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        actionRoute: '/alumni',
      ),
      AppNotification(
        id: '8',
        title: 'Midterm Exam Schedule Published',
        body:
            'The midterm examination schedule for Spring 2026 has been published. Download your personalized schedule now.',
        type: NotificationType.notice,
        timestamp: now.subtract(const Duration(days: 2)),
        actionRoute: '/study',
      ),
      AppNotification(
        id: '9',
        title: 'Congratulations! CGPA 3.95',
        body:
            'You have achieved the highest CGPA in the CSE department for the Fall 2025 semester. Keep up the great work!',
        type: NotificationType.achievement,
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      AppNotification(
        id: '10',
        title: 'Robotics Club: Hackathon This Weekend',
        body:
            'The CSE Robotics Club is organizing a 24-hour hackathon this Saturday. Register now to participate!',
        type: NotificationType.club,
        timestamp: now.subtract(const Duration(days: 4)),
        actionRoute: '/club',
      ),
      AppNotification(
        id: '11',
        title: 'New Study Resource: DSA Notes',
        body:
          'Comprehensive notes on Data Structures & Algorithms have been added by the faculty. Covers trees, graphs, and dynamic programming.',
        type: NotificationType.studyMaterial,
        isRead: true,
        timestamp: now.subtract(const Duration(days: 5)),
        actionRoute: '/study/courses/CSE-301/3',
        actionParams: {'title': 'DSA Notes'},
      ),
      AppNotification(
        id: '12',
        title: 'Freshers Welcome 2026',
        body:
          'The university welcomes the batch of 2026! Orientation program starts Monday at 9:00 AM in the auditorium.',
        type: NotificationType.notice,
        isRead: true,
        timestamp: now.subtract(const Duration(days: 7)),
      ),
    ]);
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    _seedDemoData();
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
  }
}
