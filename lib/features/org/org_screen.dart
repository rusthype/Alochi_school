import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/badge_widget.dart';
import '../../core/api/school_api.dart';
import '../../core/utils/score_color.dart';

class OrgScreen extends StatefulWidget {
  const OrgScreen({super.key});
  @override
  State<OrgScreen> createState() => _OrgScreenState();
}

class _OrgScreenState extends State<OrgScreen> {
  Map<String, dynamic> _data = {};
  bool _loading = true;
  String _filter = 'Barchasi';
  final _searchCtrl = TextEditingController();

  final _mockStaff = [
    {'name': 'Mirzayev Azizbek', 'role': 'Direktor', 'dept': 'Rahbariyat', 'att': 98.0, 'lessons': 0, 'overtime': true, 'aiWarn': false},
    {'name': 'Karimova Nargiza', 'role': "O'qituvchi", 'dept': "O'qituvchilar", 'att': 96.0, 'lessons': 14, 'overtime': true, 'aiWarn': false},
    {'name': 'Toshmatova Gulnora', 'role': "O'qituvchi", 'dept': "O'qituvchilar", 'att': 84.0, 'lessons': 6, 'overtime': false, 'aiWarn': true},
    {'name': 'Ergashev Jasur', 'role': 'Psixolog', 'dept': 'Xodimlar', 'att': 62.0, 'lessons': 0, 'overtime': false, 'aiWarn': true},
    {'name': 'Nazarova Malika', 'role': "O'qituvchi", 'dept': "O'qituvchilar", 'att': 94.0, 'lessons': 16, 'overtime': false, 'aiWarn': false},
    {'name': 'Rahimov Bobur', 'role': 'Buxgalter', 'dept': 'Xodimlar', 'att': 100.0, 'lessons': 0, 'overtime': false, 'aiWarn': false},
    {'name': 'Hasanova Lobar', 'role': 'Kutubxonachi', 'dept': 'Xodimlar', 'att': 92.0, 'lessons': 0, 'overtime': false, 'aiWarn': false},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await schoolApi.getOrg();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _data = {'staff': _mockStaff}; _loading = false; });
    }
  }

  List get _staff {
    final all = (_data['staff'] as List?) ?? _mockStaff;
    var filtered = all;
    if (_filter != 'Barchasi') {
      filtered = all.where((s) => (s['dept'] ?? '') == _filter).toList();
    }
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((s) => (s['name'] ?? '').toLowerCase().contains(q) || (s['role'] ?? '').toLowerCase().contains(q)).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final allStaff = (_data['staff'] as List?) ?? _mockStaff;
    final jami = allStaff.length;
    final overtime = allStaff.where((s) => s['overtime'] == true).length;
    final aiWarns = allStaff.where((s) => s['aiWarn'] == true).length;

    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text('ORG Struktura', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Stats row
            Row(children: [
              _StatPill(label: 'Jami xodimlar', value: '$jami', color: kBlue),
              const SizedBox(width: 12),
              _StatPill(label: 'Ustama oluvchi', value: '$overtime', color: kGreen),
              const SizedBox(width: 12),
              _StatPill(label: 'AI ogohlantirish', value: '$aiWarns', color: kRed),
            ]),
            const SizedBox(height: 20),

            // Search + filter
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: kTextPrimary),
                  decoration: const InputDecoration(hintText: 'Xodim ismi yoki lavozim...', prefixIcon: Icon(Icons.search_rounded, color: kTextMuted, size: 20)),
                ),
              ),
              const SizedBox(width: 12),
              ...[('Barchasi', null), ('Rahbariyat', null), ("O'qituvchilar", null), ('Xodimlar', null)].map((f) {
                final active = _filter == f.$1;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f.$1),
                  child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: active ? kOrange : kBgCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: active ? kOrange : kBgBorder),
                    ),
                    child: Text(f.$1, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontSize: 13)),
                  ),
                );
              }),
            ]),
            const SizedBox(height: 20),

            // Staff list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kOrange))
                  : ListView.separated(
                      itemCount: _staff.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _StaffCard(staff: _staff[i] as Map),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 13)),
      ]),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final Map staff;
  const _StaffCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    final att = (staff['att'] ?? 0).toDouble();
    final lessons = staff['lessons'] ?? 0;
    final hasOvertime = staff['overtime'] == true;
    final hasWarn = staff['aiWarn'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBgBorder)),
      child: Row(
        children: [
          AvatarWidget(name: staff['name'] ?? '', size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(staff['name'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.w600))),
                if (hasOvertime) BadgeWidget(text: 'Ustama bor', color: kGreen, fontSize: 11),
                if (hasWarn) ...[const SizedBox(width: 6), BadgeWidget(text: 'AI Ogohlantirish', color: kRed, fontSize: 11)],
              ]),
              const SizedBox(height: 4),
              Text(staff['role'] ?? '', style: const TextStyle(color: kTextSecondary, fontSize: 13)),
              const SizedBox(height: 10),
              Row(children: [
                _StatItem(label: 'Davomat', value: '${att.toStringAsFixed(0)}%', color: scoreColor(att)),
                const SizedBox(width: 20),
                _StatItem(label: 'Dars/haf', value: '$lessons'),
                const SizedBox(width: 20),
                _StatItem(label: "Bo'lim", value: staff['dept'] ?? ''),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.label, required this.value, this.color = kTextSecondary});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
      Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
    ]);
  }
}
