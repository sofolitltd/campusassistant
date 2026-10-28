/// A scheduled exam for the student's department (optionally narrowed to
/// their batch). Read-only on the client — admins manage these from the
/// dashboard. Plain class rather than freezed: no copyWith needs.
class ExamNotice {
  final String id;
  final String courseName;

  /// Links to a Study course by its code (not an ID — Study looks courses up
  /// by code), empty when this exam isn't tied to one.
  final String courseCode;

  /// `quiz`, `midterm`, `final`, `retake`, or `improvement`.
  final String examType;
  final DateTime examDate;
  final String startTime;
  final String room;
  final String seatPlanUrl;
  final String syllabusUrl;
  final String note;
  final String? batchId;

  const ExamNotice({
    required this.id,
    required this.courseName,
    required this.courseCode,
    required this.examType,
    required this.examDate,
    required this.startTime,
    required this.room,
    required this.seatPlanUrl,
    required this.syllabusUrl,
    required this.note,
    required this.batchId,
  });

  bool get hasSeatPlan => seatPlanUrl.isNotEmpty;
  bool get hasSyllabus => syllabusUrl.isNotEmpty;
  bool get hasCourseLink => courseCode.isNotEmpty;

  /// Whole days from today to [examDate] (negative once it has passed).
  int daysUntil() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final target = DateTime(examDate.year, examDate.month, examDate.day);
    return target.difference(todayDate).inDays;
  }

  bool get isPast => daysUntil() < 0;

  factory ExamNotice.fromJson(Map<String, dynamic> json) => ExamNotice(
    id: json['id'] as String,
    courseName: json['course_name'] as String? ?? '',
    courseCode: json['course_code'] as String? ?? '',
    examType: json['exam_type'] as String? ?? 'midterm',
    examDate: DateTime.parse(json['exam_date'] as String).toLocal(),
    startTime: json['start_time'] as String? ?? '',
    room: json['room'] as String? ?? '',
    seatPlanUrl: json['seat_plan_url'] as String? ?? '',
    syllabusUrl: json['syllabus_url'] as String? ?? '',
    note: json['note'] as String? ?? '',
    batchId: json['batch_id'] as String?,
  );
}
