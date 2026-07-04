import '../../../../core/network/api_client.dart';
import '../models/chapter_model.dart';

abstract class ChapterRemoteDataSource {
  Future<List<ChapterModel>> getChapters(String courseCode, {String? batchId});
  Future<ChapterModel> createChapter(ChapterModel chapter);
  Future<ChapterModel> updateChapter(ChapterModel chapter);
  Future<void> deleteChapter(String id);
}

class ChapterRemoteDataSourceImpl implements ChapterRemoteDataSource {
  final ApiClient apiClient;

  ChapterRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ChapterModel>> getChapters(
    String courseCode, {
    String? batchId,
  }) async {
    final queryParams = {'course_code': courseCode};
    if (batchId != null) queryParams['batch_id'] = batchId;

    final response = await apiClient.get(
      '/chapters',
      queryParameters: queryParams,
    );
    final List data = response.data['data'];
    return data.map((e) => ChapterModel.fromJson(e)).toList();
  }

  @override
  Future<ChapterModel> createChapter(ChapterModel chapter) async {
    final response = await apiClient.post('/chapters', data: chapter.toJson());
    return ChapterModel.fromJson(response.data);
  }

  @override
  Future<ChapterModel> updateChapter(ChapterModel chapter) async {
    final response = await apiClient.put(
      '/chapters/${chapter.id}',
      data: chapter.toJson(),
    );
    return ChapterModel.fromJson(response.data);
  }

  @override
  Future<void> deleteChapter(String id) async {
    await apiClient.delete('/chapters/$id');
  }
}
