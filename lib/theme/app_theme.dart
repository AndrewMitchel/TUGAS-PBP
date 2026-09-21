import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // WARNA UTAMA
  // =========================

  static const Color green = Color(0xFF006241);
  static const Color greenDark = Color(0xFF004F3A);

  // =========================
  // BACKGROUND
  // =========================

  static const Color background = Color(0xFFF5F0E6);
  static const Color darkBlue = Color(0xFFE8E1D3);

  // =========================
  // CARD
  // =========================

  static const Color card = Color(0xFFFFFCF5);
  static const Color cardLight = Color(0xFFE7DED0);

  // =========================
  // TEXT
  // =========================

  static const Color white = Color(0xFF2C241F);
  static const Color grey = Color(0xFF756F66);

  // =========================
  // COFFEE BROWN
  // =========================

  static const Color brown = Color(0xFF6F4E37);

  // =========================
  // RATING
  // =========================

  static const Color yellow = Color(0xFFC89B3C);

  // =========================
  // GRADIENT BACKGROUND
  // =========================

  static const LinearGradient backgroundGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5F0E6),
      Color(0xFFEDE3D2),
    ],
  );
}