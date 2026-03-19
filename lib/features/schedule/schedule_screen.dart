import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../core/utils/avatar_color.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedClass = '11-A';
  final _classes = ['11-A', '11-B', '10-A', '10-B', '9-A', '9-B', '8-A', '8-B'];

  final _days = ['Dushanba', 'Seshanba', 'Chorshanba', 'Payshanba', 'Juma', 'Shanba'];
  final _times = ['08:00–08:45', '08:55–09:40', '09:50–10:35', '10:45–11:30', '11:40–12:25', '13:00–13:45'];

  // Mock timetable data
  final _mockSchedule = {
    '0-0': {'subject': 'Matematika', 'teacher': 'Karimova N.'},
    '0-1': {'subject': 'Fizika', 'teacher': 'Botirov S.'},
    '0-2': {'subject': 'Ingliz', 'teacher': 'Nazarova M.'},
    '0-3': {'subject': 'Tarix', 'teacher': 'Yusupov A.'},
    '1-0': {'subject': 'Ona tili', 'teacher': 'Toshmatova G.'},
    '1-1': {'subject': 'Matematika', 'teacher': 'Karimova N.'},
    '1-3': {'subject': 'Kimyo', 'teacher': 'Alimova Z.'},
    '2-0': {'subject': 'Fizika', 'teacher': 'Botirov S.'},
    '2-2': {'subject': 'Matematika', 'teacher': 'Karimova N.'},
    '2-4': {'subject': 'Ingliz', 'teacher': 'Nazarova M.'},
    '3-1': {'subject': 'Kimyo', 'teacher': 'Alimova Z.'},
    '3-2': {'subject': 'Ona tili', 'teacher': 'Toshmatova G.'},
    '3-5': {'subject': 'Tarix', 'teacher': 'Yusupov A.'},
    '4-0': {'subject': 'Matematika', 'teacher': 'Karimova N.'},
    '4-3': {'subject': 'Fizika', 'teacher': 'Botirov S.'},
    '5-1': {'subject': 'Ingliz', 'teacher': 'Nazarova M.'},
    '5-4': {'subject': 'Ona tili', 'teacher': 'Toshmatova G.'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('Dars Jadvali', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: _selectedClass,
                dropdownColor: kBgCard,
                style: const TextStyle(color: kTextPrimary),
                underline: const SizedBox(),
                items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedClass = v!),
              ),
            ]),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(color: kBgBorder, width: 1),
                      defaultColumnWidth: const FixedColumnWidth(140),
                      children: [
                        // Header row
                        TableRow(
                          decoration: const BoxDecoration(color: kBgSidebar),
                          children: [
                            const _HeaderCell('Vaqt'),
                            ..._days.map((d) => _HeaderCell(d)),
                          ],
                        ),
                        // Time slot rows
                        ...List.generate(_times.length, (row) {
                          return TableRow(children: [
                            _TimeCell(_times[row]),
                            ...List.generate(_days.length, (col) {
                              final key = '$col-$row';
                              final lesson = _mockSchedule[key];
                              return lesson != null ? _LessonCell(lesson) : const _EmptyCell();
                            }),
                          ]);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Text(text, style: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w700)),
  );
}

class _TimeCell extends StatelessWidget {
  final String time;
  const _TimeCell(this.time);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Text(time, style: const TextStyle(color: kTextMuted, fontSize: 11)),
  );
}

class _LessonCell extends StatelessWidget {
  final Map lesson;
  const _LessonCell(this.lesson);
  @override
  Widget build(BuildContext context) {
    final color = avatarColor(lesson['subject'] ?? '');
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(lesson['subject'] ?? '', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        Text(lesson['teacher'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
      ]),
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 52);
}
