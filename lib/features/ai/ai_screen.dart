import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/badge_widget.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI Tahlil', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Sun'iy intellekt asosida maktab tahlili", style: TextStyle(color: kTextSecondary, fontSize: 14)),
            const SizedBox(height: 24),

            // Insights grid
            LayoutBuilder(builder: (_, c) {
              final cols = c.maxWidth > 600 ? 2 : 1;
              return GridView.count(
                crossAxisCount: cols,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: cols == 2 ? 2.2 : 2.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _InsightCard(icon: Icons.trending_up_rounded, color: kGreen, value: '+4.2%', label: 'Bu oylik o\'sish'),
                  _InsightCard(icon: Icons.people_rounded, color: kBlue, value: '93.5%', label: 'O\'rtacha davomat'),
                  _InsightCard(icon: Icons.warning_amber_rounded, color: kRed, value: '146', label: 'Xavf ostidagi o\'quvchilar'),
                  _InsightCard(icon: Icons.emoji_events_rounded, color: kYellow, value: '4-A', label: "Eng yaxshi sinf (84.5 o'rt)"),
                ],
              );
            }),
            const SizedBox(height: 28),

            // Warnings
            const Text('AI Ogohlantirishlar', style: TextStyle(color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ..._warnings.map((w) => _WarningCard(warning: w)),
            const SizedBox(height: 28),

            // Recommendations
            const Text('AI Tavsiyalar', style: TextStyle(color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ..._recommendations.map((r) => _RecommendCard(rec: r)),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _InsightCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 12)),
        ])),
      ]),
    );
  }
}

const _warnings = [
  {'name': 'Toshmatova Gulnora', 'desc': "O'rtacha baho 52 — minimumdan past", 'detail': 'Matematika · 1-C, 1-B', 'severity': 'Yuqori'},
  {'name': 'Ergashev Jasur', 'desc': 'Attestatsiya topshirilmagan, 0 dars/hafta', 'detail': 'Psixolog', 'severity': "O'rta"},
  {'name': '1-C sinfi', 'desc': "O'rtacha baho 46.5 — eng past", 'detail': "O'rtacha: 46.5", 'severity': "O'rta"},
];

const _recommendations = [
  {'title': 'Toshmatova Gulnora uchun mentorlik boshlang', 'desc': 'Karimova Nargizani mentor tayinlang', 'icon': 'bolt'},
  {'title': '1-C sinfiga qo\'shimcha darslar', 'desc': 'Haftasiga 2 ta qo\'shimcha dars', 'icon': 'bolt'},
  {'title': 'Ergashev Jasur bilan attestatsiya muddatini belgilang', 'desc': 'Muddat: 2 hafta', 'icon': 'bolt'},
];

class _WarningCard extends StatelessWidget {
  final Map warning;
  const _WarningCard({required this.warning});

  @override
  Widget build(BuildContext context) {
    final isHigh = warning['severity'] == 'Yuqori';
    final color = isHigh ? kRed : kYellow;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(isHigh ? Icons.error_rounded : Icons.warning_amber_rounded, color: color, size: 18)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(warning['name'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
            BadgeWidget(text: warning['severity'] ?? '', color: color, fontSize: 11),
          ]),
          const SizedBox(height: 4),
          Text(warning['desc'] ?? '', style: const TextStyle(color: kTextSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(warning['detail'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 12)),
        ])),
      ]),
    );
  }
}

class _RecommendCard extends StatelessWidget {
  final Map rec;
  const _RecommendCard({required this.rec});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: kPurple.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.bolt_rounded, color: kPurple, size: 18)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(rec['title'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(rec['desc'] ?? '', style: const TextStyle(color: kTextSecondary, fontSize: 13)),
        ])),
        const Icon(Icons.arrow_forward_ios_rounded, color: kTextMuted, size: 14),
      ]),
    );
  }
}
