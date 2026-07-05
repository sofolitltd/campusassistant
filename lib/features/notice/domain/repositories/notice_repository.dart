import '../../data/models/notice_model.dart';

abstract class NoticeRepository {
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  });
}
