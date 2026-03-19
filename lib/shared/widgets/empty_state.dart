import 'package:flutter/material.dart';
import '../constants/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kBgBorder),
            ),
            child: Icon(icon, color: kTextMuted, size: 32),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: const TextStyle(color: kTextSecondary, fontSize: 14)),
          ],
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 20),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
