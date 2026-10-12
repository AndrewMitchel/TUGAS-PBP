import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../fungsi/favorite.dart';
import '../fungsi/lastviewed.dart';
import '../fungsi/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/background.dart';
import 'home_page.dart';
import 'username_setup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool hidePassword = true, isLoading = false, isRegister = false;
  bool _navigating = false;
  StreamSubscription<AuthState>? _authSubscription;
  SupabaseClient get supabase => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.signedIn ||
          state.event == AuthChangeEvent.initialSession ||
          state.event == AuthChangeEvent.tokenRefreshed) {
        if (supabase.auth.currentSession != null) _continueAfterAuth();
      } else if (state.event == AuthChangeEvent.signedOut && mounted) {
        UserProfile.clear();
      }
    });
    if (supabase.auth.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _continueAfterAuth());
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) return _message('Email dan password wajib diisi.');
    setState(() => isLoading = true);
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      await _continueAfterAuth();
    } on AuthException catch (e) {
      _message(_friendlyAuthError(e.message));
    } catch (e) {
      _message('Login gagal. Periksa koneksi dan konfigurasi database.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (name.isEmpty) return _message('Nama/username wajib diisi.');
    if (email.isEmpty || !email.contains('@')) return _message('Masukkan email yang valid.');
    if (password.length < 6) return _message('Password minimal 6 karakter.');
    setState(() => isLoading = true);
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        // Simpan nama awal sebagai full_name. Username akan ditentukan
        // di halaman profil setelah pendaftaran, tanpa perlu login ulang.
        data: {'full_name': name},
      );
      if (response.session == null) {
        _message('Akun berhasil dibuat. Cek email untuk verifikasi; setelah verifikasi, lanjutkan pengaturan profil.');
      } else {
        await supabase.from('profiles').upsert({
          'id': response.user!.id,
          'full_name': name,
          'email': email,
        });
        await _continueAfterAuth();
      }
    } on AuthException catch (e) {
      _message(_friendlyAuthError(e.message));
    } catch (e) {
      _message('Pendaftaran gagal. Pastikan tabel profiles sudah dibuat.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? Uri.base.origin : 'io.supabase.flutter://callback',
      );
    } on AuthException catch (e) {
      _message('Login Google gagal: ${e.message}');
    } catch (e) {
      _message('Login Google gagal. Periksa konfigurasi OAuth Google di Supabase.');
    }
  }

  Future<void> _continueAfterAuth() async {
    if (_navigating || !mounted || supabase.auth.currentUser == null) return;
    _navigating = true;
    try {
      final profile = await UserProfile.load();
      await FavoriteFunction.loadFromDatabase();
      await LastViewedFunction.loadFromDatabase();
      if (!mounted) return;
      final name = (profile?['username'] ?? supabase.auth.currentUser?.userMetadata?['username'] ?? '').toString().trim();
      if (name.isEmpty) {
        _navigating = false;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const UsernameSetupPage()));
      } else {
        UserProfile.setUsername(name);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(username: name)));
      }
    } catch (e) {
      _navigating = false;
      _message('Tidak bisa memuat profil. Pastikan SQL setup sudah dijalankan di Supabase.');
    }
  }

  String _friendlyAuthError(String message) {
    final m = message.toLowerCase();
    if (m.contains('invalid login credentials')) return 'Email atau password salah, atau akun belum terdaftar.';
    if (m.contains('already registered') || m.contains('already been registered')) return 'Email ini sudah terdaftar. Silakan login.';
    if (m.contains('email not confirmed')) return 'Email belum diverifikasi. Cek kotak masuk email kamu.';
    return message;
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: AppTheme.greenDark,
    ));
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppTheme.grey),
    prefixIcon: Icon(icon, color: AppTheme.green),
    filled: true,
    fillColor: AppTheme.card,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Background(child: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/Logo.png', width: 88, height: 88, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 70, color: AppTheme.green)),
            )),
            const SizedBox(height: 25),
            RichText(text: const TextSpan(children: [
              TextSpan(text: 'Coffee', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppTheme.white)),
              TextSpan(text: 'Spot', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppTheme.green)),
            ])),
            const SizedBox(height: 5),
            Text(isRegister ? 'Buat akun untuk mulai menjelajah.' : 'Temukan coffee shop terbaik di sekitarmu.',
              style: const TextStyle(color: AppTheme.grey, fontSize: 14)),
            const SizedBox(height: 30),
            if (isRegister) ...[
              TextField(controller: nameController, textInputAction: TextInputAction.next,
                decoration: _decoration('Nama / username', Icons.person_outline)),
              const SizedBox(height: 13),
            ],
            TextField(controller: emailController, keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next, decoration: _decoration('Email', Icons.email_outlined)),
            const SizedBox(height: 13),
            TextField(controller: passwordController, obscureText: hidePassword,
              onSubmitted: (_) => isRegister ? register() : login(),
              decoration: _decoration('Password (minimal 6 karakter)', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(onPressed: () => setState(() => hidePassword = !hidePassword),
                  icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppTheme.grey)),
              )),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
              onPressed: isLoading ? null : (isRegister ? register : login),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.green, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
              child: isLoading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isRegister ? 'Daftar Akun' : 'Login', style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(
              onPressed: isLoading ? null : loginWithGoogle,
              icon: const Icon(Icons.g_mobiledata, size: 28),
              label: const Text('Lanjutkan dengan Google'),
              style: OutlinedButton.styleFrom(foregroundColor: AppTheme.white, side: BorderSide(color: AppTheme.green.withValues(alpha: .45)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            )),
            const SizedBox(height: 18),
            Center(child: Wrap(alignment: WrapAlignment.center, children: [
              Text(isRegister ? 'Sudah punya akun? ' : 'Belum punya akun? ', style: const TextStyle(color: AppTheme.grey)),
              GestureDetector(
                onTap: isLoading ? null : () => setState(() => isRegister = !isRegister),
                child: Text(isRegister ? 'Login' : 'Daftar sekarang',
                  style: const TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold)),
              ),
            ])),
          ]),
        ),
      )))),
    );
  }
}
