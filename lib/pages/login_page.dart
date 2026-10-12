import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/favorite.dart';
import '../fungsi/lastviewed.dart';

import '../fungsi/user_profile.dart';
import '../widgets/background.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;
  bool _navigating = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.signedIn && !_navigating) {
        final email = state.session?.user.email ?? Supabase.instance.client.auth.currentUser?.email;
        if (email != null && mounted) _openHome(email);
      }
    });
  }

  Future<void> login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan password harus diisi');
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) throw const AuthException('Login gagal.');
      // Navigation is handled by authStateChanges.
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage('Login gagal: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> register() async {
    final email = usernameController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.length < 6) {
      _showMessage('Masukkan email valid dan password minimal 6 karakter.');
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.session == null) {
        _showMessage('Akun dibuat. Cek email untuk verifikasi, lalu login.');
      } else {
        // Navigation is handled by authStateChanges.
      }
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage('Pendaftaran gagal: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://callback',
      );
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage('Login Google gagal: $e');
    }
  }

  Future<void> _openHome(String email) async {
    if (_navigating || !mounted) return;
    _navigating = true;
    await FavoriteFunction.loadFromDatabase();
    await LastViewedFunction.loadFromDatabase();
    final username = email.split('@').first;
    UserProfile.setUsername(username);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(username: username)),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.greenDark),
    );
  }


  @override
  void dispose() {
    _authSubscription?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: Background(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  // =========================
                  // ICON COFFEE
                  // =========================

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // TITLE
                  // =========================

                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Coffee',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Spot',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 0),

                  const Text(
                    'Find the best coffee shops\n'
                    'around you.',
                    style: TextStyle(
                      color: AppTheme.grey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // =========================
                  // USERNAME
                  // =========================

                  _inputField(
                    controller: usernameController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 14),

                  // =========================
                  // PASSWORD
                  // =========================

                  _inputField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: hidePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword =
                              !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.grey,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =========================
                  // LOGIN BUTTON
                  // =========================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : loginWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text('Lanjutkan dengan Google'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.white,
                        side: BorderSide(color: AppTheme.grey.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : register,
                      child: const Text('Belum punya akun? Daftar', style: TextStyle(color: AppTheme.green)),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // =========================
                  // FOOTER
                  // =========================

                  Center(
                    child: Text(
                      'Secangkir Kopi, Teman di Hari ini',
                      style: TextStyle(
                        color: AppTheme.grey
                            .withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // INPUT FIELD
  // =========================

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,

      style: const TextStyle(
        color: AppTheme.white,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: AppTheme.grey,
          fontSize: 14,
        ),

        prefixIcon: Icon(
          icon,
          color: AppTheme.green,
          size: 20,
        ),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor: AppTheme.card,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppTheme.green
                .withValues(alpha: 0.12),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppTheme.green,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}