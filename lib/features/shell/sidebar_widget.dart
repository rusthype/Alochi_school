import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../auth/auth_provider.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
  });
}

class _NavSection {
  final String title;
  final List<_NavItem> items;
  const _NavSection(this.title, this.items);
}

final _sections = [
  _NavSection('ASOSIY', [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/school/dashboard'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Sinflar', route: '/school/classes'),
    _NavItem(icon: Icons.people_rounded, label: "O'quvchilar", route: '/school/students'),
    _NavItem(icon: Icons.school_rounded, label: "O'qituvchilar", route: '/school/teachers'),
  ]),
  _NavSection('REYTING & AI', [
    _NavItem(icon: Icons.emoji_events_rounded, label: 'Maktab reytingi', route: '/school/rating'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'BSB / ChSB', route: '/school/bsb'),
    _NavItem(icon: Icons.psychology_rounded, label: 'AI Tahlil', route: '/school/ai', badge: 4),
  ]),
  _NavSection('BOSHQARUV', [
    _NavItem(icon: Icons.account_tree_rounded, label: 'ORG Struktura', route: '/school/org'),
    _NavItem(icon: Icons.chat_bubble_rounded, label: 'Xabarlar', route: '/school/messages', badge: 3),
    _NavItem(icon: Icons.checklist_rounded, label: 'Topshiriqlar', route: '/school/tasks', badge: 3),
    _NavItem(icon: Icons.campaign_rounded, label: 'Yangiliklar', route: '/school/announcements'),
    _NavItem(icon: Icons.person_add_rounded, label: 'Hodim olish', route: '/school/hiring', badge: 7),
    _NavItem(icon: Icons.inventory_2_rounded, label: 'Inventarizatsiya', route: '/school/inventory'),
    _NavItem(icon: Icons.calendar_month_rounded, label: 'Dars Jadvali', route: '/school/schedule'),
    _NavItem(icon: Icons.trending_up_rounded, label: 'Dinamika', route: '/school/dynamics'),
    _NavItem(icon: Icons.description_rounded, label: 'Hisobotlar', route: '/school/reports'),
    _NavItem(icon: Icons.settings_rounded, label: 'Sozlamalar', route: '/school/settings'),
  ]),
];

class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final user = ref.watch(authProvider).user;

    return Container(
      width: 220,
      height: double.infinity,
      color: kBgSidebar,
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A'lochi",
                      style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Maktab',
                      style: TextStyle(color: kOrange, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: kBgBorder),

          // Nav sections
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _sections.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                        child: Text(
                          section.title,
                          style: const TextStyle(
                            color: kTextMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      ...section.items.map((item) => _NavItemWidget(
                            item: item,
                            isActive: location == item.route || location.startsWith(item.route + '/'),
                          )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1, color: kBgBorder),

          // User footer
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AvatarWidget(
                  name: user?['name'] ?? user?['username'] ?? 'Admin',
                  size: 36,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?['name'] ?? user?['username'] ?? 'Admin',
                        style: const TextStyle(
                          color: kTextPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user?['role'] ?? 'school_admin',
                        style: const TextStyle(color: kTextMuted, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout_rounded, color: kTextMuted, size: 18),
                  tooltip: 'Chiqish',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isActive;

  const _NavItemWidget({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? kOrange.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? Border(left: BorderSide(color: kOrange, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: isActive ? kOrange : kTextMuted,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: isActive ? kOrange : kTextSecondary,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${item.badge}',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
