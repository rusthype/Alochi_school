import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../core/api/parent_api.dart';
import '../../../core/utils/score_color.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});
  @override
  State<ParentDashboardScreen> createState() => _State();
}

class _State extends State<ParentDashboardScreen> {
  List _children = [
    {'id': '1', 'name': 'Karimov Sarvar', 'grade': '9-A', 'school': '1-maktab', 'last_active': '2 soat oldin', 'avg_score': 82.0, 'streak': 5},
    {'id': '2', 'name': 'Karimova Nilufar', 'grade': '6-B', 'school': '1-maktab', 'last_active': 'Kecha', 'avg_score': 91.0, 'streak': 12},
  ];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final c = await parentApi.getChildren();
      if (mounted && c.isNotEmpty) setState(() => _children = c.cast<Map>());
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: kOrange))
            : _children.isEmpty
                ? const Center(child: Text("Farzandlar yo'q", style: TextStyle(color: Color(0xFF8B92B3), fontSize: 16)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Farzandlarim', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ..._children.map((child) => _ChildCard(child: child)),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final Map child;
  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final avg = (child['avg_score'] as num?)?.toDouble() ?? 0;
    final color = scoreColor(avg);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          AvatarWidget(name: child['name'] as String, size: 56),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(child['name'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("${child['grade']} • ${child['school']}", style: const TextStyle(color: kTextSecondary, fontSize: 13)),
          ])),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _Chip(label: "${avg.toStringAsFixed(1)}%", color: color, icon: Icons.bar_chart_rounded),
          const SizedBox(width: 8),
          _Chip(label: "${child['streak']} kun", color: kRed, icon: Icons.local_fire_department_rounded),
          const SizedBox(width: 8),
          Expanded(child: Text(child['last_active'] as String, style: const TextStyle(color: kTextMuted, fontSize: 11), overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.go('/parent/children/${child['id']}'),
            child: const Text("Batafsil ko'rish"),
          ),
        ),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _Chip({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 12),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}
