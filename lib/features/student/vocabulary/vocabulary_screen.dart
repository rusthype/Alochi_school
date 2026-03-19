import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';
import '../../../core/api/student_api.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});
  @override
  State<VocabularyScreen> createState() => _State();
}

class _State extends State<VocabularyScreen> {
  String _mode = 'topics'; // 'topics' | 'flashcard'
  String? _selectedBook;
  Map? _selectedTopic;
  int _cardIndex = 0;
  bool _showAnswer = false;

  final _books = [
    {'id': null, 'title': 'Barchasi'},
    {'id': '1', 'title': 'Ingliz tili'},
    {'id': '2', 'title': 'Rus tili'},
  ];

  final _topics = [
    {'id': '1', 'title': "Meva-sabzavotlar", 'word_count': 20, 'progress': 0.7},
    {'id': '2', 'title': 'Hayvonlar', 'word_count': 15, 'progress': 0.4},
    {'id': '3', 'title': 'Transport', 'word_count': 18, 'progress': 0.2},
    {'id': '4', 'title': "Kasb-hunarlar", 'word_count': 12, 'progress': 0.0},
  ];

  final _words = [
    {'en': 'apple', 'uz': 'olma', 'ru': 'яблоко'},
    {'en': 'banana', 'uz': 'banan', 'ru': 'банан'},
    {'en': 'orange', 'uz': 'apelsin', 'ru': 'апельсин'},
    {'en': 'grape', 'uz': 'uzum', 'ru': 'виноград'},
    {'en': 'watermelon', 'uz': 'tarvuz', 'ru': 'арбуз'},
  ];

  List _currentWords = [];

  void _openTopic(Map topic) {
    _currentWords = List.from(_words);
    setState(() {
      _selectedTopic = topic;
      _cardIndex = 0;
      _showAnswer = false;
      _mode = 'flashcard';
    });
    // try real API
    studentApi.getVocabularyWords(topic['id']?.toString() ?? '').then((w) {
      if (mounted && w.isNotEmpty) setState(() => _currentWords = w.cast<Map>());
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: _mode == 'topics' ? _buildTopics() : _buildFlashcard(),
      ),
    );
  }

  Widget _buildTopics() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Text("Lug'at", style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _books.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final b = _books[i];
            final active = _selectedBook == b['id']?.toString();
            return GestureDetector(
              onTap: () => setState(() => _selectedBook = b['id']?.toString()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? kOrange : kBgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? kOrange : kBgBorder),
                ),
                child: Text(b['title'] as String, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontSize: 13)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 16),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.1, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: _topics.length,
          itemBuilder: (_, i) {
            final t = _topics[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['title'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("${t['word_count']} so'z", style: const TextStyle(color: kTextMuted, fontSize: 11)),
                const Spacer(),
                LinearProgressIndicator(
                  value: t['progress'] as double,
                  backgroundColor: kBgBorder,
                  valueColor: const AlwaysStoppedAnimation(kOrange),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 4,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6)),
                    onPressed: () => _openTopic(t),
                    child: const Text('Boshlash', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    ],
  );

  Widget _buildFlashcard() {
    final total = _currentWords.length;
    if (total == 0) return const Center(child: CircularProgressIndicator(color: kOrange));
    final word = _currentWords[_cardIndex] as Map;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(children: [
            GestureDetector(
              onTap: () => setState(() { _mode = 'topics'; _selectedTopic = null; }),
              child: const Icon(Icons.arrow_back_rounded, color: kTextPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(_selectedTopic?['title'] as String? ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600))),
            Text('${_cardIndex + 1} / $total', style: const TextStyle(color: kTextMuted, fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 24),

        // Flashcard
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () => setState(() => _showAnswer = !_showAnswer),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kBgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _showAnswer ? kOrange : kBgBorder, width: _showAnswer ? 2 : 1),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (!_showAnswer) ...[
                  Text(word['en'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text("Bosish uchun tarjima", style: TextStyle(color: kTextMuted, fontSize: 13)),
                ] else ...[
                  Text(word['en'] as String, style: const TextStyle(color: kOrange, fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(word['uz'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(word['ru'] as String, style: const TextStyle(color: kTextSecondary, fontSize: 18)),
                ],
              ]),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Navigation
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            onPressed: _cardIndex > 0 ? () => setState(() { _cardIndex--; _showAnswer = false; }) : null,
            icon: const Icon(Icons.arrow_back_rounded, color: kOrange),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () => setState(() => _showAnswer = !_showAnswer),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: kOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: kOrange.withOpacity(0.3))),
              child: Text(_showAnswer ? "Yashirish" : "Ko'rish", style: const TextStyle(color: kOrange, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            onPressed: _cardIndex < total - 1 ? () => setState(() { _cardIndex++; _showAnswer = false; }) : null,
            icon: const Icon(Icons.arrow_forward_rounded, color: kOrange),
          ),
        ]),
      ],
    );
  }
}
