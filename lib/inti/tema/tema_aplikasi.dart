import 'package:flutter/material.dart';
import '../aturan/warna.dart';

class TemaAplikasi {
  static ThemeData get temaTerang {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: WarnaAplikasi.primer,
        primary: WarnaAplikasi.primer,
        secondary: WarnaAplikasi.primerMuda,
        surface: WarnaAplikasi.latarBelakang,
        error: WarnaAplikasi.error,
      ),
      scaffoldBackgroundColor: WarnaAplikasi.latarBelakang,
      cardTheme: CardThemeData(
        color: WarnaAplikasi.permukaan,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WarnaAplikasi.primer, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WarnaAplikasi.error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: WarnaAplikasi.teksSekunder),
        floatingLabelStyle: const TextStyle(color: WarnaAplikasi.primer),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WarnaAplikasi.primer,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: WarnaAplikasi.primer,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
