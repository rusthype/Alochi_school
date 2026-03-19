import 'api_client.dart';
import '../storage/secure_storage.dart';

class AuthApi {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await apiClient.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    final data = res.data as Map<String, dynamic>;
    await SecureStorage.saveTokens(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
    );
    return data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await apiClient.get('/users/me');
    return res.data as Map<String, dynamic>;
  }

  Future<void> updateMe(Map<String, dynamic> data) async {
    // Never include role in payload
    final safe = Map<String, dynamic>.from(data)
      ..remove('role')
      ..remove('is_staff')
      ..remove('is_superuser')
      ..remove('is_active');
    await apiClient.patch('/users/me', data: safe);
  }

  Future<void> logout() => SecureStorage.clear();
}

final authApi = AuthApi();
