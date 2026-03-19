import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Map<String, List<Map>> _tasks = {
    'todo': [
      {'id': 1, 'title': 'Ota-onalar majlisi', 'priority': 'high', 'assignee': 'Mirzayev A.', 'due': '23 mart'},
      {'id': 2, 'title': "O'qituvchilar attestatsiyasi", 'priority': 'medium', 'assignee': 'Karimova N.', 'due': '30 mart'},
    ],
    'in_progress': [
      {'id': 3, 'title': "Dars jadvali yangilash", 'priority': 'medium', 'assignee': 'Botirov S.', 'due': '20 mart'},
      {'id': 4, 'title': 'AI tavsiyalar ko\'rib chiqish', 'priority': 'high', 'assignee': 'Mirzayev A.', 'due': '21 mart'},
      {'id': 5, 'title': 'BSB natijalari kiritish', 'priority': 'low', 'assignee': 'Nazarova M.', 'due': '22 mart'},
    ],
    'done': [
      {'id': 6, 'title': 'Sinflar inventarizatsiyasi', 'priority': 'low', 'assignee': 'Rahimov B.', 'due': '15 mart'},
    ],
  };

  void _moveTask(Map task, String fromCol, String toCol) {
    setState(() {
      _tasks[fromCol]!.remove(task);
      _tasks[toCol]!.insert(0, task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cols = [
      ('todo', 'Vazifalar', kBlue, Icons.radio_button_unchecked_rounded),
      ('in_progress', 'Jarayonda', kYellow, Icons.pending_rounded),
      ('done', 'Bajarildi', kGreen, Icons.check_circle_rounded),
    ];

    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Topshiriqlar', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: LayoutBuilder(builder: (_, c) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cols.map((col) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _KanbanColumn(
                        key: ValueKey(col.$1),
                        id: col.$1,
                        title: col.$2,
                        color: col.$3,
                        icon: col.$4,
                        tasks: _tasks[col.$1] ?? [],
                        allCols: ['todo', 'in_progress', 'done'],
                        onMove: (task, to) => _moveTask(task, col.$1, to),
                      ),
                    ),
                  )).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final IconData icon;
  final List<Map> tasks;
  final List<String> allCols;
  final void Function(Map, String) onMove;

  const _KanbanColumn({
    super.key,
    required this.id,
    required this.title,
    required this.color,
    required this.icon,
    required this.tasks,
    required this.allCols,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text('${tasks.length}', style: TextStyle(color: color, fontSize: 12)),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _TaskCard(
              task: tasks[i],
              currentCol: id,
              allCols: allCols,
              onMove: onMove,
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Map task;
  final String currentCol;
  final List<String> allCols;
  final void Function(Map, String) onMove;

  const _TaskCard({required this.task, required this.currentCol, required this.allCols, required this.onMove});

  Color _priorityColor(String p) {
    switch (p) { case 'high': return kRed; case 'medium': return kYellow; default: return kGreen; }
  }

  @override
  Widget build(BuildContext context) {
    final priority = task['priority'] ?? 'low';
    final color = _priorityColor(priority);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBgBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(task['title'] ?? '', style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w600))),
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            AvatarWidget(name: task['assignee'] ?? '', size: 24),
            const SizedBox(width: 6),
            Text(task['assignee'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
          ]),
          Row(children: [
            const Icon(Icons.calendar_today_rounded, color: kTextMuted, size: 11),
            const SizedBox(width: 4),
            Text(task['due'] ?? '', style: const TextStyle(color: kTextMuted, fontSize: 11)),
          ]),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          if (allCols.indexOf(currentCol) > 0)
            GestureDetector(
              onTap: () => onMove(task, allCols[allCols.indexOf(currentCol) - 1]),
              child: const Icon(Icons.arrow_back_rounded, color: kTextMuted, size: 16),
            ),
          const Spacer(),
          if (allCols.indexOf(currentCol) < allCols.length - 1)
            GestureDetector(
              onTap: () => onMove(task, allCols[allCols.indexOf(currentCol) + 1]),
              child: const Icon(Icons.arrow_forward_rounded, color: kOrange, size: 16),
            ),
        ]),
      ]),
    );
  }
}
