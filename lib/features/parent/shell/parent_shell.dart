import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';

class ParentShell extends StatelessWidget {
  final Widget child;
  const ParentShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int idx = 0;
    if (location.startsWith('/parent/children')) {
      idx = 1;
    } else if (location.startsWith('/parent/notifications')) {
      idx = 2;
    }

    return Scaffold(
      backgroundColor: kBgMain,
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: kBgSidebar,
        indicatorColor: kOrange.withOpacity(0.15),
        selectedIndex: idx,
        onDestinationSelected: (i) {
          const routes = ['/parent/dashboard', '/parent/children', '/parent/notifications'];
          context.go(routes[i]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: kOrange),
            label: 'Bosh sahifa',
          ),
          NavigationDestination(
            icon: Icon(Icons.child_care_outlined),
            selectedIcon: Icon(Icons.child_care_rounded, color: kOrange),
            label: 'Farzandlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_rounded, color: kOrange),
            label: 'Bildirishnomalar',
          ),
        ],
      ),
    );
  }
}
