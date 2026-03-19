import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../core/api/school_api.dart';
import '../../core/utils/score_color.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});
  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  List _classes = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  final _mockClasses = [
    {'id': 1, 'name': '11-A', 'students': 32, 'teacher': 'Karimova N.', 'avg': 84},
    {'id': 2, 'name': '11-B', 'students': 30, 'teacher': 'Toshmatova G.', 'avg': 71},
    {'id': 3, 'name': '10-A', 'students': 34, 'teacher': 'Ergashev J.', 'avg': 78},
    {'id': 4, 'name': '10-B', 'students': 31, 'teacher': 'Nazarova M.', 'avg': 75},
    {'id': 5, 'name': '9-A', 'students': 28, 'teacher': 'Botirov S.', 'avg': 80},
    {'id': 6, 'name': '9-B', 'students': 29, 'teacher': 'Alimova Z.', 'avg': 67},
    {'id': 7, 'name': '8-A', 'students': 33, 'teacher': 'Yusupov A.', 'avg': 73},
    {'id': 8, 'name': '8-B', 'students': 30, 'teacher': 'Rahimov B.', 'avg': 82},
    {'id': 9, 'name': '1-C', 'students': 35, 'teacher': 'Hasanova L.', 'avg': 47},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await schoolApi.getClasses();
      if (mounted) setState(() { _classes = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _classes = _mockClasses; _loading = false; });
    }
  }

  void _showCreateDialog() {
    showDialog(context: context, builder: (_) => _CreateClassDialog(onCreated: (cls) {
      setState(() => _classes.insert(0, cls));
    }));
  }

  void _showDeleteDialog(Map cls) {
    showDialog(context: context, builder: (_) => _DeleteClassDialog(
      schoolClass: cls,
      onDeleted: () => setState(() => _classes.removeWhere((c) => c['id'] == cls['id'])),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase();
    final filtered = _classes.where((c) => (c['name'] ?? '').toString().toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Sinflar', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Jami: ${_classes.length} ta sinf', style: const TextStyle(color: kTextSecondary, fontSize: 14)),
                ]),
                ElevatedButton.icon(
                  onPressed: _showCreateDialog,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Sinf qo\'shish'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: kTextPrimary),
              decoration: const InputDecoration(
                hintText: 'Sinf qidirish...',
                prefixIcon: Icon(Icons.search_rounded, color: kTextMuted, size: 20),
              ),
            ),
            const SizedBox(height: 20),

            // Grid
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kOrange))
                  : LayoutBuilder(builder: (context, c) {
                      final cols = c.maxWidth > 900 ? 3 : c.maxWidth > 600 ? 2 : 1;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.4,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _ClassCard(
                          cls: filtered[i] as Map,
                          onDelete: () => _showDeleteDialog(filtered[i] as Map),
                        ),
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassCard extends StatefulWidget {
  final Map cls;
  final VoidCallback onDelete;
  const _ClassCard({required this.cls, required this.onDelete});

  @override
  State<_ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<_ClassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final avg = (widget.cls['avg'] ?? widget.cls['avg_score'] ?? 0).toDouble();
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hovered ? kOrange.withOpacity(0.4) : kBgBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: kOrange.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.menu_book_rounded, color: kOrange, size: 20),
                ),
                if (_hovered)
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: kRed.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.delete_outline_rounded, color: kRed, size: 16),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.cls['name'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.people_rounded, color: kTextMuted, size: 14),
              const SizedBox(width: 4),
              Text('${widget.cls['students'] ?? 0} o\'quvchi', style: const TextStyle(color: kTextSecondary, fontSize: 12)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.school_rounded, color: kTextMuted, size: 14),
              const SizedBox(width: 4),
              Expanded(child: Text(widget.cls['teacher'] ?? '', style: const TextStyle(color: kTextSecondary, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ]),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("O'rtacha:", style: TextStyle(color: kTextMuted, fontSize: 12)),
                Text(avg.toStringAsFixed(1), style: TextStyle(color: scoreColor(avg), fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateClassDialog extends StatefulWidget {
  final void Function(Map) onCreated;
  const _CreateClassDialog({required this.onCreated});

  @override
  State<_CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<_CreateClassDialog> {
  final _nameCtrl = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: kBgBorder)),
      title: const Text("Yangi sinf qo'shish", style: TextStyle(color: kTextPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _nameCtrl,
          style: const TextStyle(color: kTextPrimary),
          decoration: const InputDecoration(hintText: 'Sinf nomi (masalan: 9-A)'),
          autofocus: true,
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
        ElevatedButton(
          onPressed: _saving ? null : () async {
            if (_nameCtrl.text.trim().isEmpty) return;
            setState(() => _saving = true);
            try {
              final cls = await schoolApi.createClass({'name': _nameCtrl.text.trim()});
              if (context.mounted) { widget.onCreated(cls); Navigator.pop(context); }
            } catch (_) {
              if (context.mounted) setState(() => _saving = false);
            }
          },
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Saqlash'),
        ),
      ],
    );
  }
}

class _DeleteClassDialog extends StatelessWidget {
  final Map schoolClass;
  final VoidCallback onDeleted;
  const _DeleteClassDialog({required this.schoolClass, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    final hasStudents = (schoolClass['students'] ?? 0) > 0;
    return AlertDialog(
      backgroundColor: kBgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: kBgBorder)),
      title: const Text("Sinfni o'chirish", style: TextStyle(color: kTextPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${schoolClass['name']} sinfini o'chirishni tasdiqlaysizmi?", style: const TextStyle(color: kTextSecondary)),
        if (hasStudents) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kRed.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.warning_rounded, color: kRed, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Bu sinfda ${schoolClass['students']} ta o\'quvchi bor!', style: const TextStyle(color: kRed, fontSize: 13))),
            ]),
          ),
        ],
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kRed),
          onPressed: hasStudents ? null : () async {
            await schoolApi.deleteClass(schoolClass['id']);
            if (context.mounted) { onDeleted(); Navigator.pop(context); }
          },
          child: const Text("O'chirish"),
        ),
      ],
    );
  }
}
