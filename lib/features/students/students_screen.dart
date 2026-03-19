import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/badge_widget.dart';
import '../../core/api/school_api.dart';
import '../../core/utils/score_color.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List _all = [];
  bool _loading = true;
  String _selectedClass = 'Hammasi';
  final _searchCtrl = TextEditingController();
  int _page = 0;
  static const _perPage = 20;

  final _mockStudents = List.generate(45, (i) => {
    'id': i + 1,
    'name': ['Karimova Nargiza', 'Toshmatov Behruz', 'Yusupova Malika', 'Nazarov Sardor', 'Alimova Zulfiya',
              'Rahimov Bobur', 'Hasanova Lobar', 'Ergashev Jasur', 'Botirov Sardor', 'Mirzayev Azizbek'][i % 10],
    'class': ['11-A', '11-B', '10-A', '10-B', '9-A', '9-B', '8-A', '1-C'][i % 8],
    'math': 60 + (i * 7) % 40,
    'english': 55 + (i * 11) % 45,
    'avg': 58.0 + (i * 4.1) % 38,
    'attendance': 75 + (i * 3) % 25,
    'xp': 1200 + i * 150,
  });

  List<String> get _classes {
    final all = {'Hammasi'};
    for (final s in _all) { all.add(s['class'] ?? s['grade'] ?? ''); }
    return all.toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await schoolApi.getStudents();
      if (mounted) setState(() { _all = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _all = _mockStudents; _loading = false; });
    }
  }

  List get _filtered {
    var list = _all;
    if (_selectedClass != 'Hammasi') list = list.where((s) => (s['class'] ?? s['grade']) == _selectedClass).toList();
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty) list = list.where((s) => (s['name'] ?? '').toString().toLowerCase().contains(q)).toList();
    return list;
  }

  List get _paged {
    final f = _filtered;
    final start = _page * _perPage;
    return f.skip(start).take(_perPage).toList();
  }

  String _statusLabel(Map s) {
    final avg = (s['avg'] ?? 0).toDouble();
    if (avg >= 86) return 'A\'lo';
    if (avg >= 71) return 'Yaxshi';
    return 'Zaif';
  }

  Color _statusColor(Map s) {
    final avg = (s['avg'] ?? 0).toDouble();
    if (avg >= 86) return kGreen;
    if (avg >= 71) return kYellow;
    return kRed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("O'quvchilar", style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Jami: ${_all.length} ta", style: const TextStyle(color: kTextSecondary, fontSize: 14)),
              ]),
            ]),
            const SizedBox(height: 20),

            // Search + class filter
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() => _page = 0),
                  style: const TextStyle(color: kTextPrimary),
                  decoration: const InputDecoration(
                    hintText: "Ism yoki sinf bo'yicha qidirish...",
                    prefixIcon: Icon(Icons.search_rounded, color: kTextMuted, size: 20),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            // Class filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _classes.map((cls) {
                  final active = _selectedClass == cls;
                  return GestureDetector(
                    onTap: () => setState(() { _selectedClass = cls; _page = 0; }),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? kOrange : kBgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? kOrange : kBgBorder),
                      ),
                      child: Text(cls, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontSize: 13)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Table
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kOrange))
                  : Container(
                      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
                      child: DataTable2(
                        headingRowColor: WidgetStateProperty.all(kBgSidebar),
                        dataRowColor: WidgetStateProperty.all(Colors.transparent),
                        dividerThickness: 1,
                        headingTextStyle: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w700),
                        dataTextStyle: const TextStyle(color: kTextSecondary, fontSize: 13),
                        border: TableBorder(horizontalInside: BorderSide(color: kBgBorder, width: 1)),
                        columns: const [
                          DataColumn2(label: Text('#'), size: ColumnSize.S),
                          DataColumn2(label: Text('ISM FAMILIYA'), size: ColumnSize.L),
                          DataColumn2(label: Text('SINF'), size: ColumnSize.S),
                          DataColumn2(label: Text('MATH'), size: ColumnSize.S, numeric: true),
                          DataColumn2(label: Text("O'RT"), size: ColumnSize.S, numeric: true),
                          DataColumn2(label: Text('DAV'), size: ColumnSize.S, numeric: true),
                          DataColumn2(label: Text('HOLAT'), size: ColumnSize.S),
                        ],
                        rows: List.generate(_paged.length, (i) {
                          final s = _paged[i] as Map;
                          final avg = (s['avg'] ?? 0).toDouble();
                          final math = (s['math'] ?? 0).toDouble();
                          final att = (s['attendance'] ?? 0).toDouble();
                          return DataRow2(
                            cells: [
                              DataCell(Text('${_page * _perPage + i + 1}')),
                              DataCell(Row(children: [
                                AvatarWidget(name: s['name'] ?? '', size: 30),
                                const SizedBox(width: 10),
                                Expanded(child: Text(s['name'] ?? '', style: const TextStyle(color: kTextPrimary), overflow: TextOverflow.ellipsis)),
                              ])),
                              DataCell(Text(s['class'] ?? s['grade'] ?? '')),
                              DataCell(Text(math.toStringAsFixed(1), style: TextStyle(color: scoreColor(math)))),
                              DataCell(Text(avg.toStringAsFixed(1), style: TextStyle(color: scoreColor(avg), fontWeight: FontWeight.w600))),
                              DataCell(Text('${att.toStringAsFixed(0)}%', style: TextStyle(color: scoreColor(att)))),
                              DataCell(BadgeWidget(text: _statusLabel(s), color: _statusColor(s))),
                            ],
                          );
                        }),
                      ),
                    ),
            ),

            // Pagination
            if (!_loading) Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${_page * _perPage + 1}–${(_page * _perPage + _paged.length)} / ${_filtered.length} ta', style: const TextStyle(color: kTextMuted, fontSize: 13)),
                Row(children: [
                  IconButton(
                    onPressed: _page > 0 ? () => setState(() => _page--) : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: _page > 0 ? kTextSecondary : kTextMuted,
                  ),
                  IconButton(
                    onPressed: (_page + 1) * _perPage < _filtered.length ? () => setState(() => _page++) : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: (_page + 1) * _perPage < _filtered.length ? kTextSecondary : kTextMuted,
                  ),
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
