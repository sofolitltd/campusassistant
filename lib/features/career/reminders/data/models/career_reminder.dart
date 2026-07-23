enum CareerReminderStatus { pending, sent, cancelled }

CareerReminderStatus careerReminderStatusFromString(String? value) {
  switch (value) {
    case 'sent':
      return CareerReminderStatus.sent;
    case 'cancelled':
      return CareerReminderStatus.cancelled;
    default:
      return CareerReminderStatus.pending;
  }
}

class CareerReminder {
  final String id;
  final String? jobId;
  final String title;
  final DateTime remindAt;
  final CareerReminderStatus status;
  final DateTime? sentAt;

  CareerReminder({
    required this.id,
    this.jobId,
    required this.title,
    required this.remindAt,
    required this.status,
    this.sentAt,
  });

  factory CareerReminder.fromJson(Map<String, dynamic> json) {
    return CareerReminder(
      id: json['id'] as String? ?? '',
      jobId: json['job_id'] as String?,
      title: json['title'] as String? ?? '',
      remindAt: DateTime.tryParse(json['remind_at']?.toString() ?? '') ??
          DateTime.now(),
      status: careerReminderStatusFromString(json['status'] as String?),
      sentAt: json['sent_at'] != null
          ? DateTime.tryParse(json['sent_at'].toString())
          : null,
    );
  }
}
