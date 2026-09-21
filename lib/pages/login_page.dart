import 'package:flutter/material.dart';

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

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // VALIDASI LOGIN
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username dan password harus diisi',
          ),
          backgroundColor: AppTheme.greenDark,
        ),
      );
      return;
    }

    // MASUK KE HOME
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          username: username,
        ),
      ),
    );
  }

  @override
  void dispose() {
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
                      borderRadius: BorderRadius.circular(18),
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
                    hint: 'Username',
                    icon: Icons.person_outline,
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
                      onPressed: login,
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
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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