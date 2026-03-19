import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/constants/colors.dart';
import 'sidebar_widget.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          // Desktop / Tablet landscape — sidebar always visible
          return Scaffold(
            backgroundColor: kBgMain,
            body: Row(
              children: [
                const SidebarWidget(),
                Container(width: 1, color: kBgBorder),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          // Mobile — hamburger AppBar + Drawer
          return Scaffold(
            backgroundColor: kBgMain,
            appBar: AppBar(
              backgroundColor: kBgSidebar,
              foregroundColor: kTextPrimary,
              elevation: 0,
              title: Row(children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text("A'lochi Maktab", style: TextStyle(color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
              ]),
            ),
            drawer: const Drawer(
              backgroundColor: kBgSidebar,
              child: SidebarWidget(),
            ),
            body: child,
          );
        }
      },
    );
  }
}
