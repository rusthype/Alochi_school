import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../core/api/school_api.dart';
import '../../core/utils/score_color.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _data = {};

  // Mock data fallback
  final _mockStats = {'students': 847, 'teachers': 9, 'avg_score': 76.3, 'attendance': 93};
  final _mockWeekly = [62, 74, 68, 81, 77, 85, 71];
  final _mockTopStudents = [
    {'name': 'Karimova Nargiza', 'class': '11-A', 'score': 96.4, 'attendance': 98},
    {'name': 'Toshmatov Behruz', 'class': '10-B', 'score': 94.1, 'attendance': 100},
    {'name': 'Yusupova Malika', 'class': '11-A', 'score': 92.8, 'attendance': 97},
    {'name': 'Nazarov Sardor', 'class': '9-A', 'score': 91.5, 'attendance': 95},
    {'name': 'Alimova Zulfiya', 'class': '10-A', 'score': 90.2, 'attendance': 99},
  ];
  final _mockWarnings = [
    {'text': '1-C sinfida o\'rtacha baho 46.5 ga tushdi', 'time': '2 soat oldin'},
    {'text': 'Toshmatova Gulnora davomat 58%', 'time': 'Bugun'},
    {'text': 'Ergashev Jasur attestatsiya topshirmadi', 'time': 'Kecha'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await schoolApi.getDashboard();
      if (mounted) setState(() => _data = data);
    } catch (_) {
      // keep mock data on error
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _data['stats'] ?? _mockStats;
    final weekly = (_data['weekly'] as List?)?.cast<num>() ?? _mockWeekly;
    final topStudents = (_data['top_students'] as List?) ?? _mockTopStudents;
    final warnings = (_data['ai_warnings'] as List?) ?? _mockWarnings;

    return Scaffold(
      backgroundColor: kBgMain,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Dashboard', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('So\'nggi yangilanish: bugun', style: const TextStyle(color: kTextSecondary, fontSize: 14)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: kBgBorder)),
                  child: Row(
                    children: const [
                      Icon(Icons.refresh_rounded, color: kTextMuted, size: 16),
                      SizedBox(width: 6),
                      Text('Yangilash', style: TextStyle(color: kTextSecondary, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats grid
            LayoutBuilder(builder: (context, c) {
              final cols = c.maxWidth > 600 ? 4 : 2;
              return GridView.count(
                crossAxisCount: cols,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: cols == 4 ? 1.4 : 1.3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(icon: Icons.people_rounded, iconColor: kBlue, iconBg: kBlue.withOpacity(0.12), value: '${stats['students'] ?? 0}', label: "Jami o'quvchilar"),
                  StatCard(icon: Icons.school_rounded, iconColor: kGreen, iconBg: kGreen.withOpacity(0.12), value: '${stats['teachers'] ?? 0}', label: "Jami o'qituvchilar"),
                  StatCard(icon: Icons.bar_chart_rounded, iconColor: kOrange, iconBg: kOrange.withOpacity(0.12), value: '${stats['avg_score'] ?? 0}', label: "O'rtacha baho", trend: 2.1),
                  StatCard(icon: Icons.how_to_reg_rounded, iconColor: kPurple, iconBg: kPurple.withOpacity(0.12), value: '${stats['attendance'] ?? 0}%', label: 'Davomat', trend: -0.5),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Charts row
            LayoutBuilder(builder: (context, c) {
              if (c.maxWidth > 700) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _WeeklyChart(data: weekly)),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: _AIWarningsCard(warnings: warnings)),
                  ],
                );
              }
              return Column(children: [
                _WeeklyChart(data: weekly),
                const SizedBox(height: 16),
                _AIWarningsCard(warnings: warnings),
              ]);
            }),
            const SizedBox(height: 24),

            // Top students
            _TopStudentsCard(students: topStudents),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<num> data;
  const _WeeklyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    const days = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sha', 'Ya'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Haftalik faollik', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                backgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(color: kBgBorder, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= days.length) return const SizedBox();
                        return Text(days[i], style: const TextStyle(color: kTextMuted, fontSize: 11));
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].toDouble(),
                        color: kOrange,
                        width: 14,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: kBgBorder,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AIWarningsCard extends StatelessWidget {
  final List warnings;
  const _AIWarningsCard({required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.psychology_rounded, color: kOrange, size: 18),
            const SizedBox(width: 8),
            const Text('AI Ogohlantirishlar', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 16),
          ...warnings.take(5).map((w) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: kRed, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w['text'] ?? '', style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                      Text(w['time'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TopStudentsCard extends StatelessWidget {
  final List students;
  const _TopStudentsCard({required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top O'quvchilar", style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...List.generate(students.take(5).length, (i) {
            final s = students[i] as Map;
            final score = (s['score'] ?? s['avg_score'] ?? 0).toDouble();
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kBgMain, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: kOrange.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('${i + 1}', style: const TextStyle(color: kOrange, fontSize: 13, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(width: 12),
                  AvatarWidget(name: s['name'] ?? '', size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['name'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(s['class'] ?? s['grade'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Text(score.toStringAsFixed(1), style: TextStyle(color: scoreColor(score), fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
