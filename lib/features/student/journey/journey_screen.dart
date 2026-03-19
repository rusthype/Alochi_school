import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';
import '../../../core/api/student_api.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});
  @override
  State<JourneyScreen> createState() => _State();
}

class _State extends State<JourneyScreen> {
  final List<Map> _nodes = [
    {'id': 1, 'title': 'Algebra asoslari', 'xp': 100, 'status': 'completed', 'description': 'Algebraning asosiy tushunchalari'},
    {'id': 2, 'title': 'Chiziqli tenglamalar', 'xp': 120, 'status': 'completed', 'description': 'Bilinmajhul tenglamalar'},
    {'id': 3, 'title': 'Kvadrat tenglamalar', 'xp': 150, 'status': 'current', 'description': 'Ikkinchi darajali tenglamalar'},
    {'id': 4, 'title': 'Funksiyalar', 'xp': 180, 'status': 'locked', 'description': 'Funksiya va grafiklar'},
    {'id': 5, 'title': 'Logarifmlar', 'xp': 200, 'status': 'locked', 'description': 'Logarifmik funksiyalar'},
    {'id': 6, 'title': 'Trigonometriya', 'xp': 220, 'status': 'locked', 'description': 'Sin, cos, tan'},
  ];

  @override
  void initState() {
    super.initState();
    studentApi.getJourney().then((j) {
      if (mounted && j.isNotEmpty) setState(() => _nodes..clear()..addAll(j.cast<Map>()));
    }).catchError((_) {});
  }

  int get _completedCount => _nodes.where((n) => n['status'] == 'completed').length;

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
              child: Text("Bilim Yo'li", style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("$_completedCount / ${_nodes.length} mavzu o'tildi", style: const TextStyle(color: kTextSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: _nodes.isEmpty ? 0 : _completedCount / _nodes.length,
                  backgroundColor: kBgBorder,
                  valueColor: const AlwaysStoppedAnimation(kOrange),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _nodes.length,
                itemBuilder: (_, i) {
                  final node = _nodes[i] as Map;
                  final status = node['status'] as String;
                  final isLast = i == _nodes.length - 1;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: status indicator + connector
                      Column(children: [
                        _StatusCircle(status: status),
                        if (!isLast) Container(width: 2, height: 60, color: status == 'completed' ? kGreen : kBgBorder),
                      ]),
                      const SizedBox(width: 16),
                      // Right: content card
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: status == 'locked' ? kBgCard.withOpacity(0.5) : kBgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border(
                              left: BorderSide(
                                color: status == 'completed' ? kGreen : status == 'current' ? kOrange : kBgBorder,
                                width: status == 'current' ? 3 : 2,
                              ),
                              top: BorderSide(color: kBgBorder),
                              right: BorderSide(color: kBgBorder),
                              bottom: BorderSide(color: kBgBorder),
                            ),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(child: Text(node['title'] as String, style: TextStyle(color: status == 'locked' ? kTextMuted : kTextPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: kOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('+${node['xp']} XP', style: const TextStyle(color: kOrange, fontSize: 11, fontWeight: FontWeight.w600)),
                              ),
                            ]),
                            const SizedBox(height: 4),
                            Text(node['description'] as String, style: TextStyle(color: status == 'locked' ? kTextMuted : kTextSecondary, fontSize: 12)),
                            if (status == 'current') ...[
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
                                child: const Text('Davom ettirish', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ]),
                        ),
                      ),
                    ],
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

class _StatusCircle extends StatelessWidget {
  final String status;
  const _StatusCircle({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, iconColor;
    IconData icon;
    switch (status) {
      case 'completed':
        bg = kGreen; iconColor = Colors.white; icon = Icons.check_rounded;
        break;
      case 'current':
        bg = kOrange; iconColor = Colors.white; icon = Icons.play_arrow_rounded;
        break;
      default:
        bg = kBgBorder; iconColor = kTextMuted; icon = Icons.lock_rounded;
    }
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle, border: Border.all(color: bg, width: 2)),
      child: Icon(icon, color: iconColor, size: 16),
    );
  }
}
