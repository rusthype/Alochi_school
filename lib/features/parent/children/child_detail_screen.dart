import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../core/api/parent_api.dart';
import '../../../core/utils/score_color.dart';

class ChildDetailScreen extends StatefulWidget {
  final String id;
  const ChildDetailScreen({super.key, required this.id});
  @override
  State<ChildDetailScreen> createState() => _State();
}

class _State extends State<ChildDetailScreen> {
  Map _child = {'name': 'Karimov Sarvar', 'grade': '9-A', 'school': '1-maktab', 'avg_score': 82.0, 'tests_count': 47, 'attendance_pct': 94.0, 'streak': 5};
  List _results = [
    {'title': 'Algebra sinovi', 'score': 88, 'date': '2026-03-18', 'subject': 'Matematika'},
    {'title': 'Ingliz tili testi', 'score': 72, 'date': '2026-03-17', 'subject': 'Ingliz tili'},
    {'title': 'Fizika amaliyoti', 'score': 95, 'date': '2026-03-15', 'subject': 'Fizika'},
    {'title': 'Kimyo testi', 'score': 65, 'date': '2026-03-14', 'subject': 'Kimyo'},
    {'title': 'Tarix sinovi', 'score': 79, 'date': '2026-03-12', 'subject': 'Tarix'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await parentApi.getChildDetail(widget.id);
      final r = await parentApi.getChildResults(widget.id);
      if (mounted) setState(() {
        _child = d;
        if (r.isNotEmpty) _results = r.cast<Map>();
      });
    } catch (_) {}
  }

  Color _subjectColor(String s) {
    switch (s) {
      case 'Matematika': return kBlue;
      case 'Fizika': return kOrange;
      case 'Kimyo': return kGreen;
      case 'Tarix': return kYellow;
      default: return kTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avg = (_child['avg_score'] as num?)?.toDouble() ?? 0;
    final tests = _child['tests_count'] ?? 0;
    final attendance = (_child['attendance_pct'] as num?)?.toDouble() ?? 0;

    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        backgroundColor: kBgSidebar,
        foregroundColor: kTextPrimary,
        elevation: 0,
        title: Row(children: [
          AvatarWidget(name: _child['name'] as String? ?? '', size: 32),
          const SizedBox(width: 10),
          Text(_child['name'] as String? ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(children: [
              _StatBox(label: "O'rtacha", value: "${avg.toStringAsFixed(1)}%", color: scoreColor(avg)),
              const SizedBox(width: 10),
              _StatBox(label: 'Davomat', value: "${attendance.toStringAsFixed(0)}%", color: kGreen),
              const SizedBox(width: 10),
              _StatBox(label: 'Testlar', value: '$tests', color: kBlue),
            ]),
            const SizedBox(height: 24),

            // Attendance card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Davomat', style: TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.how_to_reg_rounded, color: kGreen, size: 18),
                  const SizedBox(width: 8),
                  Text('${attendance.toStringAsFixed(0)}% davomat', style: const TextStyle(color: kGreen, fontSize: 14, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: attendance / 100,
                  backgroundColor: kBgBorder,
                  valueColor: const AlwaysStoppedAnimation(kGreen),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Results
            const Text("So'nggi natijalar", style: TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ..._results.map((r) {
              final score = (r['score'] as num?)?.toInt() ?? 0;
              final color = scoreColor(score);
              final subjectColor = _subjectColor(r['subject'] as String? ?? '');
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBgBorder)),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: subjectColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(r['subject'] as String? ?? '', style: TextStyle(color: subjectColor, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r['title'] as String? ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text(r['date'] as String? ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text('$score%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
      ]),
    ),
  );
}
