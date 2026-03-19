import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/platform_check.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/auth_provider.dart';
// School
import '../features/shell/shell_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/classes/classes_screen.dart';
import '../features/students/students_screen.dart';
import '../features/teachers/teachers_screen.dart';
import '../features/org/org_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/bsb/bsb_screen.dart';
import '../features/ai/ai_screen.dart';
import '../features/tasks/tasks_screen.dart';
import '../features/messages/messages_screen.dart';
import '../features/settings/settings_screen.dart';
// Student
import '../features/student/shell/student_shell.dart';
import '../features/student/dashboard/student_dashboard_screen.dart';
import '../features/student/tests/test_list_screen.dart';
import '../features/student/tests/test_play_screen.dart';
import '../features/student/tests/test_result_screen.dart';
import '../features/student/leaderboard/leaderboard_screen.dart';
import '../features/student/vocabulary/vocabulary_screen.dart';
import '../features/student/shop/shop_screen.dart';
import '../features/student/homework/homework_screen.dart';
import '../features/student/profile/student_profile_screen.dart';
import '../features/student/journey/journey_screen.dart';
// Parent
import '../features/parent/shell/parent_shell.dart';
import '../features/parent/dashboard/parent_dashboard_screen.dart';
import '../features/parent/children/child_detail_screen.dart';
import '../features/parent/notifications/parent_notifications_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = auth.user;
      final path = state.matchedLocation;
      final isLoginRoute = path == '/login';

      // Not authenticated → login
      if (user == null && !isLoginRoute) return '/login';

      // Authenticated on login page → redirect by role
      if (user != null && isLoginRoute) {
        return _homeForRole(user['role'] as String? ?? 'school_admin');
      }

      // Desktop: block student/parent routes — school only
      if (isDesktop && !path.startsWith('/school')) {
        return '/school/dashboard';
      }

      return null;
    },
    routes: [
      // ─── AUTH ─────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),

      // ─── SCHOOL (all platforms) ───────────────────────────
      ShellRoute(
        builder: (_, __, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/school/dashboard',   builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/school/classes',     builder: (_, __) => const ClassesScreen()),
          GoRoute(path: '/school/students',    builder: (_, __) => const StudentsScreen()),
          GoRoute(path: '/school/teachers',    builder: (_, __) => const TeachersScreen()),
          GoRoute(path: '/school/org',         builder: (_, __) => const OrgScreen()),
          GoRoute(path: '/school/schedule',    builder: (_, __) => const ScheduleScreen()),
          GoRoute(path: '/school/attendance',  builder: (_, __) => const AttendanceScreen()),
          GoRoute(path: '/school/bsb',         builder: (_, __) => const BsbScreen()),
          GoRoute(path: '/school/ai',          builder: (_, __) => const AiScreen()),
          GoRoute(path: '/school/tasks',       builder: (_, __) => const TasksScreen()),
          GoRoute(path: '/school/messages',    builder: (_, __) => const MessagesScreen()),
          GoRoute(path: '/school/settings',    builder: (_, __) => const SettingsScreen()),
          // Placeholder routes
          GoRoute(path: '/school/rating',        builder: (_, __) => const _Placeholder('Maktab reytingi')),
          GoRoute(path: '/school/announcements', builder: (_, __) => const _Placeholder('Yangiliklar')),
          GoRoute(path: '/school/hiring',        builder: (_, __) => const _Placeholder('Hodim olish')),
          GoRoute(path: '/school/inventory',     builder: (_, __) => const _Placeholder('Inventarizatsiya')),
          GoRoute(path: '/school/dynamics',      builder: (_, __) => const _Placeholder('Dinamika')),
          GoRoute(path: '/school/reports',       builder: (_, __) => const _Placeholder('Hisobotlar')),
        ],
      ),

      // ─── STUDENT (mobile only) ────────────────────────────
      if (isMobile) ShellRoute(
        builder: (_, __, child) => StudentShell(child: child),
        routes: [
          GoRoute(path: '/student/dashboard',         builder: (_, __) => const StudentDashboardScreen()),
          GoRoute(path: '/student/tests',             builder: (_, __) => const TestListScreen()),
          GoRoute(path: '/student/tests/:id/play',    builder: (_, s)  => TestPlayScreen(id: s.pathParameters['id']!)),
          GoRoute(path: '/student/tests/:id/result',  builder: (_, s)  => TestResultScreen(id: s.pathParameters['id']!)),
          GoRoute(path: '/student/leaderboard',       builder: (_, __) => const LeaderboardScreen()),
          GoRoute(path: '/student/vocabulary',        builder: (_, __) => const VocabularyScreen()),
          GoRoute(path: '/student/shop',              builder: (_, __) => const ShopScreen()),
          GoRoute(path: '/student/homework',          builder: (_, __) => const HomeworkScreen()),
          GoRoute(path: '/student/profile',           builder: (_, __) => const StudentProfileScreen()),
          GoRoute(path: '/student/journey',           builder: (_, __) => const JourneyScreen()),
        ],
      ),

      // ─── PARENT (mobile only) ─────────────────────────────
      if (isMobile) ShellRoute(
        builder: (_, __, child) => ParentShell(child: child),
        routes: [
          GoRoute(path: '/parent/dashboard',          builder: (_, __) => const ParentDashboardScreen()),
          GoRoute(path: '/parent/children',           builder: (_, __) => const ParentDashboardScreen()),
          GoRoute(path: '/parent/children/:id',       builder: (_, s)  => ChildDetailScreen(id: s.pathParameters['id']!)),
          GoRoute(path: '/parent/notifications',      builder: (_, __) => const ParentNotificationsScreen()),
        ],
      ),
    ],
  );
});

String _homeForRole(String role) {
  if (isDesktop) return '/school/dashboard';
  switch (role) {
    case 'student':      return '/student/dashboard';
    case 'parent':       return '/parent/dashboard';
    case 'direktor':
    case 'zavuch':
    case 'teacher':
    case 'school_admin': return '/school/dashboard';
    default:             return '/school/dashboard';
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0D0F1A),
    body: Center(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 24))),
  );
}
