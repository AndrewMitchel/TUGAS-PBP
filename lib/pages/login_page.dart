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

  // =========================
  // CONTROLLER
  // =========================

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool hidePassword = true;

  // =========================
  // LOGIN
  // =========================

  void login() {

    String username =
        usernameController.text.trim();

    String password =
        passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Username dan password harus diisi',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (context) =>
            HomePage(
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

      body: Background(

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(25),

              child: Column(

                children: [

                  // =====================
                  // LOGO
                  // =====================

                  const Icon(
                    Icons.flutter_dash,
                    size: 80,
                    color: Color(0xFF42A5F5),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // =====================
                  // LOGIN CARD
                  // =====================

                  Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(25),

                    decoration:
                        BoxDecoration(

                      color: Colors.white
                          .withOpacity(0.12),

                      borderRadius:
                          BorderRadius.circular(20),

                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.1),
                      ),
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Login to your account',
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.6),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // =====================
                        // USERNAME
                        // =====================

                        const Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        TextField(

                          controller:
                              usernameController,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(

                            hintText:
                                'Username',

                            hintStyle:
                                TextStyle(
                              color: Colors.white
                                  .withOpacity(0.4),
                            ),

                            prefixIcon:
                                const Icon(
                              Icons.person_outline,
                              color:
                                  Colors.white60,
                            ),

                            filled: true,

                            fillColor:
                                Colors.white
                                    .withOpacity(0.12),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // =====================
                        // PASSWORD
                        // =====================

                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        TextField(

                          controller:
                              passwordController,

                          obscureText:
                              hidePassword,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(

                            hintText:
                                'Password',

                            hintStyle:
                                TextStyle(
                              color: Colors.white
                                  .withOpacity(0.4),
                            ),

                            prefixIcon:
                                const Icon(
                              Icons.lock_outline,
                              color:
                                  Colors.white60,
                            ),

                            suffixIcon:
                                IconButton(

                              icon: Icon(
                                hidePassword
                                    ? Icons
                                        .visibility_off
                                    : Icons
                                        .visibility,
                                color:
                                    Colors.white60,
                              ),

                              onPressed: () {

                                setState(() {

                                  hidePassword =
                                      !hidePassword;

                                });
                              },
                            ),

                            filled: true,

                            fillColor:
                                Colors.white
                                    .withOpacity(0.12),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // =====================
                        // LOGIN BUTTON
                        // =====================

                        SizedBox(

                          width:
                              double.infinity,

                          height: 52,

                          child:
                              ElevatedButton(

                            onPressed: login,

                            style:
                                ElevatedButton
                                    .styleFrom(

                              backgroundColor:
                                  AppTheme
                                      .primaryBlue,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(12),
                              ),
                            ),

                            child:
                                const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}