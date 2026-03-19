import 'package:flutter/material.dart';
import '../../shared/constants/colors.dart';

Color scoreColor(num score) {
  if (score >= 90) return kGreen;
  if (score >= 75) return kTextPrimary;
  if (score >= 60) return kYellow;
  return kRed;
}

Color scoreBgColor(num score) {
  if (score >= 90) return kGreen.withOpacity(0.15);
  if (score >= 75) return kBgBorder;
  if (score >= 60) return kYellow.withOpacity(0.15);
  return kRed.withOpacity(0.15);
}
