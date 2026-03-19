import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/badge_widget.dart';
import '../../../core/api/student_api.dart';
import '../../../core/utils/score_color.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});
  @override
  State<StudentDashboardScreen> createState() => _State();
}

class _State extends State<StudentDashboardScreen> {
  Map _profile = {
    'name': 'Ali Karimov',
    'xp': 1250,
    'xp_max': 2000,
    'coins': 340,
    'rank': 12,
    'streak': 7,
    'level': 5,
  };
  List _recent = [
    {'title': 'Matematika sinovi', 'score': 88, 'xp': 45, 'date': '1 soat oldin'},
    {'title': 'Ingliz tili', 'score': 72, 'xp': 30, 'date': 'Kecha'},
    {'title': 'Fizika amaliyoti', 'score': 95, 'xp': 55, 'date': '2 kun oldin'},
    {'title': 'Kimyo testi', 'score': 55, 'xp': 15, 'date': '3 kun oldin'},
    {'title': 'Geometriya', 'score': 81, 'xp': 38, 'date': '4 kun oldin'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await studentApi.getProfile();
      final r = await studentApi.getRecentResults();
      if (mounted) setState(() {
        _profile = p;
        if (r.isNotEmpty) _recent = r.cast<Map>();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile['name'] ?? 'Salom';
    final xp = (_profile['xp'] as num?) ?? 0;
    final xpMax = (_profile['xp_max'] as num?) ?? 2000;
    final coins = _profile['coins'] ?? 0;
    final rank = _profile['rank'] ?? 0;
    final streak = _profile['streak'] ?? 0;
    final level = _profile['level'] ?? 1;
    final xpPct = (xpMax > 0) ? (xp / xpMax).toDouble().clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(children: [
                AvatarWidget(name: name.toString(), size: 48),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Salom, ${name.toString().split(' ').first}!',
                      style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                  BadgeWidget(text: 'Daraja $level', color: kOrange),
                ])),
              ]),
              const SizedBox(height: 20),

              // XP bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('XP Progress', style: TextStyle(color: kTextSecondary, fontSize: 13)),
                    Text('$xp / $xpMax XP', style: const TextStyle(color: kOrange, fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: xpPct,
                    backgroundColor: kBgBorder,
                    valueColor: const AlwaysStoppedAnimation(kOrange),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(children: [
                _StatChip(label: 'XP', value: '$xp', color: kOrange),
                const SizedBox(width: 8),
                _StatChip(label: 'Coin', value: '$coins', color: kYellow, icon: Icons.monetization_on_rounded),
                const SizedBox(width: 8),
                _StatChip(label: 'Rank', value: '#$rank', color: kBlue),
                const SizedBox(width: 8),
                _StatChip(label: 'Streak', value: '$streak', color: kRed, icon: Icons.local_fire_department_rounded),
              ]),
              const SizedBox(height: 20),

              // Quick actions
              const Text('Tezkor amallar', style: TextStyle(color: kTextSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(children: [
                _QuickAction(label: 'Test ishlash', icon: Icons.quiz_rounded, color: kOrange, onTap: () => context.go('/student/tests')),
                const SizedBox(width: 10),
                _QuickAction(label: 'Reyting', icon: Icons.leaderboard_rounded, color: kBlue, onTap: () => context.go('/student/leaderboard')),
                const SizedBox(width: 10),
                _QuickAction(label: 'Shop', icon: Icons.storefront_rounded, color: kGreen, onTap: () => context.go('/student/shop')),
              ]),
              const SizedBox(height: 20),

              // Recent results
              const Text("So'nggi natijalar", style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ..._recent.map((r) => _ResultRow(result: r)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData? icon;
  const _StatChip({required this.label, required this.value, required this.color, this.icon});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(children: [
        if (icon != null) Icon(icon, color: color, size: 16) else const SizedBox(height: 16),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 10)),
      ]),
    ),
  );
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ]),
      ),
    ),
  );
}

class _ResultRow extends StatelessWidget {
  final Map result;
  const _ResultRow({required this.result});

  @override
  Widget build(BuildContext context) {
    final score = (result['score'] as num?) ?? 0;
    final color = scoreColor(score);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBgBorder)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(result['title'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          Text(result['date'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Text('$score%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
