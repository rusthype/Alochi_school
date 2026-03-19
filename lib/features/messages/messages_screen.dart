import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _contacts = [
    {'name': 'Karimova Nargiza', 'last': 'Rahmat, tushundim', 'time': '14:22', 'unread': 0},
    {'name': 'Botirov Sardor', 'last': 'Jadval o\'zgardimi?', 'time': '12:05', 'unread': 3},
    {'name': 'Nazarova Malika', 'last': 'BSB natijalar tayyor', 'time': 'Kecha', 'unread': 0},
    {'name': 'Rahimov Bobur', 'last': 'OK, ko\'rib chiqaman', 'time': 'Kecha', 'unread': 0},
    {'name': 'Alimova Zulfiya', 'last': 'Sinfda muammo bor', 'time': '2 kun', 'unread': 2},
  ];

  Map? _selected;
  final _msgCtrl = TextEditingController();

  final _mockMessages = [
    {'from': 'other', 'text': 'Salom, bugungi dars jadvalida o\'zgartirish bormi?', 'time': '14:10'},
    {'from': 'me', 'text': "Yo'q, jadval o'zgarmadi. Hamma narsa belgilangandek.", 'time': '14:15'},
    {'from': 'other', 'text': 'Tushunarli, rahmat!', 'time': '14:20'},
    {'from': 'me', 'text': 'Xush kelibsiz.', 'time': '14:22'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: Row(
        children: [
          // Contacts panel
          Container(
            width: 280,
            decoration: const BoxDecoration(
              color: kBgSidebar,
              border: Border(right: BorderSide(color: kBgBorder)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Xabarlar', style: TextStyle(color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      style: const TextStyle(color: kTextPrimary),
                      decoration: const InputDecoration(hintText: 'Qidirish...', prefixIcon: Icon(Icons.search_rounded, color: kTextMuted, size: 18), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                    ),
                  ]),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (_, i) {
                      final c = _contacts[i];
                      final active = _selected?['name'] == c['name'];
                      return GestureDetector(
                        onTap: () => setState(() => _selected = c),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          color: active ? kBgBorder : Colors.transparent,
                          child: Row(children: [
                            AvatarWidget(name: c['name'] as String, size: 40),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(child: Text(c['name'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                                Text(c['time'] as String, style: const TextStyle(color: kTextMuted, fontSize: 11)),
                              ]),
                              const SizedBox(height: 3),
                              Row(children: [
                                Expanded(child: Text(c['last'] as String, style: const TextStyle(color: kTextMuted, fontSize: 12), overflow: TextOverflow.ellipsis)),
                                if ((c['unread'] as int) > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(10)),
                                    child: Text('${c['unread']}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                                  ),
                              ]),
                            ])),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Message thread
          Expanded(
            child: _selected == null
                ? const Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.chat_bubble_outline_rounded, color: kTextMuted, size: 48),
                      SizedBox(height: 12),
                      Text('Suhbat tanlang', style: TextStyle(color: kTextSecondary, fontSize: 16)),
                    ]),
                  )
                : Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(color: kBgSidebar, border: Border(bottom: BorderSide(color: kBgBorder))),
                        child: Row(children: [
                          AvatarWidget(name: _selected!['name'] as String, size: 36),
                          const SizedBox(width: 12),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(_selected!['name'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                            Row(children: [
                              Container(width: 7, height: 7, decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle)),
                              const SizedBox(width: 5),
                              const Text('Online', style: TextStyle(color: kGreen, fontSize: 11)),
                            ]),
                          ]),
                        ]),
                      ),

                      // Messages
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _mockMessages.length,
                          itemBuilder: (_, i) {
                            final m = _mockMessages[i];
                            final isMe = m['from'] == 'me';
                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: const BoxConstraints(maxWidth: 360),
                                decoration: BoxDecoration(
                                  color: isMe ? kOrange : kBgCard,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                                  Text(m['text'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(m['time'] ?? '', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10)),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),

                      // Input
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(color: kBgSidebar, border: Border(top: BorderSide(color: kBgBorder))),
                        child: Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _msgCtrl,
                              style: const TextStyle(color: kTextPrimary),
                              decoration: const InputDecoration(hintText: 'Xabar yozing...', contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () { _msgCtrl.clear(); },
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
