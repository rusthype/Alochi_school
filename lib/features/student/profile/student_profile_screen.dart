import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/badge_widget.dart';
import '../../../features/auth/auth_provider.dart';
import '../../../core/api/student_api.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});
  @override
  ConsumerState<StudentProfileScreen> createState() => _State();
}

class _State extends ConsumerState<StudentProfileScreen> {
  List _achievements = [
    {'id': 1, 'icon': 'star', 'name': 'Birinchi test', 'description': 'Birinchi testni topshirdi', 'earned': true},
    {'id': 2, 'icon': 'fire', 'name': '7 kun streak', 'description': '7 kun ketma-ket kirdi', 'earned': true},
    {'id': 3, 'icon': 'crown', 'name': 'Top 10', 'description': "Reytingda top 10 ga kirdi", 'earned': false},
    {'id': 4, 'icon': 'book', 'name': '100 test', 'description': "100 ta test topshirdi", 'earned': false},
  ];

  @override
  void initState() {
    super.initState();
    studentApi.getAchievements().then((a) {
      if (mounted && a.isNotEmpty) setState(() => _achievements = a.cast<Map>());
    }).catchError((_) {});
  }

  IconData _achievementIcon(String icon) {
    switch (icon) {
      case 'star': return Icons.star_rounded;
      case 'fire': return Icons.local_fire_department_rounded;
      case 'crown': return Icons.emoji_events_rounded;
      case 'book': return Icons.menu_book_rounded;
      default: return Icons.emoji_events_rounded;
    }
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kBgCard,
        title: const Text("Ota-onani taklif qilish", style: TextStyle(color: kTextPrimary)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("Bu kodni ota-onangizga yuboring:", style: TextStyle(color: kTextSecondary, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: kBgMain, borderRadius: BorderRadius.circular(10)),
            child: const Text("ALCH-7842", style: TextStyle(color: kOrange, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Yopish")),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nusxa olindi"))); },
            child: const Text("Nusxa olish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final name = user?['name'] ?? user?['username'] ?? 'Foydalanuvchi';
    final role = user?['role'] ?? 'student';

    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile header
              AvatarWidget(name: name.toString(), size: 80),
              const SizedBox(height: 12),
              Text(name.toString(), style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              BadgeWidget(text: _roleLabel(role.toString()), color: kOrange),
              const SizedBox(height: 20),

              // XP bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Daraja 5 — Junior Scholar', style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const Text('1250 / 2000 XP', style: TextStyle(color: kOrange, fontSize: 12)),
                  ]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.625,
                    backgroundColor: kBgBorder,
                    valueColor: const AlwaysStoppedAnimation(kOrange),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 4),
                  const Align(alignment: Alignment.centerRight, child: Text('750 XP qoldi', style: TextStyle(color: kTextMuted, fontSize: 11))),
                ]),
              ),
              const SizedBox(height: 16),

              // Stats
              Row(children: [
                _StatCard(value: '142', label: 'Testlar'),
                const SizedBox(width: 10),
                _StatCard(value: '76.3%', label: "O'rtacha"),
                const SizedBox(width: 10),
                _StatCard(value: '7', label: 'Streak', icon: Icons.local_fire_department_rounded, color: kRed),
              ]),
              const SizedBox(height: 20),

              // Achievements
              const Align(alignment: Alignment.centerLeft, child: Text('Yutuqlar', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600))),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.1, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: _achievements.length,
                itemBuilder: (_, i) {
                  final a = _achievements[i] as Map;
                  final earned = a['earned'] == true;
                  final iconColor = earned ? kOrange : kTextMuted.withOpacity(0.4);
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: earned ? kOrange.withOpacity(0.3) : kBgBorder)),
                    child: Column(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: Icon(_achievementIcon(a['icon'] as String), color: iconColor, size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(a['name'] as String, style: TextStyle(color: earned ? kTextPrimary : kTextMuted, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                      const SizedBox(height: 2),
                      Text(a['description'] as String, style: const TextStyle(color: kTextMuted, fontSize: 10), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      if (earned)
                        const Text('Qozonildi', style: TextStyle(color: kGreen, fontSize: 10))
                      else
                        const Icon(Icons.lock_rounded, color: kTextMuted, size: 14),
                    ]),
                  );
                },
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: _showInviteDialog,
                icon: const Icon(Icons.share_rounded),
                label: const Text("Ota-onani taklif qilish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _roleLabel(String role) {
  const m = {'student': "O'quvchi", 'teacher': "O'qituvchi", 'school_admin': 'Admin', 'parent': 'Ota-ona'};
  return m[role] ?? role;
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData? icon;
  final Color? color;
  const _StatCard({required this.value, required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBgBorder)),
      child: Column(children: [
        if (icon != null) Icon(icon, color: color ?? kOrange, size: 18),
        Text(value, style: TextStyle(color: color ?? kOrange, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
      ]),
    ),
  );
}
