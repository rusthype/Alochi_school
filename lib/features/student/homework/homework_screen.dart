import 'package:flutter/material.dart';
import '../../../shared/constants/colors.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});
  @override
  State<HomeworkScreen> createState() => _State();
}

class _State extends State<HomeworkScreen> {
  bool _analyzing = false;
  Map? _result;

  static const _mockResult = {
    'grade': 'B+',
    'score': 85,
    'feedback': "Umumiy yaxshi! Izohlar to'liq yozilgan.",
    'tips': ["Hisob-kitoblarni batafsilroq ko'rsating", "Formulalarni to'g'ri yozing"],
  };

  Future<void> _analyze() async {
    setState(() { _analyzing = true; _result = null; });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _analyzing = false; _result = _mockResult; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Uy vazifasi — AI Tahlil', style: TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Uy vazifangizning rasmini yuklang, AI tahlil qiladi', style: TextStyle(color: kTextSecondary, fontSize: 14)),
              const SizedBox(height: 24),

              // Upload area
              GestureDetector(
                onTap: _analyzing ? null : _analyze,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kOrange.withOpacity(0.4), width: 2),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.cloud_upload_rounded, color: kOrange, size: 48),
                    const SizedBox(height: 12),
                    const Text("Rasm tanlash uchun bosing", style: TextStyle(color: kTextSecondary, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text("JPG, PNG, PDF qabul qilinadi", style: TextStyle(color: kTextMuted, fontSize: 12)),
                  ]),
                ),
              ),
              const SizedBox(height: 24),

              if (_analyzing)
                Center(child: Column(children: [
                  const CircularProgressIndicator(color: kOrange),
                  const SizedBox(height: 12),
                  const Text('AI tahlil qilmoqda...', style: TextStyle(color: kTextSecondary, fontSize: 14)),
                ])),

              if (_result != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: kBgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: kGreen.withOpacity(0.3))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.psychology_rounded, color: kOrange, size: 20),
                      const SizedBox(width: 8),
                      const Text('AI Tahlili', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: kOrange.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text(_result!['grade'] as String, style: const TextStyle(color: kOrange, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Text(_result!['feedback'] as String, style: const TextStyle(color: kTextPrimary, fontSize: 14, height: 1.5)),
                    const SizedBox(height: 16),
                    const Text("Tavsiyalar:", style: TextStyle(color: kTextSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...(_result!['tips'] as List).map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.lightbulb_outline_rounded, color: kYellow, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(tip as String, style: const TextStyle(color: kTextSecondary, fontSize: 13))),
                      ]),
                    )),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
