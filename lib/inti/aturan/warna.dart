import 'package:flutter/material.dart';

class WarnaAplikasi {
  static const Color primer = Color(0xFF0066FF);
  static const Color primerMuda = Color(0xFFE5EFFF);
  static const Color primerTua = Color(0xFF0044B3);

  static const Color latarBelakang = Color(0xFFF4F6F9);
  static const Color permukaan = Colors.white;

  static const Color teksUtama = Color(0xFF1E293B);
  static const Color teksSekunder = Color(0xFF64748B);

  static const Color error = Color(0xFFFF4D4F);
  static const Color sukses = Color(0xFF52C41A);
  static const Color peringatan = Color(0xFFFAAD14);

  static const Gradient gradienBiru = LinearGradient(
    colors: [primer, Color(0xFF4D94FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
