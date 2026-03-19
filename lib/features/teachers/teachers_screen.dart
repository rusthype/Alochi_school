import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/badge_widget.dart';
import '../../core/api/school_api.dart';
import '../../core/utils/score_color.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});
  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  List _teachers = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  final _mock = [
    {'name': 'Karimova Nargiza', 'subject': 'Matematika', 'classes': ['11-A', '10-A'], 'avg': 87.2, 'students': 66, 'lessons': 14, 'status': 'Yaxshi'},
    {'name': 'Toshmatova Gulnora', 'subject': 'Ona tili', 'classes': ['9-A', '8-A'], 'avg': 52.0, 'students': 61, 'lessons': 12, 'status': 'AI Ogohlantirish'},
    {'name': 'Ergashev Jasur', 'subject': 'Psixolog', 'classes': [], 'avg': 0.0, 'students': 0, 'lessons': 0, 'status': 'AI Ogohlantirish'},
    {'name': 'Nazarova Malika', 'subject': 'Ingliz tili', 'classes': ['10-B', '9-B'], 'avg': 74.5, 'students': 60, 'lessons': 16, 'status': 'O\'rta'},
    {'name': 'Botirov Sardor', 'subject': 'Fizika', 'classes': ['11-A', '11-B'], 'avg': 79.3, 'students': 62, 'lessons': 12, 'status': 'Yaxshi'},
    {'name': 'Alimova Zulfiya', 'subject': 'Kimyo', 'classes': ['9-B'], 'avg': 67.1, 'students': 29, 'lessons': 8, 'status': 'O\'rta'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await schoolApi.getTeachers();
      if (mounted) setState(() { _teachers = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _teachers = _mock; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchCtrl.text.toLowerCase();
    final filtered = q.isEmpty ? _teachers : _teachers.where((t) => (t['name'] ?? '').toLowerCase().contains(q)).toList();

    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("O'qituvchilar", style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Jami: ${_teachers.length} ta', style: const TextStyle(color: kTextSecondary, fontSize: 14)),
              ]),
            ]),
            const SizedBox(height: 20),
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: kTextPrimary),
              decoration: const InputDecoration(
                hintText: "O'qituvchi qidirish...",
                prefixIcon: Icon(Icons.search_rounded, color: kTextMuted, size: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kOrange))
                  : LayoutBuilder(builder: (context, c) {
                      final cols = c.maxWidth > 900 ? 3 : c.maxWidth > 600 ? 2 : 1;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _TeacherCard(teacher: filtered[i] as Map),
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final Map teacher;
  const _TeacherCard({required this.teacher});

  Color _statusColor(String status) {
    if (status.contains('Ogohlantirish')) return kRed;
    if (status == 'Yaxshi') return kGreen;
    return kYellow;
  }

  @override
  Widget build(BuildContext context) {
    final avg = (teacher['avg'] ?? 0).toDouble();
    final status = teacher['status'] ?? 'O\'rta';
    final classes = (teacher['classes'] as List?) ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            AvatarWidget(name: teacher['name'] ?? '', size: 48),
            BadgeWidget(text: status, color: _statusColor(status), fontSize: 11),
          ]),
          const SizedBox(height: 14),
          Text(teacher['name'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: kOrange.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
            child: Text(teacher['subject'] ?? '', style: const TextStyle(color: kOrange, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),
          if (classes.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: classes.map<Widget>((c) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: kBgBorder, borderRadius: BorderRadius.circular(6)),
                child: Text('$c', style: const TextStyle(color: kTextSecondary, fontSize: 11)),
              )).toList(),
            ),
          const Spacer(),
          Row(children: [
            _Stat(icon: Icons.bar_chart_rounded, value: avg.toStringAsFixed(1), color: scoreColor(avg)),
            const SizedBox(width: 16),
            _Stat(icon: Icons.people_rounded, value: '${teacher['students'] ?? 0}'),
            const SizedBox(width: 16),
            _Stat(icon: Icons.calendar_today_rounded, value: '${teacher['lessons'] ?? 0}/h'),
          ]),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _Stat({required this.icon, required this.value, this.color = kTextSecondary});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 4),
      Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
    ]);
  }
}
