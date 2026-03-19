import 'api_client.dart';

class SchoolApi {
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await apiClient.get('/school/dashboard/');
    return res.data as Map<String, dynamic>;
  }

  Future<List> getClasses() async {
    final res = await apiClient.get('/school/classes/');
    return res.data as List;
  }

  Future<Map<String, dynamic>> createClass(Map<String, dynamic> data) async {
    final res = await apiClient.post('/school/classes/', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<void> deleteClass(int id) async {
    await apiClient.delete('/school/classes/$id/');
  }

  Future<List> getStudents({String? classId, String? search}) async {
    final params = <String, dynamic>{};
    if (classId != null) params['class'] = classId;
    if (search != null) params['search'] = search;
    final res = await apiClient.get('/school/students/', params: params);
    return res.data is List ? res.data as List : (res.data['results'] ?? []) as List;
  }

  Future<List> getTeachers() async {
    final res = await apiClient.get('/school/teachers/');
    return res.data is List ? res.data as List : (res.data['results'] ?? []) as List;
  }

  Future<Map<String, dynamic>> getOrg() async {
    final res = await apiClient.get('/school/org/');
    return res.data as Map<String, dynamic>;
  }

  Future<List> getSchedule({String? classId}) async {
    final res = await apiClient.get('/school/schedule/', params: classId != null ? {'class': classId} : null);
    return res.data is List ? res.data as List : [];
  }

  Future<Map<String, dynamic>> getAttendance({String? classId, String? date}) async {
    final params = <String, dynamic>{};
    if (classId != null) params['class'] = classId;
    if (date != null) params['date'] = date;
    final res = await apiClient.get('/school/attendance/', params: params);
    return res.data is Map ? res.data as Map<String, dynamic> : {};
  }

  Future<void> saveAttendance(Map<String, dynamic> data) async {
    await apiClient.post('/school/attendance/', data: data);
  }

  Future<List> getTasks() async {
    final res = await apiClient.get('/school/tasks/');
    return res.data is List ? res.data as List : [];
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    final res = await apiClient.post('/school/tasks/', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    await apiClient.patch('/school/tasks/$id/', data: data);
  }

  Future<List> getMessages() async {
    final res = await apiClient.get('/school/messages/');
    return res.data is List ? res.data as List : [];
  }

  Future<void> sendMessage(Map<String, dynamic> data) async {
    await apiClient.post('/school/messages/', data: data);
  }

  Future<Map<String, dynamic>> getBsbStats() async {
    final res = await apiClient.get('/school/bsb/stats/');
    return res.data is Map ? res.data as Map<String, dynamic> : {};
  }
}

final schoolApi = SchoolApi();
