import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';

class StudentShell extends StatelessWidget {
  final Widget child;
  const StudentShell({super.key, required this.child});

  static const _routes = [
    '/student/dashboard',
    '/student/tests',
    '/student/leaderboard',
    '/student/shop',
    '/student/profile',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int idx = _routes.indexWhere((r) => location == r || location.startsWith('$r/'));
    if (idx < 0) idx = 0;

    return Scaffold(
      backgroundColor: kBgMain,
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: kBgSidebar,
        indicatorColor: kOrange.withOpacity(0.15),
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_routes[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: kOrange),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded, color: kOrange),
            label: 'Testlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard_rounded, color: kOrange),
            label: 'Reyting',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded, color: kOrange),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person_rounded, color: kOrange),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
