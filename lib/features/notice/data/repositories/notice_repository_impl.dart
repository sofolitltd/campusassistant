import '../../data/datasources/notice_remote_data_source.dart';
import '../../domain/repositories/notice_repository.dart';
import '../models/notice_model.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;

  NoticeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  }) async {
    return remoteDataSource.getNotices(
      universityId: universityId,
      departmentId: departmentId,
    );
  }
}
