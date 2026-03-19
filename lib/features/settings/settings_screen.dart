import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/constants/colors.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/badge_widget.dart';
import '../auth/auth_provider.dart';
import '../../core/api/auth_api.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _tab = 0;
  final _tabs = ['Profil', 'Maktab', 'Til', 'Xavfsizlik'];
  final _tabIcons = [Icons.person_rounded, Icons.business_rounded, Icons.language_rounded, Icons.security_rounded];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sozlamalar', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab sidebar
                SizedBox(
                  width: 180,
                  child: Column(
                    children: List.generate(_tabs.length, (i) {
                      final active = _tab == i;
                      return GestureDetector(
                        onTap: () => setState(() => _tab = i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: active ? kOrange.withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            Icon(_tabIcons[i], color: active ? kOrange : kTextMuted, size: 18),
                            const SizedBox(width: 10),
                            Text(_tabs[i], style: TextStyle(color: active ? kOrange : kTextSecondary, fontSize: 14, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
                          ]),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 24),
                // Tab content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
                    child: [
                      _ProfileTab(),
                      _SchoolTab(),
                      _LangTab(),
                      _SecurityTab(),
                    ][_tab],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<_ProfileTab> {
  late final _firstCtrl = TextEditingController();
  late final _lastCtrl = TextEditingController();
  late final _emailCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _firstCtrl.text = user?['first_name'] ?? user?['name']?.split(' ').first ?? '';
    _lastCtrl.text = user?['last_name'] ?? '';
    _emailCtrl.text = user?['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final name = user?['name'] ?? user?['username'] ?? 'Admin';
    final role = user?['role'] ?? 'school_admin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          AvatarWidget(name: name, size: 64),
          const SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            // ROLE — READ ONLY, never editable
            BadgeWidget(text: _roleLabel(role), color: kOrange),
          ]),
        ]),
        const SizedBox(height: 24),
        _Field(label: 'Ism', ctrl: _firstCtrl),
        const SizedBox(height: 12),
        _Field(label: 'Familiya', ctrl: _lastCtrl),
        const SizedBox(height: 12),
        _Field(label: 'Email', ctrl: _emailCtrl, type: TextInputType.emailAddress),
        const SizedBox(height: 12),
        // Role — absolutely read-only display
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Lavozim', style: TextStyle(color: kTextSecondary, fontSize: 13)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: kBgMain.withOpacity(0.5), borderRadius: BorderRadius.circular(10), border: Border.all(color: kBgBorder.withOpacity(0.5))),
            child: Text(_roleLabel(role), style: const TextStyle(color: kTextMuted, fontSize: 14)),
          ),
        ]),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saving ? null : () async {
            setState(() => _saving = true);
            try {
              // role intentionally excluded
              await authApi.updateMe({'first_name': _firstCtrl.text, 'last_name': _lastCtrl.text, 'email': _emailCtrl.text});
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saqlandi'), backgroundColor: kGreen));
            } catch (_) {
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xato'), backgroundColor: kRed));
            } finally {
              if (mounted) setState(() => _saving = false);
            }
          },
          child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Saqlash'),
        ),
      ],
    );
  }
}

String _roleLabel(String role) {
  const labels = {
    'school_admin': 'Maktab Administratori',
    'admin': 'Administrator',
    'director': 'Direktor',
    'direktor': 'Direktor',
    'zavuch': 'Zavuch',
    'teacher': "O'qituvchi",
  };
  return labels[role] ?? role;
}

class _SchoolTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Maktab ma\'lumotlari', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 20),
      _Field(label: 'Maktab nomi', ctrl: TextEditingController()),
      const SizedBox(height: 12),
      _Field(label: 'Manzil', ctrl: TextEditingController()),
      const SizedBox(height: 12),
      _Field(label: 'Telefon', ctrl: TextEditingController(), type: TextInputType.phone),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () {}, child: const Text('Saqlash')),
    ]);
  }
}

class _LangTab extends StatefulWidget {
  @override
  State<_LangTab> createState() => _LangTabState();
}

class _LangTabState extends State<_LangTab> {
  String _lang = 'uz';

  @override
  Widget build(BuildContext context) {
    final langs = [
      ('uz', "O'zbekcha", 'UZ'),
      ('ru', 'Русский', 'RU'),
      ('en', 'English', 'EN'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Til tanlash', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 20),
      ...langs.map((l) {
        final active = _lang == l.$1;
        return GestureDetector(
          onTap: () => setState(() => _lang = l.$1),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: active ? kOrange.withOpacity(0.1) : kBgMain,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: active ? kOrange : kBgBorder),
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: active ? kOrange : kBgBorder, borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(l.$3, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(l.$2, style: TextStyle(color: active ? kTextPrimary : kTextSecondary, fontSize: 15, fontWeight: active ? FontWeight.w600 : FontWeight.normal))),
              if (active) const Icon(Icons.check_circle_rounded, color: kOrange, size: 20),
            ]),
          ),
        );
      }),
    ]);
  }
}

class _SecurityTab extends StatefulWidget {
  @override
  State<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<_SecurityTab> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showOld = false, _showNew = false, _showConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Parolni o'zgartirish", style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 20),
      _PassField(label: 'Joriy parol', ctrl: _oldCtrl, show: _showOld, onToggle: () => setState(() => _showOld = !_showOld)),
      const SizedBox(height: 12),
      _PassField(label: 'Yangi parol', ctrl: _newCtrl, show: _showNew, onToggle: () => setState(() => _showNew = !_showNew)),
      const SizedBox(height: 12),
      _PassField(label: 'Yangi parolni tasdiqlang', ctrl: _confirmCtrl, show: _showConfirm, onToggle: () => setState(() => _showConfirm = !_showConfirm)),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: kBlue),
        child: const Text("Parolni o'zgartirish"),
      ),
    ]);
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final TextInputType type;
  const _Field({required this.label, required this.ctrl, this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 13)),
      const SizedBox(height: 6),
      TextField(controller: ctrl, keyboardType: type, style: const TextStyle(color: kTextPrimary)),
    ],
  );
}

class _PassField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool show;
  final VoidCallback onToggle;
  const _PassField({required this.label, required this.ctrl, required this.show, required this.onToggle});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 13)),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        obscureText: !show,
        style: const TextStyle(color: kTextPrimary),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(show ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kTextMuted, size: 18),
            onPressed: onToggle,
          ),
        ),
      ),
    ],
  );
}
