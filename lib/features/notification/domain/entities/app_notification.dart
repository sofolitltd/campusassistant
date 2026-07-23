import '../enums/notification_type.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime timestamp;
  final String? imageUrl;
  final String? actionRoute;
  final Map<String, String>? actionParams;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.timestamp,
    this.imageUrl,
    this.actionRoute,
    this.actionParams,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.fromJson(json['type'] as String),
      isRead: json['is_read'] as bool? ?? false,
      timestamp: DateTime.parse(json['created_at'] as String),
      imageUrl: json['image_url'] as String?,
      actionRoute: data?['action_route'] as String?,
      actionParams: (data?['action_params'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toJson(),
      'is_read': isRead,
      'image_url': imageUrl,
      'created_at': timestamp.toIso8601String(),
      'data': {
        if (actionRoute != null) 'action_route': actionRoute,
        if (actionParams != null) 'action_params': actionParams,
      },
    };
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? timestamp,
    String? imageUrl,
    String? actionRoute,
    Map<String, String>? actionParams,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      actionRoute: actionRoute ?? this.actionRoute,
      actionParams: actionParams ?? this.actionParams,
    );
  }
}
