import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';
import '../../../core/utils/score_color.dart';

class TestResultScreen extends StatelessWidget {
  final String id;
  const TestResultScreen({super.key, required this.id});

  static const _mock = {
    'score': 80,
    'correct': 4,
    'wrong': 1,
    'skipped': 0,
    'xp_earned': 40,
    'coins_earned': 20,
    'total': 5,
  };

  @override
  Widget build(BuildContext context) {
    const result = _mock;
    final score = (result['score'] as num).toDouble();
    final color = scoreColor(score);

    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        backgroundColor: kBgSidebar,
        foregroundColor: kTextPrimary,
        elevation: 0,
        title: const Text('Natija'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Score circle
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(value: score, color: color, radius: 60, title: ''),
                          PieChartSectionData(value: 100 - score, color: kBgBorder, radius: 60, title: ''),
                        ],
                        centerSpaceRadius: 50,
                        sectionsSpace: 2,
                      ),
                    ),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('${score.toInt()}%', style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
                      const Text('Ball', style: TextStyle(color: kTextMuted, fontSize: 13)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _StatBox(label: 'To\'g\'ri', value: '${result['correct']}', color: kGreen),
              const SizedBox(width: 12),
              _StatBox(label: 'Noto\'g\'ri', value: '${result['wrong']}', color: kRed),
              const SizedBox(width: 12),
              _StatBox(label: 'O\'tkazib', value: '${result['skipped']}', color: kYellow),
            ]),
            const SizedBox(height: 20),

            // Rewards
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.auto_awesome_rounded, color: kOrange, size: 20),
                const SizedBox(width: 6),
                Text('+${result['xp_earned']} XP', style: const TextStyle(color: kOrange, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 24),
                const Icon(Icons.monetization_on_rounded, color: kYellow, size: 20),
                const SizedBox(width: 6),
                Text('+${result['coins_earned']} Coin', style: const TextStyle(color: kYellow, fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/student/tests/$id/play'),
                  child: const Text("Qayta ishlash"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.go('/student/dashboard'),
                  child: const Text("Bosh sahifaga"),
                ),
              ),
            ]),
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
  Widget build(BuildContext context) => Container(
    width: 90,
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
    child: Column(children: [
      Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
    ]),
  );
}
