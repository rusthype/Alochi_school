import 'api_client.dart';

class StudentApi {
  Future<Map<String, dynamic>> getProfile() async {
    final r = await apiClient.get('/gamification/profile/');
    return r.data as Map<String, dynamic>;
  }

  Future<List> getNotifications() async {
    final r = await apiClient.get('/notifications/');
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getTestCatalog({String? bookId}) async {
    final r = await apiClient.get('/tests/catalog/', params: {
      if (bookId != null) 'book': bookId,
    });
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getBooks() async {
    final r = await apiClient.get('/tests/books/');
    return r.data['results'] ?? r.data as List;
  }

  Future<Map<String, dynamic>> getTest(String id) async {
    final r = await apiClient.get('/tests/$id/');
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitTest(
      String id, Map<String, dynamic> answers) async {
    final r = await apiClient.post('/tests/$id/submit/', data: answers);
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getLeaderboard({String scope = 'global'}) async {
    final r = await apiClient.get('/leaderboard/', params: {'scope': scope});
    return r.data as Map<String, dynamic>;
  }

  Future<List> getVocabularyTopics({String? bookId}) async {
    final r = await apiClient.get('/vocabulary/topics/', params: {
      if (bookId != null) 'book': bookId,
    });
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getVocabularyWords(String topicId) async {
    final r = await apiClient.get('/vocabulary/words/$topicId/');
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getShopItems({String? category}) async {
    final r = await apiClient.get('/shop/items/', params: {
      if (category != null) 'category': category,
    });
    return r.data['results'] ?? r.data as List;
  }

  Future<Map<String, dynamic>> getWallet() async {
    final r = await apiClient.get('/coins/wallet/');
    return r.data as Map<String, dynamic>;
  }

  Future<void> purchaseItem(String slug) async {
    await apiClient.post('/shop/items/$slug/purchase/');
  }

  Future<Map<String, dynamic>> analyzeHomework(dynamic formData) async {
    final r = await apiClient.post('/ai/homework/analyze/', data: formData);
    return r.data as Map<String, dynamic>;
  }

  Future<List> getAchievements() async {
    final r = await apiClient.get('/gamification/achievements/');
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getJourney() async {
    final r = await apiClient.get('/journey/');
    return r.data['results'] ?? r.data as List;
  }

  Future<List> getRecentResults() async {
    final r = await apiClient.get('/attempts/recent/');
    return r.data['results'] ?? r.data as List;
  }
}

final studentApi = StudentApi();
