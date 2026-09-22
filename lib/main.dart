
import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'theme/app_theme.dart';

// =====================================================
// MAIN
// =====================================================

void main() {
  runApp(const CoffeeFinderApp());
}

// =====================================================
// COFFEE FINDER APP
// =====================================================

class CoffeeFinderApp extends StatelessWidget {
  const CoffeeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Coffee Finder',

      // =====================================================
      // THEME
      // =====================================================

      theme: AppTheme.lightTheme,

      // =====================================================
      // HALAMAN AWAL
      // =====================================================

      home: const LoginPage(),
    );
  }
}
