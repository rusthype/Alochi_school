import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/colors.dart';
import '../../../core/api/student_api.dart';

class TestPlayScreen extends StatefulWidget {
  final String id;
  const TestPlayScreen({super.key, required this.id});
  @override
  State<TestPlayScreen> createState() => _State();
}

class _State extends State<TestPlayScreen> {
  Map _test = {};
  List _questions = [];
  Map<int, int> _answers = {};
  int _currentPage = 0;
  bool _submitting = false;
  Timer? _timer;
  int _secondsLeft = 30 * 60;
  late PageController _pageCtrl;

  static final _mockTest = {
    'id': '1',
    'title': 'Algebra — Funksiyalar',
    'time_limit': 30,
    'questions': [
      {'id': 1, 'text': "f(x) = 2x + 3 bo'lganda f(5) = ?", 'options': ['A) 10', 'B) 13', 'C) 15', 'D) 8'], 'correct': 1},
      {'id': 2, 'text': "Kvadrat tenglamaning discriminanti D = b² − 4ac. a=1, b=4, c=3 bo'lsa D=?", 'options': ['A) 4', 'B) 16', 'C) −8', 'D) 28'], 'correct': 0},
      {'id': 3, 'text': 'sin(90°) = ?', 'options': ['A) 0', 'B) 0.5', 'C) 1', 'D) −1'], 'correct': 2},
      {'id': 4, 'text': '2^10 = ?', 'options': ['A) 512', 'B) 1024', 'C) 2048', 'D) 256'], 'correct': 1},
      {'id': 5, 'text': 'log₂(8) = ?', 'options': ['A) 2', 'B) 4', 'C) 3', 'D) 6'], 'correct': 2},
    ],
  };

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final t = await studentApi.getTest(widget.id);
      if (mounted) _setTest(t);
    } catch (_) {
      if (mounted) _setTest(_mockTest);
    }
  }

  void _setTest(Map t) {
    setState(() {
      _test = t;
      _questions = (t['questions'] as List?) ?? [];
      _secondsLeft = ((t['time_limit'] as num?) ?? 30).toInt() * 60;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        _submit();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _timerText {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    _timer?.cancel();
    try {
      await studentApi.submitTest(widget.id, {'answers': _answers});
    } catch (_) {}
    if (mounted) context.go('/student/tests/${widget.id}/result');
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final title = _test['title'] as String? ?? 'Test';
    final timerColor = _secondsLeft < 60 ? kRed : kTextSecondary;

    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        backgroundColor: kBgSidebar,
        foregroundColor: kTextPrimary,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: timerColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.timer_outlined, color: timerColor, size: 14),
                  const SizedBox(width: 4),
                  Text(_timerText, style: TextStyle(color: timerColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),
        ],
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator(color: kOrange))
          : Column(
              children: [
                // Progress bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Savol ${_currentPage + 1} / $total', style: const TextStyle(color: kTextSecondary, fontSize: 13)),
                      Text('${_answers.length} javob berildi', style: const TextStyle(color: kTextMuted, fontSize: 12)),
                    ]),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: ((_currentPage + 1) / total).clamp(0.0, 1.0),
                      backgroundColor: kBgBorder,
                      valueColor: const AlwaysStoppedAnimation(kOrange),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 4,
                    ),
                  ]),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: total,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) {
                      final q = _questions[i] as Map;
                      final qId = q['id'] as int;
                      final opts = (q['options'] as List).cast<String>();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
                              child: Text(q['text'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 16, height: 1.5)),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(opts.length, (j) {
                              final selected = _answers[qId] == j;
                              return GestureDetector(
                                onTap: () => setState(() => _answers[qId] = j),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: selected ? kOrange : kBgCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: selected ? kOrange : kBgBorder),
                                  ),
                                  child: Text(opts[j], style: TextStyle(color: selected ? Colors.white : kTextPrimary, fontSize: 14)),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom nav
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    if (_currentPage > 0)
                      OutlinedButton(
                        onPressed: () {
                          _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        child: const Text('Orqaga'),
                      ),
                    const Spacer(),
                    if (_currentPage < total - 1)
                      ElevatedButton(
                        onPressed: () {
                          _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        child: const Text('Keyingi'),
                      )
                    else
                      ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Yuborish'),
                      ),
                  ]),
                ),
              ],
            ),
    );
  }
}
