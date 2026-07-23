import '/core/network/api_client.dart';
import '../models/career_job.dart';

class CareerJobRepository {
  final ApiClient apiClient;

  CareerJobRepository(this.apiClient);

  Future<List<CareerJob>> getMyJobs() async {
    final response = await apiClient.get('/my/career-jobs');
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List? ?? [];
    return items.map((e) => CareerJob.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CareerJob> createJob(CareerJob draft) async {
    final response = await apiClient.post('/my/career-jobs', data: draft.toCreateJson());
    return CareerJob.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CareerJob> updateJob(String id, CareerJob draft) async {
    final response = await apiClient.put('/my/career-jobs/$id', data: draft.toCreateJson());
    return CareerJob.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> setStatus(String id, CareerJobStatus status) async {
    await apiClient.put('/my/career-jobs/$id/status', data: {'status': careerJobStatusToString(status)});
  }

  Future<void> deleteJob(String id) async {
    await apiClient.delete('/my/career-jobs/$id');
  }

  /// Peer-shared jobs at the given scope ("batch"|"department"|"university"),
  /// matching the viewer's own affiliation against each job's snapshot.
  Future<List<CareerJob>> getSharedJobs(CareerJobScope scope) async {
    final response = await apiClient.get(
      '/career-jobs-shared',
      queryParameters: {'scope': careerJobScopeToString(scope)},
    );
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List? ?? [];
    return items.map((e) => CareerJob.fromJson(e as Map<String, dynamic>)).toList();
  }
}
