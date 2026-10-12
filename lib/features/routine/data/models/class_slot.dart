/// One weekly recurring class period for a batch. Plain class rather than
/// freezed: read-mostly, no copyWith needs — forms rebuild a payload map
/// directly from controller state.
class ClassSlot {
  final String id;
  final String universityId;
  final String departmentId;
  final String batchId;

  /// 0=Sunday..6=Saturday, matching the backend's day_of_week.
  final int dayOfWeek;
  final String courseName;
  final String teacher;
  final String room;

  /// "HH:MM", 24h.
  final String startTime;
  final String endTime;

  const ClassSlot({
    required this.id,
    required this.universityId,
    required this.departmentId,
    required this.batchId,
    required this.dayOfWeek,
    required this.courseName,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  factory ClassSlot.fromJson(Map<String, dynamic> json) => ClassSlot(
    id: json['id'] as String,
    universityId: json['university_id'] as String? ?? '',
    departmentId: json['department_id'] as String? ?? '',
    batchId: json['batch_id'] as String? ?? '',
    dayOfWeek: json['day_of_week'] as int? ?? 0,
    courseName: json['course_name'] as String? ?? '',
    teacher: json['teacher'] as String? ?? '',
    room: json['room'] as String? ?? '',
    startTime: json['start_time'] as String? ?? '',
    endTime: json['end_time'] as String? ?? '',
  );
}

/// Overrides a single occurrence of a [ClassSlot]: cancelled, or moved to a
/// different time/room. No row for a (slot, date) means the class is held
/// as scheduled.
class ClassSlotStatus {
  final String id;
  final String classSlotId;
  final DateTime date;
  final String status; // "cancelled" | "rescheduled"
  final String newStartTime;
  final String newEndTime;
  final String newRoom;
  final String note;

  const ClassSlotStatus({
    required this.id,
    required this.classSlotId,
    required this.date,
    required this.status,
    required this.newStartTime,
    required this.newEndTime,
    required this.newRoom,
    required this.note,
  });

  bool get isCancelled => status == 'cancelled';
  bool get isRescheduled => status == 'rescheduled';

  factory ClassSlotStatus.fromJson(Map<String, dynamic> json) =>
      ClassSlotStatus(
        id: json['id'] as String,
        classSlotId: json['class_slot_id'] as String,
        date: DateTime.parse(json['date'] as String),
        status: json['status'] as String? ?? '',
        newStartTime: json['new_start_time'] as String? ?? '',
        newEndTime: json['new_end_time'] as String? ?? '',
        newRoom: json['new_room'] as String? ?? '',
        note: json['note'] as String? ?? '',
      );
}
