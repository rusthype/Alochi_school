import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/auth_api.dart';
import '../../core/storage/secure_storage.dart';

class AuthState {
  final Map<String, dynamic>? user;
  final bool isLoading;
  final bool isInitialized;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
  });

  AuthState copyWith({
    Map<String, dynamic>? user,
    bool? isLoading,
    bool? isInitialized,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) =>
      AuthState(
        user: clearUser ? null : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        isInitialized: isInitialized ?? this.isInitialized,
        error: clearError ? null : error ?? this.error,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      try {
        final me = await authApi.getMe();
        state = state.copyWith(user: me, isInitialized: true);
        return;
      } catch (_) {
        await SecureStorage.clear();
      }
    }
    state = state.copyWith(isInitialized: true);
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await authApi.login(username, password);
      final me = await authApi.getMe();
      state = state.copyWith(user: me, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Foydalanuvchi nomi yoki parol noto'g'ri",
      );
      rethrow;
    }
  }

  Future<void> fetchMe() async {
    final token = await SecureStorage.getAccessToken();
    if (token == null) return;
    try {
      final me = await authApi.getMe();
      state = state.copyWith(user: me);
    } catch (_) {
      state = state.copyWith(clearUser: true);
    }
  }

  Future<void> logout() async {
    await authApi.logout();
    state = const AuthState();
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);
