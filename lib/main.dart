import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';
import 'theme/app_theme.dart';

// =====================================================
// SUPABASE
// =====================================================

const String supabaseUrl = 'https://wrjwiiqzjobzoghhiode.supabase.co';

const String supabasePublishableKey ='sb_publishable_ZC4xVsnV_eWK5I_tk3KtoQ_QxY05dD-';

// =====================================================
// MAIN
// =====================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

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