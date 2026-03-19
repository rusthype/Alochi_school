import 'api_client.dart';

class ParentApi {
  Future<List> getChildren() async {
    final r = await apiClient.get('/parent/children/');
    return r.data['results'] ?? r.data as List;
  }

  Future<Map<String, dynamic>> getChildDetail(String id) async {
    final r = await apiClient.get('/parent/children/$id/');
    return r.data as Map<String, dynamic>;
  }

  Future<List> getChildResults(String id) async {
    final r = await apiClient.get('/parent/children/$id/results/');
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getChildAttendance(String id) async {
    final r = await apiClient.get('/parent/children/$id/attendance/');
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getNotifications() async {
    final r = await apiClient.get('/notifications/');
    return r.data['results'] ?? r.data as List;
  }

  Future<void> markAllRead() async {
    await apiClient.post('/notifications/mark-all-read/');
  }
}

final parentApi = ParentApi();
