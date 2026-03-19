import 'package:flutter/material.dart';
import '../shared/constants/colors.dart';

ThemeData buildTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBgMain,
      colorScheme: const ColorScheme.dark(
        primary: kOrange,
        surface: kBgCard,
        background: kBgMain,
        onPrimary: Colors.white,
        onSurface: kTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: kBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kBgBorder),
        ),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kTextPrimary),
        bodyMedium: TextStyle(color: kTextSecondary),
        bodySmall: TextStyle(color: kTextMuted),
        titleLarge: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: kTextSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kBgMain,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBgBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBgBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kOrange),
        ),
        labelStyle: const TextStyle(color: kTextSecondary),
        hintStyle: const TextStyle(color: kTextMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kOrange,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: kBgBorder,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kBgBorder,
        selectedColor: kOrange,
        labelStyle: const TextStyle(color: kTextSecondary),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kBgSidebar,
        foregroundColor: kTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kBgSidebar,
        indicatorColor: kOrange.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: kOrange);
          }
          return const IconThemeData(color: kTextMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: kOrange, fontSize: 12, fontWeight: FontWeight.w600);
          }
          return const TextStyle(color: kTextMuted, fontSize: 12);
        }),
      ),
      useMaterial3: true,
    );
