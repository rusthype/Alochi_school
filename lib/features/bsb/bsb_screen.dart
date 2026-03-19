import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../shared/constants/colors.dart';
import '../../core/api/school_api.dart';
import '../../core/utils/score_color.dart';

class BsbScreen extends StatefulWidget {
  const BsbScreen({super.key});
  @override
  State<BsbScreen> createState() => _BsbScreenState();
}

class _BsbScreenState extends State<BsbScreen> {
  List _results = [];
  bool _loading = true;

  final _mock = [
    {'class': '11-A', 'date': '15 mart 2026', 'subject': 'Matematika', 'avg': 84.2, 'max': 98, 'min': 61, 'status': 'Yaxshi'},
    {'class': '11-B', 'date': '15 mart 2026', 'subject': 'Matematika', 'avg': 71.5, 'max': 92, 'min': 48, 'status': "O'rta"},
    {'class': '10-A', 'date': '14 mart 2026', 'subject': 'Fizika', 'avg': 78.3, 'max': 95, 'min': 52, 'status': 'Yaxshi'},
    {'class': '9-B', 'date': '14 mart 2026', 'subject': 'Ingliz tili', 'avg': 67.1, 'max': 88, 'min': 40, 'status': "O'rta"},
    {'class': '1-C', 'date': '13 mart 2026', 'subject': 'Ona tili', 'avg': 46.5, 'max': 72, 'min': 18, 'status': 'Zaif'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await schoolApi.getBsbStats();
      if (mounted) setState(() {
        _results = (data['results'] as List?) ?? _mock;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() { _results = _mock; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final conducted = _results.length;
    final avgAll = _results.isEmpty ? 0.0 : _results.map((r) => (r['avg'] ?? 0) as num).fold(0.0, (a, b) => a + b) / _results.length;

    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BSB / ChSB', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Stats
            Row(children: [
              _StatChip(label: 'BSB o\'tkazildi', value: '$conducted', color: kGreen),
              const SizedBox(width: 12),
              _StatChip(label: "O'rtacha natija", value: avgAll.toStringAsFixed(1), color: kOrange),
              const SizedBox(width: 12),
              _StatChip(label: 'Zaif sinflar', value: '${_results.where((r) => (r['avg'] ?? 0) < 60).length}', color: kRed),
            ]),
            const SizedBox(height: 20),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kOrange))
                  : Container(
                      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
                      child: DataTable2(
                        headingRowColor: WidgetStateProperty.all(kBgSidebar),
                        dividerThickness: 1,
                        headingTextStyle: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w700),
                        dataTextStyle: const TextStyle(color: kTextSecondary, fontSize: 13),
                        border: TableBorder(horizontalInside: BorderSide(color: kBgBorder)),
                        columns: const [
                          DataColumn2(label: Text('SINF'), size: ColumnSize.S),
                          DataColumn2(label: Text('SANA')),
                          DataColumn2(label: Text('FAN')),
                          DataColumn2(label: Text("O'RTACHA"), numeric: true),
                          DataColumn2(label: Text('MAX'), size: ColumnSize.S, numeric: true),
                          DataColumn2(label: Text('MIN'), size: ColumnSize.S, numeric: true),
                          DataColumn2(label: Text('HOLAT'), size: ColumnSize.S),
                        ],
                        rows: _results.map((r) {
                          final avg = (r['avg'] ?? 0).toDouble();
                          return DataRow2(cells: [
                            DataCell(Text(r['class'] ?? '', style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600))),
                            DataCell(Text(r['date'] ?? '')),
                            DataCell(Text(r['subject'] ?? '')),
                            DataCell(Text(avg.toStringAsFixed(1), style: TextStyle(color: scoreColor(avg), fontWeight: FontWeight.bold))),
                            DataCell(Text('${r['max'] ?? 0}', style: const TextStyle(color: kGreen))),
                            DataCell(Text('${r['min'] ?? 0}', style: const TextStyle(color: kRed))),
                            DataCell(Container(width: 12, height: 12, decoration: BoxDecoration(color: scoreColor(avg), shape: BoxShape.circle))),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
      ]),
    );
  }
}
