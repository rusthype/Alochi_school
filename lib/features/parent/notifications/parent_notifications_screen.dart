import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';
import '../../../core/api/parent_api.dart';

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});
  @override
  State<ParentNotificationsScreen> createState() => _State();
}

class _State extends State<ParentNotificationsScreen> {
  List _notifications = [
    {'id': 1, 'title': 'Test natijasi', 'body': 'Sarvar Algebra sinov 88 ball oldi', 'time': '2 soat oldin', 'read': false, 'type': 'test'},
    {'id': 2, 'title': 'Davomat', 'body': 'Nilufar bugun darsga kech keldi', 'time': 'Bugun, 09:15', 'read': false, 'type': 'attendance'},
    {'id': 3, 'title': 'Yangi yutuq', 'body': "Sarvar '7 kun streak' yutuqni qozondi", 'time': 'Kecha', 'read': true, 'type': 'achievement'},
    {'id': 4, 'title': 'AI tavsiya', 'body': "Nilufar kimyodan qo'shimcha mashq qilishi kerak", 'time': '2 kun oldin', 'read': true, 'type': 'ai'},
  ];

  @override
  void initState() {
    super.initState();
    parentApi.getNotifications().then((n) {
      if (mounted && n.isNotEmpty) setState(() => _notifications = n.cast<Map>());
    }).catchError((_) {});
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'test': return Icons.quiz_rounded;
      case 'attendance': return Icons.how_to_reg_rounded;
      case 'achievement': return Icons.emoji_events_rounded;
      case 'ai': return Icons.psychology_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'test': return kBlue;
      case 'attendance': return kGreen;
      case 'achievement': return kYellow;
      case 'ai': return kOrange;
      default: return kTextSecondary;
    }
  }

  Future<void> _markAllRead() async {
    try { await parentApi.markAllRead(); } catch (_) {}
    setState(() {
      _notifications = _notifications.map((n) => {...n, 'read': true}).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        backgroundColor: kBgSidebar,
        foregroundColor: kTextPrimary,
        elevation: 0,
        title: const Text('Bildirishnomalar'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text("Barchasini o'qildi", style: TextStyle(color: kOrange, fontSize: 13)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (_, i) {
          final n = _notifications[i] as Map;
          final read = n['read'] == true;
          final type = n['type'] as String? ?? '';
          final color = _typeColor(type);
          return GestureDetector(
            onTap: () => setState(() => _notifications[i] = {...n, 'read': true}),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: read ? kBgMain : kBgCard,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Icon(_typeIcon(type), color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n['title'] as String? ?? '', style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: read ? FontWeight.normal : FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(n['body'] as String? ?? '', style: const TextStyle(color: kTextMuted, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                ])),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(n['time'] as String? ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                  const SizedBox(height: 4),
                  if (!read)
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: kBlue, shape: BoxShape.circle)),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
