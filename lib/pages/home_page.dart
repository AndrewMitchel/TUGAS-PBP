import 'package:flutter/material.dart';

import '../widgets/background.dart';
import '../widgets/menu_card.dart';

class HomePage extends StatelessWidget {
  // =========================
  // USERNAME DARI LOGIN
  // =========================

  final String username;

  const HomePage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // =========================
                // HEADER
                // =========================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Welcome to my personal space!',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    // PROFILE ICON
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 229, 5, 5).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 236, 11, 11),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // =========================
                // ABOUT ME
                // =========================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1749C9),
                        Color(0xFF155EFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [

                      // ICON
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 18),

                      // TEXT
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Me',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              'Student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 2),

                            Text(
                              'Flutter Developer',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // MENU
                // =========================

                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // MENU CARDS
                // =========================

                GridView.count(
                  crossAxisCount: 2,

                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

                  children: const [

                    // ABOUT ME
                    MenuCard(
                      icon: Icons.person_outline,
                      title: 'About Me',
                      subtitle: 'Tentang saya',
                    ),

                    // PROJECTS
                    MenuCard(
                      icon: Icons.code,
                      title: 'Projects',
                      subtitle: 'Project saya',
                    ),

                    // SKILLS
                    MenuCard(
                      icon: Icons.build_outlined,
                      title: 'Skills',
                      subtitle: 'Kemampuan saya',
                    ),

                    // EDUCATION
                    MenuCard(
                      icon: Icons.school_outlined,
                      title: 'Education',
                      subtitle: 'Pendidikan saya',
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color(0xFF0C194D),

        selectedItemColor:
            const Color(0xFF3D7BFF),

        unselectedItemColor:
            Colors.white54,

        currentIndex: 0,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}