import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';
import '../../../core/api/student_api.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _State();
}

class _State extends State<ShopScreen> {
  String? _category;
  int _coins = 340;
  final _categories = ['Barchasi', 'Avatar', 'Rang', 'Effekt', 'Premium'];
  List _items = [
    {'id': 1, 'slug': 'avatar-cat', 'name': 'Mushuk Avatar', 'price': 50, 'category': 'Avatar', 'description': 'Mushukcha avatar', 'is_purchased': false},
    {'id': 2, 'slug': 'avatar-robot', 'name': 'Robot Avatar', 'price': 80, 'category': 'Avatar', 'description': 'Robot avatar', 'is_purchased': true},
    {'id': 3, 'slug': 'theme-dark', 'name': 'Qora Tema', 'price': 120, 'category': 'Rang', 'description': 'Maxsus qora tema', 'is_purchased': false},
    {'id': 4, 'slug': 'theme-purple', 'name': 'Binafsha Tema', 'price': 100, 'category': 'Rang', 'description': 'Binafsha rang', 'is_purchased': false},
    {'id': 5, 'slug': 'xp-boost', 'name': 'XP Boost x2', 'price': 200, 'category': 'Premium', 'description': '1 kunlik XP x2', 'is_purchased': false},
    {'id': 6, 'slug': 'streak-shield', 'name': 'Streak Shield', 'price': 150, 'category': 'Premium', 'description': 'Streak saqlovchi', 'is_purchased': false},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final wallet = await studentApi.getWallet();
      final items = await studentApi.getShopItems();
      if (mounted) setState(() {
        _coins = (wallet['coins'] as num?)?.toInt() ?? _coins;
        if (items.isNotEmpty) _items = items.cast<Map>();
      });
    } catch (_) {}
  }

  List get _filtered => _category == null || _category == 'Barchasi'
      ? _items
      : _items.where((i) => i['category'] == _category).toList();

  void _buy(Map item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kBgCard,
        title: const Text('Sotib olish', style: TextStyle(color: kTextPrimary)),
        content: Text("'${item['name']}' uchun ${item['price']} Coin sarflanadi. Tasdiqlaysizmi?", style: const TextStyle(color: kTextSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await studentApi.purchaseItem(item['slug'] as String);
                setState(() {
                  _coins -= (item['price'] as int);
                  final idx = _items.indexOf(item);
                  if (idx >= 0) _items[idx] = {...item, 'is_purchased': true};
                });
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${item['name']} sotib olindi"), backgroundColor: kGreen));
              } catch (_) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Xato"), backgroundColor: kRed));
              }
            },
            child: const Text('Sotib olish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                const Text('Shop', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: kYellow.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: kYellow.withOpacity(0.3))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.monetization_on_rounded, color: kYellow, size: 16),
                    const SizedBox(width: 4),
                    Text('$_coins', style: const TextStyle(color: kYellow, fontSize: 14, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            // Category chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = _categories[i];
                  final active = (c == 'Barchasi' && _category == null) || c == _category;
                  return GestureDetector(
                    onTap: () => setState(() => _category = c == 'Barchasi' ? null : c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? kOrange : kBgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? kOrange : kBgBorder),
                      ),
                      child: Text(c, style: TextStyle(color: active ? Colors.white : kTextSecondary, fontSize: 13)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final item = _filtered[i] as Map;
                  final purchased = item['is_purchased'] == true;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBgBorder)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Center(
                        child: Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(color: kOrange.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.stars_rounded, color: kOrange, size: 28),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(item['name'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(item['description'] as String, style: const TextStyle(color: kTextMuted, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      if (purchased)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: kGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text('Sotib olingan', style: TextStyle(color: kGreen, fontSize: 11)),
                        )
                      else
                        Row(children: [
                          const Icon(Icons.monetization_on_rounded, color: kYellow, size: 13),
                          const SizedBox(width: 3),
                          Text('${item['price']}', style: const TextStyle(color: kYellow, fontSize: 12, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _buy(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(8)),
                              child: const Text("Olish", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ]),
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
