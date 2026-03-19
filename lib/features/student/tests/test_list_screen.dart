import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/badge_widget.dart';
import '../../../core/api/student_api.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({super.key});
  @override
  State<TestListScreen> createState() => _State();
}

class _State extends State<TestListScreen> {
  String? _selectedBook;
  final _books = [
    {'id': null, 'title': 'Barchasi'},
    {'id': '1', 'title': 'Algebra'},
    {'id': '2', 'title': 'Geometriya'},
    {'id': '3', 'title': 'Fizika'},
    {'id': '4', 'title': 'Ingliz tili'},
  ];
  List _tests = [
    {'id': '1', 'title': 'Algebra — Funksiyalar', 'questions': 20, 'time_limit': 30, 'difficulty': 'medium'},
    {'id': '2', 'title': 'Algebra — Tenglamalar', 'questions': 15, 'time_limit': 20, 'difficulty': 'easy'},
    {'id': '3', 'title': 'Fizika — Mexanika', 'questions': 25, 'time_limit': 40, 'difficulty': 'hard'},
    {'id': '4', 'title': 'Ingliz tili — Grammar', 'questions': 30, 'time_limit': 45, 'difficulty': 'medium'},
    {'id': '5', 'title': 'Geometriya — Uchburchaklar', 'questions': 18, 'time_limit': 25, 'difficulty': 'hard'},
    {'id': '6', 'title': 'Algebra — Logarifmlar', 'questions': 20, 'time_limit': 30, 'difficulty': 'hard'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final t = await studentApi.getTestCatalog(bookId: _selectedBook);
      if (mounted && t.isNotEmpty) setState(() => _tests = t.cast<Map>());
    } catch (_) {}
  }

  Color _diffColor(String d) => d == 'hard' ? kRed : d == 'medium' ? kYellow : kGreen;
  String _diffLabel(String d) => d == 'hard' ? "Qiyin" : d == 'medium' ? "O'rta" : "Oson";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text('Testlar', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            // Book filter chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _books.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final b = _books[i];
                  final active = _selectedBook == b['id'];
                  return GestureDetector(
                    onTap: () { setState(() => _selectedBook = b['id'] as String?); _load(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? kOrange : kBgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? kOrange : kBgBorder),
                      ),
                      child: Text(b['title'] as String, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: _tests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final t = _tests[i];
                  final diff = t['difficulty'] as String? ?? 'medium';
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(child: Text(t['title'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
                        BadgeWidget(text: _diffLabel(diff), color: _diffColor(diff)),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Icon(Icons.help_outline_rounded, color: kTextMuted, size: 14),
                        const SizedBox(width: 4),
                        Text('${t['questions']} savol', style: const TextStyle(color: kTextMuted, fontSize: 12)),
                        const SizedBox(width: 16),
                        Icon(Icons.timer_outlined, color: kTextMuted, size: 14),
                        const SizedBox(width: 4),
                        Text('${t['time_limit']} daq', style: const TextStyle(color: kTextMuted, fontSize: 12)),
                      ]),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/student/tests/${t['id']}/play'),
                          child: const Text('Boshlash'),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
