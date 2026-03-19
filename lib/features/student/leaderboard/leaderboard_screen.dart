import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../core/api/student_api.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _State();
}

class _State extends State<LeaderboardScreen> {
  String _scope = 'global';
  final _scopes = [('global', 'Global'), ('city', 'Shahar'), ('school', 'Maktab')];

  final _mockData = {
    'my_rank': 12,
    'my_score': 1250,
    'entries': [
      {'rank': 1, 'name': 'Karimova Nargiza', 'school': '1-maktab', 'score': 3420},
      {'rank': 2, 'name': 'Toshmatov Behruz', 'school': '2-maktab', 'score': 3180},
      {'rank': 3, 'name': 'Yusupova Malika', 'school': '1-maktab', 'score': 2950},
      {'rank': 4, 'name': 'Nazarov Sardor', 'school': '3-maktab', 'score': 2740},
      {'rank': 5, 'name': 'Alimova Zulfiya', 'school': '2-maktab', 'score': 2610},
      {'rank': 6, 'name': 'Rahimov Bobur', 'school': '1-maktab', 'score': 2450},
      {'rank': 7, 'name': 'Hasanova Lobar', 'school': '4-maktab', 'score': 2300},
      {'rank': 8, 'name': 'Ergashev Jasur', 'school': '3-maktab', 'score': 2180},
      {'rank': 9, 'name': 'Mirzayev Akbar', 'school': '2-maktab', 'score': 2050},
      {'rank': 10, 'name': 'Qodirov Sherzod', 'school': '1-maktab', 'score': 1980},
    ],
  };
  Map _data = {};

  @override
  void initState() {
    super.initState();
    _data = _mockData;
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await studentApi.getLeaderboard(scope: _scope);
      if (mounted) setState(() => _data = d);
    } catch (_) {
      if (mounted) setState(() => _data = _mockData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = (_data['entries'] as List?)?.cast<Map>() ?? [];
    final myRank = (_data['my_rank'] as num?) ?? 0;
    final myScore = (_data['my_score'] as num?) ?? 0;
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();

    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text('Reyting', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            ),

            // Scope tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: _scopes.map((s) {
                final active = _scope == s.$1;
                return GestureDetector(
                  onTap: () { setState(() { _scope = s.$1; _data = _mockData; }); _load(); },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? kOrange : kBgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? kOrange : kBgBorder),
                    ),
                    child: Text(s.$2, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
                  ),
                );
              }).toList()),
            ),
            const SizedBox(height: 20),

            // Podium
            if (top3.length == 3) _Podium(entries: top3),
            const SizedBox(height: 12),

            // My rank banner
            if ((myRank as int) > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: kOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: kOrange.withOpacity(0.3))),
                  child: Row(children: [
                    const Icon(Icons.person_rounded, color: kOrange, size: 18),
                    const SizedBox(width: 8),
                    Text('Sen: #$myRank — $myScore XP', style: const TextStyle(color: kOrange, fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),

            // Rest of list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: rest.length,
                itemBuilder: (_, i) {
                  final e = rest[i];
                  final isMe = (e['rank'] as int?) == myRank;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? kOrange.withOpacity(0.05) : kBgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isMe ? kOrange.withOpacity(0.3) : kBgBorder),
                    ),
                    child: Row(children: [
                      SizedBox(width: 28, child: Text('#${e['rank']}', style: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w600))),
                      AvatarWidget(name: e['name'] as String, size: 32),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(e['name'] as String, style: TextStyle(color: isMe ? kOrange : kTextPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                        Text(e['school'] as String, style: const TextStyle(color: kTextMuted, fontSize: 11)),
                      ])),
                      Text('${e['score']} XP', style: const TextStyle(color: kTextSecondary, fontSize: 12)),
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

class _Podium extends StatelessWidget {
  final List<Map> entries;
  const _Podium({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PodiumSlot(entry: entries[1], height: 80, color: kTextSecondary, rank: 2),
          _PodiumSlot(entry: entries[0], height: 100, color: kYellow, rank: 1, showCrown: true),
          _PodiumSlot(entry: entries[2], height: 70, color: kOrange, rank: 3),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final Map entry;
  final double height;
  final Color color;
  final int rank;
  final bool showCrown;
  const _PodiumSlot({required this.entry, required this.height, required this.color, required this.rank, this.showCrown = false});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      if (showCrown) const Icon(Icons.emoji_events_rounded, color: kYellow, size: 22),
      AvatarWidget(name: entry['name'] as String, size: 44),
      const SizedBox(height: 6),
      Text((entry['name'] as String).split(' ').first, style: const TextStyle(color: kTextPrimary, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
      Text('${entry['score']} XP', style: TextStyle(color: color, fontSize: 10)),
      const SizedBox(height: 4),
      Container(
        height: height,
        decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)), border: Border.all(color: color.withOpacity(0.4))),
        child: Center(child: Text('#$rank', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold))),
      ),
    ]),
  );
}
