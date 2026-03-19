import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../core/api/school_api.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedClass = '11-A';
  DateTime _selectedDate = DateTime.now();
  Map<String, String> _status = {};
  bool _saving = false;

  final _classes = ['11-A', '11-B', '10-A', '10-B', '9-A', '9-B'];
  final _mockStudents = [
    {'id': 1, 'name': 'Karimova Nargiza'},
    {'id': 2, 'name': 'Toshmatov Behruz'},
    {'id': 3, 'name': 'Yusupova Malika'},
    {'id': 4, 'name': 'Nazarov Sardor'},
    {'id': 5, 'name': 'Alimova Zulfiya'},
    {'id': 6, 'name': 'Rahimov Bobur'},
    {'id': 7, 'name': 'Hasanova Lobar'},
    {'id': 8, 'name': 'Ergashev Jasur'},
  ];

  @override
  void initState() {
    super.initState();
    for (final s in _mockStudents) { _status[s['id']?.toString() ?? ''] = 'present'; }
  }

  int get _presentCount => _status.values.where((s) => s == 'present').length;
  int get _absentCount => _status.values.where((s) => s == 'absent').length;
  int get _lateCount => _status.values.where((s) => s == 'late').length;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await schoolApi.saveAttendance({
        'class': _selectedClass,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'attendance': _status.entries.map((e) => {'student': e.key, 'status': e.value}).toList(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Davomat saqlandi'), backgroundColor: kGreen));
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xato'), backgroundColor: kRed));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
            const Text('Davomat', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Controls
            Row(children: [
              DropdownButton<String>(
                value: _selectedClass,
                dropdownColor: kBgCard,
                style: const TextStyle(color: kTextPrimary),
                underline: const SizedBox(),
                items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedClass = v!),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.dark(primary: kOrange, surface: kBgCard)),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: kBgBorder)),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_rounded, color: kTextMuted, size: 16),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: const TextStyle(color: kTextPrimary, fontSize: 13)),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // Stats
            Row(children: [
              _StatBadge(label: 'Keldi', value: _presentCount, color: kGreen),
              const SizedBox(width: 12),
              _StatBadge(label: 'Kelmadi', value: _absentCount, color: kRed),
              const SizedBox(width: 12),
              _StatBadge(label: 'Kech keldi', value: _lateCount, color: kYellow),
            ]),
            const SizedBox(height: 16),

            // Student list
            Expanded(
              child: ListView.separated(
                itemCount: _mockStudents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final s = _mockStudents[i];
                  final id = s['id']?.toString() ?? '';
                  final current = _status[id] ?? 'present';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBgBorder)),
                    child: Row(children: [
                      AvatarWidget(name: s['name'] as String, size: 36),
                      const SizedBox(width: 12),
                      Expanded(child: Text(s['name'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
                      Row(children: [
                        _StatusButton(label: 'Keldi', value: 'present', current: current, color: kGreen, onTap: () => setState(() => _status[id] = 'present')),
                        const SizedBox(width: 6),
                        _StatusButton(label: 'Kelmadi', value: 'absent', current: current, color: kRed, onTap: () => setState(() => _status[id] = 'absent')),
                        const SizedBox(width: 6),
                        _StatusButton(label: 'Kech', value: 'late', current: current, color: kYellow, onTap: () => setState(() => _status[id] = 'late')),
                      ]),
                    ]),
                  );
                },
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Saqlash'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
    child: Row(children: [
      Text('$value', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
    ]),
  );
}

class _StatusButton extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final Color color;
  final VoidCallback onTap;
  const _StatusButton({required this.label, required this.value, required this.current, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = current == value;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color : kBgMain,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? color : kBgBorder),
        ),
        child: Text(label, style: TextStyle(color: active ? Colors.white : kTextMuted, fontSize: 12, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
