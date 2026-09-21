import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const CoffeeFinderApp());
}

class CoffeeFinderApp extends StatelessWidget {
  const CoffeeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Finder',

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor:
            const Color(0xFFF5F0E6),
        useMaterial3: true,
      ),

      home: const LoginPage(),
    );
  }
}