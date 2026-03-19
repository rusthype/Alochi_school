import 'dart:math';
import 'package:flutter/material.dart';

const _avatarColors = [
  Color(0xFFF97316),
  Color(0xFF3B82F6),
  Color(0xFF22C55E),
  Color(0xFFA855F7),
  Color(0xFFEF4444),
  Color(0xFFEAB308),
  Color(0xFF14B8A6),
  Color(0xFFEC4899),
];

Color avatarColor(String name) {
  if (name.isEmpty) return _avatarColors[0];
  return _avatarColors[name.codeUnitAt(0) % _avatarColors.length];
}

String avatarInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name.substring(0, min(2, name.length)).toUpperCase();
}
